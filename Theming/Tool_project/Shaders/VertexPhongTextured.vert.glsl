attribute vec3 kzPosition;
attribute vec3 kzNormal;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzNormalMatrix;
uniform highp vec3 kzCameraPosition;

#if KANZI_SHADER_USE_MORPHING
attribute vec3 kzMorphTarget0Position;
attribute vec3 kzMorphTarget1Position;
attribute vec3 kzMorphTarget2Position;
attribute vec3 kzMorphTarget0Normal;
attribute vec3 kzMorphTarget1Normal;
attribute vec3 kzMorphTarget2Normal;
uniform mediump float kzMorphWeights[3];
#endif

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE
attribute vec2 kzTextureCoordinate0;
varying mediump vec2 vTexCoord;
uniform mediump vec2 TextureOffset;
uniform mediump vec2 TextureTiling;
#endif

#if KANZI_SHADER_SKINNING_BONE_COUNT 
attribute vec4 kzWeight;
attribute vec4 kzMatrixIndices;
uniform highp vec4 kzMatrixPalette[KANZI_SHADER_SKINNING_BONE_COUNT*3];
#endif

#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
uniform mediump vec3 DirectionalLightDirection[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
uniform lowp    vec4 DirectionalLightColor     [KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
#endif

#if KANZI_SHADER_NUM_POINT_LIGHTS
uniform lowp vec4 PointLightColor[KANZI_SHADER_NUM_POINT_LIGHTS];
uniform mediump vec3 PointLightAttenuation[KANZI_SHADER_NUM_POINT_LIGHTS];
uniform mediump vec3 PointLightPosition[KANZI_SHADER_NUM_POINT_LIGHTS];
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
uniform mediump vec3  SpotLightPosition[KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform mediump vec4  SpotLightColor         [KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform mediump vec3  SpotLightDirection     [KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform mediump vec3  SpotLightConeParameters[KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform mediump vec3  SpotLightAttenuation   [KANZI_SHADER_NUM_SPOT_LIGHTS];
#endif

uniform lowp float BlendIntensity;
uniform lowp vec4 Emissive;
uniform lowp vec4 Ambient;
uniform lowp vec4 Diffuse;
uniform lowp vec4 SpecularColor;
uniform mediump float SpecularExponent;

varying mediump vec3 vViewDirection;
varying lowp vec3 vAmbDif;
varying lowp vec3 vSpec;
varying lowp vec3 vNormal; 

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
    mat4 localToWorldMatrix = kzWorldMatrix * localToSkinMatrix;
    
    vec4 positionWorld = localToWorldMatrix * vec4(kzPosition.xyz, 1.0);
    vViewDirection = positionWorld.xyz - kzCameraPosition; 
    vec3 V = normalize(vViewDirection);
    vec4 Norm = mat4(localToWorldMatrix[0],
                  localToWorldMatrix[1], 
                  localToWorldMatrix[2], 
                  vec4(0.0, 0.0, 0.0, 1.0)) * vec4(kzNormal.xyz, 0.0);
    vNormal = normalize(Norm.xyz);
    gl_Position = kzProjectionCameraWorldMatrix * localToSkinMatrix * vec4(kzPosition.xyz, 1.0);
#elif KANZI_SHADER_USE_MORPHING
    vec3 position = kzMorphTarget0Position * kzMorphWeights[0] + kzMorphTarget1Position * kzMorphWeights[1] + kzMorphTarget2Position * kzMorphWeights[2];
    vec4 positionWorld = kzWorldMatrix * vec4(position.xyz, 1.0);
    vec3 V = normalize(positionWorld.xyz - kzCameraPosition);
    vec3 normal =normalize( (kzMorphTarget0Normal * kzMorphWeights[0]) +
                            (kzMorphTarget1Normal * kzMorphWeights[1]) +
                            (kzMorphTarget2Normal * kzMorphWeights[2]));
    vec4 Norm = kzNormalMatrix * vec4(normal.xyz, 0.0);
    vNormal = normalize(Norm.xyz);
    vViewDirection = positionWorld.xyz - kzCameraPosition;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(position.xyz, 1.0);
#else
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);  
    vec4 positionWorld = kzWorldMatrix * vec4(kzPosition.xyz, 1.0);
    vViewDirection = positionWorld.xyz - kzCameraPosition;
    vec3 V = normalize(vViewDirection);
    vec4 Norm = kzNormalMatrix * vec4(kzNormal, 0.0);
    vNormal = normalize(Norm.xyz);
#endif
    
#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS || KANZI_SHADER_NUM_POINT_LIGHTS || KANZI_SHADER_NUM_SPOT_LIGHTS
    vec3 L = vec3(1.0, 0.0, 0.0);
    vec3 H = vec3(1.0, 0.0, 0.0);
    float LdotN, NdotH;
    float specular;
    vec3 c;
    float d, attenuation;
    vAmbDif = Ambient.rgb;
    vSpec = vec3(0.0);    
    vec3 pointLightDirection;  
    vec3 spotLightDirection;
#endif   

    
    
#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS; ++i)
    {
        if(length(DirectionalLightDirection[i])> 0.01)
        {
            L = normalize(-DirectionalLightDirection[i]);
        }
        H = normalize(-V + L);
        LdotN = max(0.0, dot(L, vNormal));
        NdotH = max(0.0, dot(vNormal, H));        
        specular = pow(NdotH, SpecularExponent);
        vAmbDif += (LdotN * Diffuse.rgb) * DirectionalLightColor[i].rgb;
        vSpec += SpecularColor.rgb * specular * DirectionalLightColor[i].rgb;        
    }
#endif
    
#if KANZI_SHADER_NUM_POINT_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_POINT_LIGHTS; ++i)
    {
        pointLightDirection = positionWorld.xyz - PointLightPosition[i];
        L = normalize(-pointLightDirection);
        H = normalize(-V + L);
        LdotN = max(0.0, dot(L, vNormal));
        NdotH = max(0.0, dot(vNormal, H));
        specular = pow(NdotH, SpecularExponent);
        c = PointLightAttenuation[i];
        d = length(pointLightDirection);
        attenuation = 1.0 / max(0.001, (c.x + c.y * d + c.z * d * d));        
        vAmbDif += (LdotN * Diffuse.rgb) * attenuation * PointLightColor[i].rgb;
        vSpec +=  SpecularColor.rgb * specular * attenuation * PointLightColor[i].rgb;
        
    }
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_SPOT_LIGHTS; ++i)
    {
        spotLightDirection = positionWorld.xyz - SpotLightPosition[i];
        L = normalize(-spotLightDirection);
        LdotN = dot(L, vNormal);
        
        if(LdotN > 0.0)
        {
            float cosDirection = dot(L, -SpotLightDirection[i]);
            float cosOuter = SpotLightConeParameters[i].x;
            float t = cosDirection - cosOuter;
            if (t > 0.0)
            {
                vec3 H = normalize(-V + L);
                float NdotH = max(0.0, dot(vNormal, H));
                float specular = pow(NdotH, SpecularExponent);
                vec3  c = SpotLightAttenuation[i];
                float d = length(spotLightDirection);
                float denom = (0.01 + c.x + c.y * d + c.z * d * d) * SpotLightConeParameters[i].z;
                float attenuation = min(t / denom, 1.0);
                vAmbDif += (LdotN * Diffuse.rgb) * attenuation * SpotLightColor[i].rgb;
                vSpec += SpecularColor.rgb * specular * attenuation * SpotLightColor[i].rgb;
            }
        }        
    }    
#endif

    vSpec += Emissive.rgb;
    
#if KANZI_SHADER_USE_BASECOLOR_TEXTURE
    vTexCoord = kzTextureCoordinate0 * TextureTiling + TextureOffset;
#endif
}
