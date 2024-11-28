attribute vec3 kzPosition;
attribute vec3 kzNormal;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzNormalMatrix;
uniform highp vec3 kzCameraPosition;

varying mediump vec3 vNormal;
varying mediump vec3 vViewDirection;

#if KANZI_SHADER_USE_MORPHING
attribute vec3 kzMorphTarget0Position;
attribute vec3 kzMorphTarget1Position;
attribute vec3 kzMorphTarget2Position;
attribute vec3 kzMorphTarget0Normal;
attribute vec3 kzMorphTarget1Normal;
attribute vec3 kzMorphTarget2Normal;
uniform mediump float kzMorphWeights[3];
#endif

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE || KANZI_SHADER_USE_NORMALMAP_TEXTURE
attribute vec2 kzTextureCoordinate0;
varying mediump vec2 vTexCoord;
uniform mediump vec2 TextureOffset;
uniform mediump vec2 TextureTiling;
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE
attribute vec3 kzTangent; 
varying mediump vec3 vTangent;
varying mediump vec3 vBinormal;
#endif

#if KANZI_SHADER_SKINNING_BONE_COUNT 
attribute vec4 kzWeight;
attribute vec4 kzMatrixIndices;
uniform highp vec4 kzMatrixPalette[KANZI_SHADER_SKINNING_BONE_COUNT*4]; 
#endif

#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
uniform mediump vec3 DirectionalLightDirection[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
varying mediump vec3 vDirectionalLightDirection[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
#endif

#if KANZI_SHADER_NUM_POINT_LIGHTS
uniform mediump vec3 PointLightPosition[KANZI_SHADER_NUM_POINT_LIGHTS];
varying mediump vec3 vPointLightDirection[KANZI_SHADER_NUM_POINT_LIGHTS];
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
uniform mediump vec3 SpotLightPosition[KANZI_SHADER_NUM_SPOT_LIGHTS];
varying mediump vec3 vSpotLightDirection[KANZI_SHADER_NUM_SPOT_LIGHTS];
#endif

void main()
{
    precision mediump float;

#if KANZI_SHADER_SKINNING_BONE_COUNT
    mat4 localToSkinMatrix;
    int i1 = 3 * int(kzMatrixIndices.x);
    int i2 = 3 * int(kzMatrixIndices.y);
    int i3 = 3 * int(kzMatrixIndices.z);
    int i4 = 3 * int(kzMatrixIndices.w);
    vec4 b1 = kzWeight.x * kzMatrixPalette[i1] + kzWeight.y * kzMatrixPalette[i2]
        + kzWeight.z * kzMatrixPalette[i3] + kzWeight.w * kzMatrixPalette[i4];
    vec4 b2 = kzWeight.x * kzMatrixPalette[i1 + 1] + kzWeight.y * kzMatrixPalette[i2 + 1]
        + kzWeight.z * kzMatrixPalette[i3 + 1] + kzWeight.w * kzMatrixPalette[i4 + 1];
    vec4 b3 = kzWeight.x * kzMatrixPalette[i1 + 2] + kzWeight.y * kzMatrixPalette[i2 + 2]
        + kzWeight.z * kzMatrixPalette[i3 + 2] + kzWeight.w * kzMatrixPalette[i4 + 2];
   
    localToSkinMatrix[0] = vec4(b1.xyz, 0.0);
    localToSkinMatrix[1] = vec4(b2.xyz, 0.0);
    localToSkinMatrix[2] = vec4(b3.xyz, 0.0);
    localToSkinMatrix[3] = vec4(b1.w, b2.w, b3.w, 1.0);    
    localToSkinMatrix = kzWorldMatrix * localToSkinMatrix;
    
    vec4 positionWorld = localToSkinMatrix * vec4(kzPosition.xyz, 1.0);
    vViewDirection = positionWorld.xyz - kzCameraPosition;    
    vec4 N = mat4(localToSkinMatrix[0],
                  localToSkinMatrix[1], 
                  localToSkinMatrix[2], 
                  vec4(0.0, 0.0, 0.0, 1.0)) * vec4(kzNormal.xyz, 0.0);
    vNormal = normalize(N.xyz);
    gl_Position = kzProjectionCameraWorldMatrix * vec4(positionWorld.xyz, 1.0);
#elif KANZI_SHADER_USE_MORPHING
    vec3 position = kzMorphTarget0Position * kzMorphWeights[0] + kzMorphTarget1Position * kzMorphWeights[1] + kzMorphTarget2Position * kzMorphWeights[2];
    vec4 positionWorld = kzWorldMatrix * vec4(position.xyz, 1.0);
    vec3 V = normalize(positionWorld.xyz - kzCameraPosition);
    vec3 normal =normalize( (kzMorphTarget0Normal * kzMorphWeights[0]) +
                            (kzMorphTarget1Normal * kzMorphWeights[1]) +
                            (kzMorphTarget2Normal * kzMorphWeights[2]));
    vec4 N = kzNormalMatrix * vec4(normal.xyz, 0.0);
    vNormal = normalize(N.xyz);
    vViewDirection = positionWorld.xyz - kzCameraPosition;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(position.xyz, 1.0);
#else
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);  
    vec4 positionWorld = kzWorldMatrix * vec4(kzPosition.xyz, 1.0);
    vViewDirection = positionWorld.xyz - kzCameraPosition;
    vec4 N = kzNormalMatrix * vec4(kzNormal, 0.0);
    vNormal = N.xyz;
    
#endif

#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS; ++i)
    {
        vDirectionalLightDirection[i] = normalize(-DirectionalLightDirection[i]);
    }
#endif

#if KANZI_SHADER_NUM_POINT_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_POINT_LIGHTS; ++i)
    {
        vPointLightDirection[i] = positionWorld.xyz - PointLightPosition[i];
    }
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_SPOT_LIGHTS; ++i)
    {
        vSpotLightDirection[i] = positionWorld.xyz - SpotLightPosition[i];
    }
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE
    vTangent = normalize((kzNormalMatrix * vec4(kzTangent.xyz, 0.0)).xyz);
    vBinormal = cross(vNormal, vTangent);
#endif
    
#if KANZI_SHADER_USE_BASECOLOR_TEXTURE || KANZI_SHADER_USE_NORMALMAP_TEXTURE
    vTexCoord = kzTextureCoordinate0 * TextureTiling + TextureOffset;
#endif
}