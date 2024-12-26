#version 300 es

// Use metallic roughness if it is explicitly specified, or if none is specified, or if both metallic roughness and specular glossiness are specified.
#define USE_METALLIC_ROUGHNESS (KANZI_SHADER_USE_PBR_METALLIC_ROUGHNESS || KANZI_SHADER_USE_PBR_METALLIC_ROUGHNESS == KANZI_SHADER_USE_PBR_SPECULAR_GLOSSINESS)
#define USE_SPECULAR_GLOSSINESS (!USE_METALLIC_ROUGHNESS)
#define USE_CLEARCOAT (USE_METALLIC_ROUGHNESS && KANZI_SHADER_USE_CLEARCOAT)

#define USE_CLEARCOAT_TEXTURES (USE_CLEARCOAT && (KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE || KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE || KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE))
#define USE_METALLIC_ROUGHNESS_TEXTURES (USE_METALLIC_ROUGHNESS && (KANZI_SHADER_USE_BASECOLOR_TEXTURE || KANZI_SHADER_USE_ROUGHNESS_TEXTURE || KANZI_SHADER_USE_METALLIC_TEXTURE))
#define USE_SPECULAR_GLOSSINESS_TEXTURES (USE_SPECULAR_GLOSSINESS && (KANZI_SHADER_USE_DIFFUSE_TEXTURE || KANZI_SHADER_USE_SPECULAR_TEXTURE || KANZI_SHADER_USE_GLOSSINESS_TEXTURE))
#define USE_COMMON_TEXTURES (KANZI_SHADER_USE_NORMALMAP_TEXTURE || KANZI_SHADER_USE_OCCLUSION_TEXTURE || KANZI_SHADER_USE_EMISSIVE_TEXTURE)

#define USE_CLEARCOAT_TEXTURES_DETAIL (USE_CLEARCOAT && (KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_DETAIL || KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_DETAIL || KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL))
#define USE_METALLIC_ROUGHNESS_TEXTURES_DETAIL (USE_METALLIC_ROUGHNESS && (KANZI_SHADER_USE_BASECOLOR_TEXTURE_DETAIL || KANZI_SHADER_USE_ROUGHNESS_TEXTURE_DETAIL || KANZI_SHADER_USE_METALLIC_TEXTURE_DETAIL))
#define USE_SPECULAR_GLOSSINESS_TEXTURES_DETAIL (USE_SPECULAR_GLOSSINESS && (KANZI_SHADER_USE_DIFFUSE_TEXTURE_DETAIL || KANZI_SHADER_USE_SPECULAR_TEXTURE_DETAIL || KANZI_SHADER_USE_GLOSSINESS_TEXTURE_DETAIL))
#define USE_COMMON_TEXTURES_DETAIL (KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL || KANZI_SHADER_USE_OCCLUSION_TEXTURE_DETAIL || KANZI_SHADER_USE_EMISSIVE_TEXTURE_DETAIL)

#define USE_TEXTURES (USE_SPECULAR_GLOSSINESS_TEXTURES || USE_METALLIC_ROUGHNESS_TEXTURES || USE_COMMON_TEXTURES || USE_CLEARCOAT_TEXTURES)
#define USE_TEXTURES_DETAIL (USE_SPECULAR_GLOSSINESS_TEXTURES_DETAIL || USE_METALLIC_ROUGHNESS_TEXTURES_DETAIL || USE_COMMON_TEXTURES_DETAIL || USE_CLEARCOAT_TEXTURES_DETAIL)

#define USE_MR_TEXTURE_COORDINATE_INDEX(x) (USE_METALLIC_ROUGHNESS && \
                                           ((KANZI_SHADER_USE_BASECOLOR_TEXTURE && KANZI_SHADER_USE_BASECOLOR_TEXTURE_COORDINATE_INDEX == (x)) || \
                                            (KANZI_SHADER_USE_ROUGHNESS_TEXTURE && KANZI_SHADER_USE_ROUGHNESS_TEXTURE_COORDINATE_INDEX == (x)) || \
                                            (KANZI_SHADER_USE_METALLIC_TEXTURE && KANZI_SHADER_USE_METALLIC_TEXTURE_COORDINATE_INDEX == (x))))

#define USE_SG_TEXTURE_COORDINATE_INDEX(x) (USE_SPECULAR_GLOSSINESS && \
                                           ((KANZI_SHADER_USE_DIFFUSE_TEXTURE && KANZI_SHADER_USE_DIFFUSE_TEXTURE_COORDINATE_INDEX == (x)) || \
                                            (KANZI_SHADER_USE_SPECULAR_TEXTURE && KANZI_SHADER_USE_SPECULAR_TEXTURE_COORDINATE_INDEX == (x)) || \
                                            (KANZI_SHADER_USE_GLOSSINESS_TEXTURE && KANZI_SHADER_USE_GLOSSINESS_TEXTURE_COORDINATE_INDEX == (x))))

#define USE_CLEARCOAT_TEXTURE_COORDINATE_INDEX(x) (USE_CLEARCOAT && \
                                                 ((KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE && KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_COORDINATE_INDEX == (x)) || \
                                                  (KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE && KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_COORDINATE_INDEX == (x)) || \
                                                  (KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE && KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_COORDINATE_INDEX == (x))))

#define USE_MR_TEXTURE_COORDINATE_INDEX_DETAIL(x) (USE_METALLIC_ROUGHNESS && \
                                           ((KANZI_SHADER_USE_BASECOLOR_TEXTURE_DETAIL && KANZI_SHADER_USE_BASECOLOR_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                            (KANZI_SHADER_USE_ROUGHNESS_TEXTURE_DETAIL && KANZI_SHADER_USE_ROUGHNESS_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                            (KANZI_SHADER_USE_METALLIC_TEXTURE_DETAIL && KANZI_SHADER_USE_METALLIC_TEXTURE_COORDINATE_INDEX_DETAIL == (x))))

#define USE_SG_TEXTURE_COORDINATE_INDEX_DETAIL(x) (USE_SPECULAR_GLOSSINESS && \
                                           ((KANZI_SHADER_USE_DIFFUSE_TEXTURE_DETAIL && KANZI_SHADER_USE_DIFFUSE_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                            (KANZI_SHADER_USE_SPECULAR_TEXTURE_DETAIL && KANZI_SHADER_USE_SPECULAR_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                            (KANZI_SHADER_USE_GLOSSINESS_TEXTURE_DETAIL && KANZI_SHADER_USE_METALLIC_TEXTURE_COORDINATE_INDEX_DETAIL == (x))))

#define USE_CLEARCOAT_TEXTURE_COORDINATE_INDEX_DETAIL(x) (USE_CLEARCOAT && \
                                                 ((KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_DETAIL && KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                                  (KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_DETAIL && KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                                  (KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL && KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_COORDINATE_INDEX_DETAIL == (x))))

#define USE_TEXTURE_COORDINATE_INDEX(x)  (USE_MR_TEXTURE_COORDINATE_INDEX(x) || USE_SG_TEXTURE_COORDINATE_INDEX(x) || USE_CLEARCOAT_TEXTURE_COORDINATE_INDEX(x) || \
                                         (KANZI_SHADER_USE_NORMALMAP_TEXTURE && KANZI_SHADER_USE_NORMALMAP_TEXTURE_COORDINATE_INDEX == (x)) || \
                                         (KANZI_SHADER_USE_OCCLUSION_TEXTURE && KANZI_SHADER_USE_OCCLUSION_TEXTURE_COORDINATE_INDEX == (x)) || \
                                         (KANZI_SHADER_USE_EMISSIVE_TEXTURE && KANZI_SHADER_USE_EMISSIVE_TEXTURE_COORDINATE_INDEX == (x)))

#define USE_TEXTURE_COORDINATE_INDEX_DETAIL(x)  (USE_MR_TEXTURE_COORDINATE_INDEX_DETAIL(x) || USE_SG_TEXTURE_COORDINATE_INDEX_DETAIL(x) || USE_CLEARCOAT_TEXTURE_COORDINATE_INDEX_DETAIL(x) || \
                                                (KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL && KANZI_SHADER_USE_NORMALMAP_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                                (KANZI_SHADER_USE_OCCLUSION_TEXTURE_DETAIL && KANZI_SHADER_USE_OCCLUSION_TEXTURE_COORDINATE_INDEX_DETAIL == (x)) || \
                                                (KANZI_SHADER_USE_EMISSIVE_TEXTURE_DETAIL && KANZI_SHADER_USE_EMISSIVE_TEXTURE_COORDINATE_INDEX_DETAIL == (x)))

#if USE_TEXTURE_COORDINATE_INDEX(1)
#define TEXTURE_COORDINATE_COUNT 2
#else
#define TEXTURE_COORDINATE_COUNT 1
#endif

#if USE_TEXTURE_COORDINATE_INDEX_DETAIL(1)
#define TEXTURE_COORDINATE_DETAIL_COUNT 2
#else
#define TEXTURE_COORDINATE_DETAIL_COUNT 1
#endif

#define USE_TANGENT_SPACE ((KANZI_SHADER_USE_NORMALMAP_TEXTURE || KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL) || \
                           (KANZI_SHADER_USE_CLEARCOAT && (KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE || KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL)))
#if USE_TANGENT_SPACE
out mediump vec3 vTangent;
out mediump vec3 vBinormal;
#endif

#if KANZI_SHADER_MORPH_TARGET_COUNT <= 1

in highp vec3 kzPosition;
in highp vec3 kzNormal;
#if USE_TANGENT_SPACE
in vec4 kzTangent;
#if KANZI_SHADER_USE_EXPLICIT_BINORMALS
in vec3 kzBinormal;
#endif
#endif

#else // KANZI_SHADER_MORPH_TARGET_COUNT <= 1

#if KANZI_SHADER_USE_MORPH_DATA_TEXTURE

uniform sampler2D kzMorphDataTexture;
uniform highp int kzMorphDataPositionOffset;
#if KANZI_SHADER_USE_MORPH_TARGET_NORMALS
uniform highp int kzMorphDataNormalOffset;
#else // KANZI_SHADER_USE_MORPH_TARGET_NORMALS
in highp vec3 kzMorphTarget0Normal;
#endif // KANZI_SHADER_USE_MORPH_TARGET_NORMALS
#if USE_TANGENT_SPACE
#if KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
uniform highp int kzMorphDataTangentOffset;
#else // KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
in vec4 kzMorphTarget0Tangent;
#endif // KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
#endif // USE_TANGENT_SPACE
uniform highp int kzMorphDataSize;
uniform mediump int kzMorphIndices[KANZI_SHADER_MORPH_TARGET_COUNT];

#else // KANZI_SHADER_USE_MORPH_DATA_TEXTURE

in vec3 kzMorphTarget0Position;
in vec3 kzMorphTarget1Position;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 2
in vec3 kzMorphTarget2Position;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 3
in vec3 kzMorphTarget3Position;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 4
in vec3 kzMorphTarget4Position;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 5
in vec3 kzMorphTarget5Position;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 6
in vec3 kzMorphTarget6Position;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 7
in vec3 kzMorphTarget7Position;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 8
in vec3 kzMorphTarget8Position;
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 8
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 7
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 6
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 5
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 4
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 3
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 2

in vec3 kzMorphTarget0Normal;
#if KANZI_SHADER_USE_MORPH_TARGET_NORMALS
in vec3 kzMorphTarget1Normal;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 2
in vec3 kzMorphTarget2Normal;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 3
in vec3 kzMorphTarget3Normal;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 4
in vec3 kzMorphTarget4Normal;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 5
in vec3 kzMorphTarget5Normal;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 6
in vec3 kzMorphTarget6Normal;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 7
in vec3 kzMorphTarget7Normal;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 8
in vec3 kzMorphTarget8Normal;
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 8
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 7
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 6
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 5
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 4
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 3
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 2
#endif // KANZI_SHADER_USE_MORPH_TARGET_NORMALS

#if USE_TANGENT_SPACE
in vec4 kzMorphTarget0Tangent;
#if KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
in vec3 kzMorphTarget1Tangent;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 2
in vec3 kzMorphTarget2Tangent;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 3
in vec3 kzMorphTarget3Tangent;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 4
in vec3 kzMorphTarget4Tangent;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 5
in vec3 kzMorphTarget5Tangent;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 6
in vec3 kzMorphTarget6Tangent;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 7
in vec3 kzMorphTarget7Tangent;
#if KANZI_SHADER_MORPH_TARGET_COUNT > 8
in vec3 kzMorphTarget8Tangent;
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 8
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 7
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 6
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 5
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 4
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 3
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 2
#endif // KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
#endif // USE_TANGENT_SPACE

#endif // KANZI_SHADER_USE_MORPH_DATA_TEXTURE

uniform mediump float kzMorphWeights[KANZI_SHADER_MORPH_TARGET_COUNT];
#endif // KANZI_SHADER_MORPH_TARGET_COUNT <= 1

#if KANZI_SHADER_SKINNING_BONE_COUNT
in vec4 kzWeight;
in vec4 kzMatrixIndices;
uniform highp vec4 kzMatrixPalette[KANZI_SHADER_SKINNING_BONE_COUNT*3];
#endif

precision lowp float;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzNormalMatrix;
uniform highp vec4 kzViewPosition;

out highp vec3 vNormal;
out highp vec3 vViewDirection;
out highp vec4 vFragPosition;
out highp vec3 vPositionWorldNormalized;                         

#if KANZI_SHADER_USE_VERTEX_COLOR
in mediump vec4 kzColor0;
out mediump vec4 vColor;
#endif

#if USE_TEXTURE_COORDINATE_INDEX(0) || USE_TEXTURE_COORDINATE_INDEX_DETAIL(0)
in vec2 kzTextureCoordinate0;
#endif

#if USE_TEXTURE_COORDINATE_INDEX(1) || USE_TEXTURE_COORDINATE_INDEX_DETAIL(1)
in vec2 kzTextureCoordinate1;
#endif

#if USE_TEXTURES
uniform mediump vec2 TextureOffset;
uniform mediump vec2 TextureTiling;
#endif

out mediump vec2 vTexCoord[TEXTURE_COORDINATE_COUNT];

#if USE_TEXTURES_DETAIL
uniform mediump vec2 DetailTextureOffset;
uniform mediump vec2 DetailTextureTiling;
#endif

out mediump vec2 vDetailTexCoord[TEXTURE_COORDINATE_DETAIL_COUNT];

#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
uniform mediump vec3 DirectionalLightDirection[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
out mediump vec3 vDirectionalLightDirection[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
#endif

#if KANZI_SHADER_NUM_POINT_LIGHTS
uniform mediump vec3 PointLightPosition[KANZI_SHADER_NUM_POINT_LIGHTS];
out mediump vec3 vPointLightDirection[KANZI_SHADER_NUM_POINT_LIGHTS];
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
uniform highp vec3 SpotLightPosition[KANZI_SHADER_NUM_SPOT_LIGHTS];
out highp vec3 vSpotLightDirection[KANZI_SHADER_NUM_SPOT_LIGHTS];
#endif

#if KANZI_SHADER_RECEIVE_DIRECTIONAL_SHADOW
uniform highp mat4 DirectionalLightViewProjection;
out highp vec4 vDirectionalLightShadowPosition;
#endif

#if KANZI_SHADER_RECEIVE_SPOT_SHADOW
uniform highp mat4 SpotLightViewProjection;
out highp vec4 vSpotLightShadowPosition;
#endif

#if KANZI_SHADER_RECEIVE_PLANAR_REFLECTION
uniform highp mat4 PlanarReflectionViewProjection;
out highp vec4 vPlanarReflectionPosition;
#endif

struct PositionData
{
    vec3 position; // Position not yet transformed by the model matrix.
    vec3 normal;
#if USE_TANGENT_SPACE
    vec4 tangent;
#endif
};

#if KANZI_SHADER_MORPH_TARGET_COUNT > 1

#if KANZI_SHADER_USE_MORPH_DATA_TEXTURE
mediump vec4 getMorphData(int morphIndex, int vertexIndex)
{
    highp int kzMorphDataTextureWidth = textureSize(kzMorphDataTexture, 0).x;
    highp int positionIndex = morphIndex * kzMorphDataSize + vertexIndex;
    highp int posX = positionIndex % kzMorphDataTextureWidth;
    highp int posY = positionIndex / kzMorphDataTextureWidth;
    return texelFetch(kzMorphDataTexture, ivec2(posX, posY), 0);
}
vec3 getMorphPositionData(int morphIndex, int vertexIndex)
{
    return getMorphData(morphIndex, kzMorphDataPositionOffset + vertexIndex).xyz;
}
#if KANZI_SHADER_USE_MORPH_TARGET_NORMALS
vec3 getMorphNormalData(int morphIndex, int vertexIndex)
{
    return getMorphData(morphIndex, kzMorphDataNormalOffset + vertexIndex).xyz;
}
#endif // KANZI_SHADER_USE_MORPH_TARGET_NORMALS
#if USE_TANGENT_SPACE
#if KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
vec4 getMorphTangentData(int morphIndex, int vertexIndex)
{
    return getMorphData(morphIndex, kzMorphDataTangentOffset + vertexIndex);
}
#endif // KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
#endif // USE_TANGENT_SPACE
#endif // KANZI_SHADER_USE_MORPH_DATA_TEXTURE

PositionData calculateMorphTargetPositionData()
{
    PositionData posData;

    float baseMorphWeight = 1.0;
    for(int it = 1; (it < KANZI_SHADER_MORPH_TARGET_COUNT); ++it)
    {
        baseMorphWeight -= kzMorphWeights[it];
    }
#if KANZI_SHADER_USE_MORPH_DATA_TEXTURE
    posData.position = getMorphPositionData(kzMorphIndices[0], gl_VertexID) * baseMorphWeight;
    for(int it = 1; (it < KANZI_SHADER_MORPH_TARGET_COUNT); ++it)
    {
        posData.position += getMorphPositionData(kzMorphIndices[it], gl_VertexID) * kzMorphWeights[it];
    }
#else // KANZI_SHADER_USE_MORPH_DATA_TEXTURE
    posData.position = kzMorphTarget0Position * baseMorphWeight
                     + kzMorphTarget1Position * kzMorphWeights[1]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 2
                     + kzMorphTarget2Position * kzMorphWeights[2]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 3
                     + kzMorphTarget3Position * kzMorphWeights[3]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 4
                     + kzMorphTarget4Position * kzMorphWeights[4]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 5
                     + kzMorphTarget5Position * kzMorphWeights[5]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 6
                     + kzMorphTarget6Position * kzMorphWeights[6]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 7
                     + kzMorphTarget7Position * kzMorphWeights[7]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 8
                     + kzMorphTarget8Position * kzMorphWeights[8]
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 8
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 7
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 6
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 5
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 4
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 3
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 2
    ;
#endif // KANZI_SHADER_USE_MORPH_DATA_TEXTURE

#if KANZI_SHADER_USE_MORPH_TARGET_NORMALS
#if KANZI_SHADER_USE_MORPH_NORMAL_LIMIT
    baseMorphWeight = max(baseMorphWeight, 0.0);
#endif // KANZI_SHADER_USE_MORPH_NORMAL_LIMIT
#if KANZI_SHADER_USE_MORPH_DATA_TEXTURE
    posData.normal = getMorphNormalData(kzMorphIndices[0], gl_VertexID) * baseMorphWeight;
    for(int it = 1; (it < KANZI_SHADER_MORPH_TARGET_COUNT); ++it)
    {
        posData.normal += getMorphNormalData(kzMorphIndices[it], gl_VertexID) * kzMorphWeights[it];
    }
#else // KANZI_SHADER_USE_MORPH_DATA_TEXTURE
    posData.normal = kzMorphTarget0Normal * baseMorphWeight
                   + kzMorphTarget1Normal * kzMorphWeights[1]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 2
                   + kzMorphTarget2Normal * kzMorphWeights[2]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 3
                   + kzMorphTarget3Normal * kzMorphWeights[3]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 4
                   + kzMorphTarget4Normal * kzMorphWeights[4]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 5
                   + kzMorphTarget5Normal * kzMorphWeights[5]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 6
                   + kzMorphTarget6Normal * kzMorphWeights[6]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 7
                   + kzMorphTarget7Normal * kzMorphWeights[7]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 8
                   + kzMorphTarget8Normal * kzMorphWeights[8]
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 8
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 7
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 6
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 5
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 4
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 3
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 2
    ;
#endif // KANZI_SHADER_USE_MORPH_DATA_TEXTURE
#else // KANZI_SHADER_USE_MORPH_TARGET_NORMALS
    posData.normal = kzMorphTarget0Normal;
#endif // KANZI_SHADER_USE_MORPH_TARGET_NORMALS

#if USE_TANGENT_SPACE

#if KANZI_SHADER_USE_MORPH_TARGET_TANGENTS
#if KANZI_SHADER_USE_MORPH_DATA_TEXTURE
    posData.tangent = getMorphTangentData(kzMorphIndices[0], gl_VertexID);
    posData.tangent.xyz *= baseMorphWeight;
    for(int it = 1; (it < KANZI_SHADER_MORPH_TARGET_COUNT); ++it)
    {
        posData.tangent.xyz += getMorphTangentData(kzMorphIndices[it], gl_VertexID).xyz * kzMorphWeights[it];
    }
#else // KANZI_SHADER_USE_MORPH_DATA_TEXTURE
    posData.tangent.w = kzMorphTarget0Tangent.w;
    posData.tangent.xyz = kzMorphTarget0Tangent.xyz
                        * baseMorphWeight
                        + kzMorphTarget1Tangent.xyz * kzMorphWeights[1]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 2
                        + kzMorphTarget2Tangent.xyz * kzMorphWeights[2]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 3
                        + kzMorphTarget3Tangent.xyz * kzMorphWeights[3]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 4
                        + kzMorphTarget4Tangent.xyz * kzMorphWeights[4]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 5
                        + kzMorphTarget5Tangent.xyz * kzMorphWeights[5]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 6
                        + kzMorphTarget6Tangent.xyz * kzMorphWeights[6]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 7
                        + kzMorphTarget7Tangent.xyz * kzMorphWeights[7]
#if KANZI_SHADER_MORPH_TARGET_COUNT > 8
                        + kzMorphTarget8Tangent.xyz * kzMorphWeights[8]
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 8
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 7
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 6
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 5
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 4
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 3
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 2
    ;
#endif // KANZI_SHADER_USE_MORPH_DATA_TEXTURE

#else // KANZI_SHADER_USE_MORPH_TARGET_TANGENTS

    posData.tangent = kzMorphTarget0Tangent;
#if KANZI_SHADER_USE_MORPH_TARGET_NORMALS
    // orthogonalize base mesh tangent against deformed normal
    posData.tangent.xyz -= posData.normal * dot(posData.normal, posData.tangent.xyz) / dot(posData.normal, posData.normal);
#endif // KANZI_SHADER_USE_MORPH_TARGET_NORMALS

#endif // KANZI_SHADER_USE_MORPH_TARGET_TANGENTS

#endif // USE_TANGENT_SPACE

    return posData;
}

#else // KANZI_SHADER_MORPH_TARGET_COUNT > 1

PositionData calculateSimplePositionData()
{
    PositionData posData;
    posData.position = kzPosition.xyz;
    posData.normal = kzNormal.xyz;
#if USE_TANGENT_SPACE
    posData.tangent = kzTangent;
#endif
    return posData;
}
#endif // KANZI_SHADER_MORPH_TARGET_COUNT > 1

#if KANZI_SHADER_SKINNING_BONE_COUNT
void calculateSkinningPositionData(inout PositionData posData)
{
    mat4 localToSkinMatrix;
    int i1 = 3 * int(kzMatrixIndices.x);
    int i2 = 3 * int(kzMatrixIndices.y);
    int i3 = 3 * int(kzMatrixIndices.z);
    int i4 = 3 * int(kzMatrixIndices.w);
    vec4 b1 = kzWeight.x * kzMatrixPalette[i1 + 0] + kzWeight.y * kzMatrixPalette[i2 + 0]
            + kzWeight.z * kzMatrixPalette[i3 + 0] + kzWeight.w * kzMatrixPalette[i4 + 0];
    vec4 b2 = kzWeight.x * kzMatrixPalette[i1 + 1] + kzWeight.y * kzMatrixPalette[i2 + 1]
            + kzWeight.z * kzMatrixPalette[i3 + 1] + kzWeight.w * kzMatrixPalette[i4 + 1];
    vec4 b3 = kzWeight.x * kzMatrixPalette[i1 + 2] + kzWeight.y * kzMatrixPalette[i2 + 2]
            + kzWeight.z * kzMatrixPalette[i3 + 2] + kzWeight.w * kzMatrixPalette[i4 + 2];

    localToSkinMatrix[0] = vec4(b1.xyz, 0.0);
    localToSkinMatrix[1] = vec4(b2.xyz, 0.0);
    localToSkinMatrix[2] = vec4(b3.xyz, 0.0);
    localToSkinMatrix[3] = vec4(b1.w, b2.w, b3.w, 1.0);
    mat4 localToWorldMatrix = kzWorldMatrix * localToSkinMatrix;

    posData.position = (localToSkinMatrix * vec4(posData.position.xyz, 1.0)).xyz;
    posData.normal = mat3(localToSkinMatrix) * posData.normal;
#if USE_TANGENT_SPACE
    posData.tangent.xyz = mat3(localToSkinMatrix) * posData.tangent.xyz;
#endif
}
#endif

void main()
{
#if KANZI_SHADER_MORPH_TARGET_COUNT > 1
    PositionData posData = calculateMorphTargetPositionData();
#else
    PositionData posData = calculateSimplePositionData();
#endif

#if KANZI_SHADER_SKINNING_BONE_COUNT
    calculateSkinningPositionData(posData);
#endif

    //Get our world position.
    highp vec4 positionWorld = kzWorldMatrix * vec4(posData.position, 1.0);

#if KANZI_SHADER_RECEIVE_DIRECTIONAL_SHADOW
    vDirectionalLightShadowPosition = DirectionalLightViewProjection * positionWorld;
#endif

#if KANZI_SHADER_RECEIVE_SPOT_SHADOW
    vSpotLightShadowPosition =  SpotLightViewProjection * positionWorld;
#endif

#if KANZI_SHADER_RECEIVE_PLANAR_REFLECTION
    vPlanarReflectionPosition = PlanarReflectionViewProjection * positionWorld;
#endif

    vNormal = normalize(mat3(kzNormalMatrix) * posData.normal);

    vViewDirection = positionWorld.xyz * kzViewPosition.w - kzViewPosition.xyz;

    vFragPosition = vec4(posData.position, 1.0);
    gl_Position = kzProjectionCameraWorldMatrix * vec4(posData.position, 1.0);
    
    //  Send back the vertex position to the Light side for shadow mask
    vPositionWorldNormalized = positionWorld.xyz/positionWorld.w;
    
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

#if USE_TANGENT_SPACE
    vTangent = normalize((kzNormalMatrix * vec4(posData.tangent.xyz, 0.0)).xyz);
#if KANZI_SHADER_USE_EXPLICIT_BINORMALS
    vBinormal = (kzNormalMatrix * vec4(kzBinormal.xyz, 0.0)).xyz;
#else
    vBinormal = cross(vNormal, vTangent) * posData.tangent.w;
#endif // KANZI_SHADER_USE_EXPLICIT_BINORMALS
#endif

#if USE_TEXTURE_COORDINATE_INDEX(0)
    vTexCoord[0] = kzTextureCoordinate0 * TextureTiling + TextureOffset;
#endif

#if USE_TEXTURE_COORDINATE_INDEX(1)
    vTexCoord[1] = kzTextureCoordinate1 * TextureTiling + TextureOffset;
#endif

#if USE_TEXTURE_COORDINATE_INDEX_DETAIL(0)
    vDetailTexCoord[0] = kzTextureCoordinate0 * DetailTextureTiling + DetailTextureOffset;
#endif

#if USE_TEXTURE_COORDINATE_INDEX_DETAIL(1)
    vDetailTexCoord[1] = kzTextureCoordinate1 * DetailTextureTiling + DetailTextureOffset;
#endif

#if KANZI_SHADER_USE_VERTEX_COLOR
    vColor = kzColor0;
#endif
}
