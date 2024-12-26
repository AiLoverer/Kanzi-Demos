#version 300 es
#define PI 3.1415926535

precision lowp float;

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

uniform vec4  Ambient;
uniform vec4  EmissiveFactor;
uniform float BlendIntensity;

in highp vec3     vNormal;
in highp vec3     vViewDirection;
in highp vec4     vFragPosition;
in highp vec3     vPositionWorldNormalized;
out mediump vec4  outColor;

#if KANZI_SHADER_USE_VERTEX_COLOR
in mediump vec4 vColor;
#endif

in mediump vec2   vTexCoord[TEXTURE_COORDINATE_COUNT];
in mediump vec2   vDetailTexCoord[TEXTURE_COORDINATE_DETAIL_COUNT];

#if USE_TANGENT_SPACE
in mediump vec3   vTangent;
in mediump vec3   vBinormal;
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE
uniform sampler2D       NormalTexture;
uniform float           NormalScale;
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL
uniform sampler2D       DetailNormalTexture;
uniform float           DetailNormalScale;
#endif

#if USE_METALLIC_ROUGHNESS
uniform vec4            BaseColorFactor;
#if KANZI_SHADER_USE_BASECOLOR_TEXTURE
uniform sampler2D       BaseColorTexture;
#endif

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE_DETAIL
uniform sampler2D       DetailBaseColorTexture;
uniform vec4            DetailBaseColorFactor;
#endif

uniform float RoughnessFactor;
#if KANZI_SHADER_USE_ROUGHNESS_TEXTURE
uniform sampler2D       RoughnessTexture;
#endif

#if KANZI_SHADER_USE_ROUGHNESS_TEXTURE_DETAIL
uniform sampler2D       DetailRoughnessTexture;
#endif

uniform float MetallicFactor;
#if KANZI_SHADER_USE_METALLIC_TEXTURE
uniform sampler2D       MetallicTexture;
#endif

#if KANZI_SHADER_USE_METALLIC_TEXTURE_DETAIL
uniform sampler2D       DetailMetallicTexture;
#endif
#endif

#if USE_SPECULAR_GLOSSINESS
uniform vec4            DiffuseFactor;
#if KANZI_SHADER_USE_DIFFUSE_TEXTURE
uniform sampler2D       DiffuseTexture;
#endif

#if KANZI_SHADER_USE_DIFFUSE_TEXTURE_DETAIL
uniform sampler2D       DetailDiffuseTexture;
uniform vec4            DetailDiffuseFactor;
#endif

uniform float GlossinessFactor;
#if KANZI_SHADER_USE_GLOSSINESS_TEXTURE
uniform sampler2D       GlossinessTexture;
#endif

#if KANZI_SHADER_USE_GLOSSINESS_TEXTURE_DETAIL
uniform sampler2D       DetailGlossinessTexture;
#endif

uniform vec4 SpecularFactor;
#if KANZI_SHADER_USE_SPECULAR_TEXTURE
uniform sampler2D       SpecularTexture;
#endif

#if KANZI_SHADER_USE_SPECULAR_TEXTURE_DETAIL
uniform sampler2D       DetailSpecularTexture;
uniform lowp vec4       DetailSpecularFactor;
#endif
#endif

#if KANZI_SHADER_USE_OCCLUSION_TEXTURE
uniform sampler2D       OcclusionTexture;
uniform float           OcclusionStrength;
#endif

#if KANZI_SHADER_USE_OCCLUSION_TEXTURE_DETAIL
uniform sampler2D       DetailOcclusionTexture;
uniform float           DetailOcclusionStrength;
#endif

#if KANZI_SHADER_USE_EMISSIVE_TEXTURE
uniform sampler2D       EmissiveTexture;
#endif

#if KANZI_SHADER_USE_EMISSIVE_TEXTURE_DETAIL
uniform lowp vec4       DetailEmissiveFactor;
uniform sampler2D       DetailEmissiveTexture;
#endif

#if USE_CLEARCOAT
uniform lowp float      ClearCoatStrengthFactor;

#if KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE
uniform sampler2D       ClearCoatStrengthTexture;
#endif

#if KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_DETAIL
uniform sampler2D       DetailClearCoatStrengthTexture;
#endif

#if KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL
uniform sampler2D       DetailClearCoatNormalTexture;
uniform float           DetailClearCoatNormalScale;
#endif

uniform lowp float      ClearCoatRoughnessFactor;

#if KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE
uniform sampler2D       ClearCoatRoughnessTexture;
#endif

#if KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_DETAIL
uniform sampler2D       DetailClearCoatRoughnessTexture;
#endif

#if KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE
uniform sampler2D       ClearCoatNormalTexture;
uniform float           ClearCoatNormalScale;
#endif
#endif

#if KANZI_SHADER_USE_LIGHT_IMAGE_BASED //Make sure that texture format is RAW
uniform samplerCube     EnvironmentAmbientTexture;
uniform samplerCube     EnvironmentReflectionTexture;
uniform float           EnvironmentAmbientFactor;
uniform float           EnvironmentReflectionFactor;
#endif

#if KANZI_SHADER_USE_BRDF_LOOKUP_TABLE
uniform sampler2D       BrdfLookUpTable;
#endif //KANZI_SHADER_USE_BRDF_LOOKUP_TABLE


#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
uniform vec4            DirectionalLightColor[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
in mediump vec3         vDirectionalLightDirection[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
#endif

#if KANZI_SHADER_NUM_POINT_LIGHTS
uniform vec4            PointLightColor[KANZI_SHADER_NUM_POINT_LIGHTS];
uniform mediump vec3    PointLightAttenuation[KANZI_SHADER_NUM_POINT_LIGHTS];
uniform highp float     PointLightRadius[KANZI_SHADER_NUM_POINT_LIGHTS];
in mediump vec3         vPointLightDirection[KANZI_SHADER_NUM_POINT_LIGHTS];
uniform mediump vec3    PointLightPosition[KANZI_SHADER_NUM_POINT_LIGHTS];
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
uniform vec4            SpotLightColor[KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform highp vec3      SpotLightDirection[KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform highp vec3      SpotLightConeParameters[KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform highp vec3      SpotLightAttenuation[KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform highp float     SpotLightRadius[KANZI_SHADER_NUM_SPOT_LIGHTS];
in highp vec3           vSpotLightDirection[KANZI_SHADER_NUM_SPOT_LIGHTS];
#endif

#if KANZI_SHADER_RECEIVE_DIRECTIONAL_SHADOW
uniform highp sampler2DShadow DirectionalShadowMap;
uniform lowp float DirectionalShadowBias;
in highp vec4 vDirectionalLightShadowPosition;
#endif

#if KANZI_SHADER_RECEIVE_SPOT_SHADOW
uniform highp sampler2DShadow SpotShadowMap;
uniform lowp float SpotShadowBias;
in highp vec4 vSpotLightShadowPosition;
#endif

#if KANZI_SHADER_RECEIVE_POINT_SHADOW
uniform highp samplerCubeShadow PointShadowMap;
uniform mediump vec2 PointShadowNearFar;
uniform lowp float PointShadowBias;
#endif


#if KANZI_SHADER_RECEIVE_PLANAR_REFLECTION
uniform sampler2D PlanarReflectionMap;
in highp vec4 vPlanarReflectionPosition;
#endif

#if KANZI_SHADER_DEBUG_OUTPUT
uniform lowp float KanziPBR_Debug_Albedo;
uniform lowp float KanziPBR_Debug_Emissive;
#if USE_METALLIC_ROUGHNESS
uniform lowp float KanziPBR_Debug_Metalness;
#elif USE_SPECULAR_GLOSSINESS
uniform lowp float KanziPBR_Debug_Specular;
#endif
uniform lowp float KanziPBR_Debug_Roughness;
uniform lowp float KanziPBR_Debug_Normal;
uniform lowp float KanziPBR_Debug_AmbientOcclusion;
uniform lowp float KanziPBR_Debug_LightColor;
#if USE_CLEARCOAT
uniform lowp float KanziPBR_Debug_ClearCoat;
#endif
uniform lowp float KanziPBR_Debug_User1;
#endif


#if KANZI_SHADER_USE_EXPOSURE
uniform mediump float Exposure;
#endif

#if KANZI_SHADER_USE_ALPHA_CUTOFF
uniform lowp float AlphaCutoff;
#endif

#if KANZI_SHADER_USE_SPECULAR_ANTI_ALIASING
uniform lowp float SpecularAntiAliasingStrength;
uniform lowp float SpecularAntiAliasingThreshold;
#endif

///-------------------------------------------------------------------
/// BEGIN tonemap.glsl

float calculateLuminance(vec3 color)
{
    return dot(color, vec3(0.2126f, 0.7152f, 0.0722f));
}

vec3 modifyLuminance(vec3 color, float luminTarget)
{
    float lumin = calculateLuminance(color);
    return color * (luminTarget / lumin);
}


#if KANZI_SHADER_TONEMAP_REINHARD
mediump vec3 Tonemap(highp vec3 color)
{
    return color/(1.0+color);
}

#elif KANZI_SHADER_TONEMAP_LINEAR
uniform float ToneMapLinearScale;
mediump vec3 Tonemap(highp vec3 color)
{

    return color / vec3(ToneMapLinearScale);
}

#elif KANZI_SHADER_TONEMAP_UNCHARTED
vec3 tonemap_uncharted_partial(vec3 color)
{
    const float a = 0.15;
    const float b = 0.50;
    const float c = 0.10;
    const float d = 0.20;
    const float e = 0.02;
    const float f = 0.30;
    return ((color*(a*color+c*b)+d*e)/(color*(a*color+b)+d*f))-e/f;
}

mediump vec3 Tonemap(highp vec3 color)
{
    const float w = 11.2;
    const float exposureBias = 2.0;
    color = tonemap_uncharted_partial(color * exposureBias);

    vec3 whiteScale = 1.0 / tonemap_uncharted_partial(vec3(w));
    return color * whiteScale;
}

#elif KANZI_SHADER_TONEMAP_ACES
mediump vec3 Tonemap(highp vec3 color)
{
    // Note that this is not the real aces curve, but an approximation.
    // True aces curve passes the color through a matrix and some other
    // more expensive calculations. The approximation is common in realtime
    // applications becuase of performance concerns.
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return clamp((color * (a * color + b)) / (color * (c * color + d) + e), 0.0, 1.0);
}
#elif KANZI_SHADER_TONEMAP_FILMIC
// This is the Hejl Richard Filmic tonemap. Note that it produces
// gamma-corrected values. To handle this, we add a pow(c, 2.2) to
// convert it back to linear.
mediump vec3 Tonemap(highp vec3 color)
{
    color = max(vec3(0), color-0.004);
    color = (color * (6.2*color+0.5))/(color*(6.2*color+1.7)+0.06);
    return pow(color, vec3(2.2));
}
#endif


#define USE_TONEMAP (KANZI_SHADER_TONEMAP_LINEAR | KANZI_SHADER_TONEMAP_REINHARD | KANZI_SHADER_TONEMAP_UNCHARTED | KANZI_SHADER_TONEMAP_ACES | KANZI_SHADER_TONEMAP_FILMIC)


/// END tonemap.glsl
///-------------------------------------------------------------------

vec4 Premultiply(vec4 src)
{
    return vec4(src.rgb * src.a, src.a);
}


vec3 PositionToProjectedUVs(vec4 position, float shadowBias)
{
    vec3 pos = position.xyz / position.w;
    pos = pos * 0.5 + 0.5;
    pos.z -= shadowBias;
    return pos;
}



#if (KANZI_SHADER_RECEIVE_DIRECTIONAL_SHADOW || KANZI_SHADER_RECEIVE_SPOT_SHADOW || KANZI_SHADER_RECEIVE_POINT_SHADOW)
///-------------------------------------------------------------------
/// BEGIN shadow.glsl
float Shadow(highp sampler2DShadow shadowMap, vec4 shadowPosition, float bias)
{
    return texture(shadowMap, PositionToProjectedUVs(shadowPosition, bias).xyz);
}

#if KANZI_SHADER_RECEIVE_POINT_SHADOW
float ConvertDistToClipSpace(vec3 lightDir_ws)
{
    vec3 AbsVec = abs(lightDir_ws);
    float LocalZcomp = max(AbsVec.x, max(AbsVec.y, AbsVec.z));
    
    float farPlane  = PointShadowNearFar.y;
    float nearPlane = PointShadowNearFar.x;

    float NormZComp = (farPlane + nearPlane)/(farPlane - nearPlane)
        - (2.0f * farPlane * nearPlane)/(LocalZcomp * farPlane - nearPlane);

    return ((NormZComp + 1.0) * 0.5);
}

float PointShadow(highp samplerCubeShadow shadowMap, vec3 lightDirection, float bias)
{

    float shadow = 1.0;
    
    vec3 lightToVertexDir_ws = vPositionWorldNormalized - PointLightPosition[0].xyz;
    float LightToVertexClipDist = ConvertDistToClipSpace(lightToVertexDir_ws);

    shadow = texture( shadowMap, vec4(lightToVertexDir_ws, LightToVertexClipDist - bias));
    
    return shadow;
}
#endif // KANZI_SHADER_RECEIVE_POINT_SHADOW

/// END shadow.glsl
///-------------------------------------------------------------------
#endif

highp float Distribution(highp float NdotH, float roughness)
{
    highp float a = roughness * roughness;
    highp float a2 = a * a;
    highp float NdotH2 = NdotH * NdotH;
    highp float f = (NdotH2 * (a2 - 1.0) + 1.0);
    // 1e-8 in numerator avoids NaNs with specular reflections on smooth materials
    return a2 / (PI * f * f + 1e-8);
}

// Reference: https://google.github.io/filament/Filament.md.html#materialsystem/specularbrdf/geometricshadowing(specularg)
mediump float Vis_SmithGGXCorrelatedFast(highp float NdotV, highp float NdotL, float roughness)
{
    highp float GGXV = NdotL * (NdotV * (1.0 - roughness) + roughness);
    highp float GGXL = NdotV * (NdotL * (1.0 - roughness) + roughness);

    float GGX = GGXV + GGXL;
    return clamp(0.5 / max(0.05, GGX), 0.0, 1.0);
}

//fresnelSchlick
mediump vec3 Fresnel(mediump float cosT, vec3 F0)
{
  return F0 + (1.0-F0) * pow( 1.0 - cosT, 5.0);
}

struct MaterialData
{
    vec4 baseColor;
    float roughness;
#if USE_METALLIC_ROUGHNESS
    float metalness;
#elif USE_SPECULAR_GLOSSINESS
    vec3 specular;
#endif
    vec3 emissive;
    float ambientOcclusion;
#if USE_CLEARCOAT
    float clearCoatRoughness;
    float clearCoatStrength;
#endif

    vec3 F0;
    mediump float cDiffFactor;
};

struct TangentSpaceData
{
#if USE_TANGENT_SPACE
    highp mat3 tbn;
#endif
    highp vec3 normal;
};

struct NormalData
{
    highp vec3 normal;
#if USE_CLEARCOAT
    highp vec3 clearCoatNormal;
#endif
};

struct ColorData
{
    mediump vec3 diffuse;
    mediump vec3 specular;
#if USE_CLEARCOAT
    mediump vec3 clearcoat;
#endif
};

ColorData ZeroColorData()
{
    ColorData outColor;

    outColor.diffuse = vec3(0.0);
    outColor.specular = vec3(0.0);
#if USE_CLEARCOAT
    outColor.clearcoat = vec3(0.0);
#endif

    return outColor;
}

vec3 DirectDiffuse(mediump vec3 lightIntensity, mediump vec3 color)
{
    // According to the glTF specification, diffuse should be multiplied by (1 - fresnel), but that leads
    // to darker smooth metallic materials than those observed with other rendering engines, such as
    // Filament, BabylonJS, and Unreal Engine 4. These engines seem to apply fresnel only to the specular
    // term. See fresnel_mix here:
    // https://github.com/KhronosGroup/glTF/tree/master/specification/2.0#appendix-b-brdf-implementation
    return lightIntensity * color / PI;
}

vec3 DirectSpecular(mediump vec3 lightIntensity,
                    lowp float roughness,
                    mediump vec3 f0,
                    highp float NdotL,
                    highp float NdotV,
                    highp float NdotH,
                    highp float HdotV)
{
    mediump float dist = Distribution(NdotH, roughness);
    mediump float vis = Vis_SmithGGXCorrelatedFast(NdotV, NdotL, roughness);
    mediump vec3 fresnel = Fresnel(HdotV, f0);
    return lightIntensity * dist * vis * fresnel;
}

void ComputeLight(inout ColorData color, mediump vec3 V, NormalData normalData, highp vec3 L, mediump vec3 lightColor, MaterialData mat)
{
    highp vec3 N = normalData.normal;

    // GLSL clamp to 0..1 is undefined for NaNs (as opposed to HLSL saturate). H can be NaN
    // when V and L point exactly to the same direction. Because of this, NdotH and HdotV may
    // have undefined values in such case. Handle H == NaN by explicitly checking if V and L point
    // to the same direction.
    highp vec3 H = vec3(0.0);
    if (dot(V, L) <= 1.0 - 1e-7)
    {
        H = normalize(-V + L);
    }

    highp   float NdotH = clamp(dot(N,  H), 0.0, 1.0);
    highp   float NdotV = clamp(dot(N, -V), 0.0, 1.0);
    highp   float NdotL = clamp(dot(N,  L), 0.0, 1.0);
    mediump float HdotV = clamp(dot(H, -V), 0.0, 1.0);

    mediump vec3 lightIntensity = lightColor * NdotL;

    color.specular += DirectSpecular(lightIntensity, mat.roughness, mat.F0, NdotL, NdotV, NdotH, HdotV);
    color.diffuse += DirectDiffuse(lightIntensity, mat.baseColor.rgb) * mat.cDiffFactor;

#if USE_CLEARCOAT
    vec3 dielectricSpecular = vec3(0.04);
    lowp float ccRoughness = mix(0.03, 0.6, mat.clearCoatRoughness);
    highp vec3 ccNormal = normalData.clearCoatNormal;
    highp float ccNdotH = clamp(dot(ccNormal,  H), 0.0, 1.0);
    highp float ccNdotV = clamp(dot(ccNormal, -V), 0.0, 1.0);
    highp float ccNdotL = clamp(dot(ccNormal,  L), 0.0, 1.0);

    mediump vec3 ccLightIntensity = lightColor * ccNdotL;
    color.clearcoat += DirectSpecular(ccLightIntensity, ccRoughness, dielectricSpecular, ccNdotL, ccNdotV, ccNdotH, HdotV);
#endif
    return;
}

#if KANZI_SHADER_USE_VERTEX_COLOR
vec4 VertexColor()
{
    // note: clamping is required to prevent artifacts caused by over-interpolation
    // when MSAA is enabled.
    return clamp(vColor, vec4(0.0), vec4(1.0));
}
#endif

#if USE_METALLIC_ROUGHNESS
vec4 BaseColor()
{
    vec4 baseColor = BaseColorFactor;

#if KANZI_SHADER_USE_VERTEX_COLOR
    baseColor *= VertexColor();
#endif

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE
    vec4 baseColorTex = texture(BaseColorTexture, vTexCoord[KANZI_SHADER_USE_BASECOLOR_TEXTURE_COORDINATE_INDEX]);
    baseColor *= baseColorTex;
#endif

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE_DETAIL
    vec4 baseColorTilableTex = texture(DetailBaseColorTexture, vDetailTexCoord[KANZI_SHADER_USE_BASECOLOR_TEXTURE_COORDINATE_INDEX_DETAIL]);
    vec4 tilableFactor = DetailBaseColorFactor;
    vec4 baseColorTilable = baseColorTilableTex * tilableFactor;

    // Blend tilable texture color with base texture. (Treat base color alpha as 1 for color,
    // because it is really the fragment output alpha, not the input alpha.)
    baseColor.rgb = mix(baseColor.rgb, baseColorTilable.rgb, baseColorTilable.a);
    // To create a combined output alpha for the fragment, blend tilable texture alpha with base texture alpha normally.
    baseColor.a = baseColorTilable.a + baseColor.a * (1.0 - baseColorTilable.a);
#endif

    return baseColor;
}

float Metalness()
{
    // Metalness is in the 'b' channel

    float metalness = MetallicFactor;

#if KANZI_SHADER_USE_METALLIC_TEXTURE
    metalness *= texture(MetallicTexture, vTexCoord[KANZI_SHADER_USE_METALLIC_TEXTURE_COORDINATE_INDEX]).b;
#endif

#if KANZI_SHADER_USE_METALLIC_TEXTURE_DETAIL
    metalness *= texture(DetailMetallicTexture, vDetailTexCoord[KANZI_SHADER_USE_METALLIC_TEXTURE_COORDINATE_INDEX_DETAIL]).b;
#endif

    return clamp(metalness, 0.0, 1.0);
}

float Roughness()
{
    // Roughness is in the 'g' channel
    float roughness = RoughnessFactor;

#if KANZI_SHADER_USE_ROUGHNESS_TEXTURE
    roughness *= texture(RoughnessTexture, vTexCoord[KANZI_SHADER_USE_ROUGHNESS_TEXTURE_COORDINATE_INDEX]).g;
#endif

#if KANZI_SHADER_USE_ROUGHNESS_TEXTURE_DETAIL
    roughness *= texture(DetailRoughnessTexture, vDetailTexCoord[KANZI_SHADER_USE_ROUGHNESS_TEXTURE_COORDINATE_INDEX_DETAIL]).g;
#endif

    return clamp(roughness, 0.0, 1.0);
}
#endif

#if USE_CLEARCOAT
float ClearCoatRoughness()
{
    // Roughness is in the 'g' channel
    float roughness = ClearCoatRoughnessFactor;

#if KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE
    roughness *= texture(ClearCoatRoughnessTexture, vTexCoord[KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_COORDINATE_INDEX]).g;
#endif

#if KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_DETAIL
    roughness *= texture(DetailClearCoatRoughnessTexture, vDetailTexCoord[KANZI_SHADER_USE_CLEARCOAT_ROUGHNESS_TEXTURE_COORDINATE_INDEX_DETAIL]).g;
#endif

    return clamp(roughness, 0.0, 1.0);
}

float ClearCoatStrength()
{
    // Strength is in the 'r' channel
    float strength = ClearCoatStrengthFactor;

#if KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE
    strength *= texture(ClearCoatStrengthTexture, vTexCoord[KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_COORDINATE_INDEX]).r;
#endif

#if KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_DETAIL
    strength *= texture(DetailClearCoatStrengthTexture, vDetailTexCoord[KANZI_SHADER_USE_CLEARCOAT_STRENGTH_TEXTURE_COORDINATE_INDEX_DETAIL]).r;
#endif

    return clamp(strength, 0.0, 1.0);
}
#endif

#if USE_SPECULAR_GLOSSINESS
vec4 Diffuse()
{
    vec4 diffuse = DiffuseFactor;

#if KANZI_SHADER_USE_VERTEX_COLOR
    diffuse *= VertexColor();
#endif

#if KANZI_SHADER_USE_DIFFUSE_TEXTURE
    vec4 diffuseTex = texture(DiffuseTexture, vTexCoord[KANZI_SHADER_USE_DIFFUSE_TEXTURE_COORDINATE_INDEX]);
    diffuse *= diffuseTex;
#endif

#if KANZI_SHADER_USE_DIFFUSE_TEXTURE_DETAIL
    vec4 diffuseTilableTex = texture(DetailDiffuseTexture, vDetailTexCoord[KANZI_SHADER_USE_DIFFUSE_TEXTURE_COORDINATE_INDEX_DETAIL]);
    vec4 tilableFactor = DetailDiffuseFactor;
    vec4 diffuseTilable = diffuseTilableTex * tilableFactor;

    // Blend tilable texture color with base texture. (Treat diffuse alpha as 1 for color,
    // because it is really the fragment output alpha, not the input alpha.)
    diffuse.rgb = mix(diffuse.rgb, diffuseTilable.rgb, diffuseTilable.a);
    // To create a combined output alpha for the fragment, blend tilable texture alpha with base texture alpha normally.
    diffuse.a = diffuseTilable.a + diffuse.a * (1.0 - diffuseTilable.a);
#endif

    return diffuse;
}

vec3 Specular()
{
    vec3 specular = SpecularFactor.rgb;

#if KANZI_SHADER_USE_SPECULAR_TEXTURE
    vec3 specularTex = texture(SpecularTexture, vTexCoord[KANZI_SHADER_USE_SPECULAR_TEXTURE_COORDINATE_INDEX]).rgb;
    specular *= specularTex;
#endif

#if KANZI_SHADER_USE_SPECULAR_TEXTURE_DETAIL
    vec4 specularTilableTex = texture(DetailSpecularTexture, vDetailTexCoord[KANZI_SHADER_USE_SPECULAR_TEXTURE_COORDINATE_INDEX_DETAIL]);
    vec4 tilableFactor = DetailSpecularFactor;
    vec4 specularTilable = specularTilableTex * tilableFactor;

    // Blend Tilable texture with base texture
    // NOTE: DetailSpecularTexture cannot pack glossiness into alpha
    specular = mix(specular, specularTilable.rgb, specularTilable.a);
#endif

    return specular;
}

float Glossiness()
{
    // Glossiness is in the 'a' channel
    float glossiness = GlossinessFactor;

#if KANZI_SHADER_USE_GLOSSINESS_TEXTURE
    glossiness *= texture(GlossinessTexture, vTexCoord[KANZI_SHADER_USE_GLOSSINESS_TEXTURE_COORDINATE_INDEX]).a;
#endif

#if KANZI_SHADER_USE_GLOSSINESS_TEXTURE_DETAIL
    glossiness *= texture(DetailGlossinessTexture, vDetailTexCoord[KANZI_SHADER_USE_GLOSSINESS_TEXTURE_COORDINATE_INDEX_DETAIL]).a;
#endif

    return clamp(glossiness, 0.0, 1.0);
}
#endif

vec3 Emissive()
{
    vec3 emissive = EmissiveFactor.rgb;

#if KANZI_SHADER_USE_EMISSIVE_TEXTURE
    vec3 emissiveTex = texture(EmissiveTexture, vTexCoord[KANZI_SHADER_USE_EMISSIVE_TEXTURE_COORDINATE_INDEX]).rgb;
    emissive *= emissiveTex;
#endif

#if KANZI_SHADER_USE_EMISSIVE_TEXTURE_DETAIL
    vec4 emissiveTilableTex = texture(DetailEmissiveTexture, vDetailTexCoord[KANZI_SHADER_USE_EMISSIVE_TEXTURE_COORDINATE_INDEX_DETAIL]);
    vec4 tilableFactor = DetailEmissiveFactor;
    vec4 emissiveTilable = emissiveTilableTex * tilableFactor;

    // Blend Tilable texture with base texture.
    emissive = mix(emissive, emissiveTilable.rgb, emissiveTilable.a);
#endif

    return emissive;
}

float AmbientOcclusion()
{
    // Occlusion is in the 'r' channel
    float AO = 1.0;

#if KANZI_SHADER_USE_OCCLUSION_TEXTURE
    AO *= 1.0 - (1.0 - texture(OcclusionTexture, vTexCoord[KANZI_SHADER_USE_OCCLUSION_TEXTURE_COORDINATE_INDEX]).r) * OcclusionStrength;
#endif

#if KANZI_SHADER_USE_OCCLUSION_TEXTURE_DETAIL
    AO *= 1.0 - (1.0 - texture(DetailOcclusionTexture, vDetailTexCoord[KANZI_SHADER_USE_OCCLUSION_TEXTURE_COORDINATE_INDEX_DETAIL]).r) * DetailOcclusionStrength;
#endif

    return clamp(AO, 0.0, 1.0);
}

TangentSpaceData GetTangentSpaceData()
{
    TangentSpaceData result;
    result.normal = normalize(vNormal);
#if USE_TANGENT_SPACE
    result.tbn = mat3(normalize(vTangent), normalize(vBinormal), result.normal);
#endif
    return result;
}

highp vec3 Normal(TangentSpaceData tangentSpaceData)
{
#if KANZI_SHADER_USE_NORMALMAP_TEXTURE
    highp vec3 textureNormal = texture(NormalTexture, vTexCoord[KANZI_SHADER_USE_NORMALMAP_TEXTURE_COORDINATE_INDEX]).xyz;
    highp vec3 baseNormalFactor = mix(vec3(0.0, 0.0, 1.0), textureNormal * 2.0 - 1.0, NormalScale);
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL
    highp vec3 tilableNormal = texture(DetailNormalTexture, vDetailTexCoord[KANZI_SHADER_USE_NORMALMAP_TEXTURE_COORDINATE_INDEX_DETAIL]).xyz;
    highp vec3 tilableNormalFactor = mix(vec3(0.0, 0.0, 1.0), tilableNormal * 2.0 - 1.0, DetailNormalScale);
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE && KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL
    highp vec3 normalFactor = vec3(baseNormalFactor.xy + tilableNormalFactor.xy, baseNormalFactor.z);
#elif KANZI_SHADER_USE_NORMALMAP_TEXTURE
    highp vec3 normalFactor = baseNormalFactor;
#elif KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL
    highp vec3 normalFactor = tilableNormalFactor;
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE || KANZI_SHADER_USE_NORMALMAP_TEXTURE_DETAIL
    highp vec3 N = normalize(tangentSpaceData.tbn * normalFactor);
#else
    highp vec3 N = tangentSpaceData.normal;
#endif

    return N;
}

#if USE_CLEARCOAT
highp vec3 ClearCoatNormal(TangentSpaceData tangentSpaceData)
{
#if KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE
    highp vec3 textureNormal = texture(ClearCoatNormalTexture, vTexCoord[KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_COORDINATE_INDEX]).xyz;
    highp vec3 baseNormalFactor = mix(vec3(0.0, 0.0, 1.0), textureNormal * 2.0 - 1.0, ClearCoatNormalScale);
#endif

#if KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL
    highp vec3 tilableNormal = texture(DetailClearCoatNormalTexture, vDetailTexCoord[KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_COORDINATE_INDEX_DETAIL]).xyz;
    highp vec3 tilableNormalFactor = mix(vec3(0.0, 0.0, 1.0), tilableNormal * 2.0 - 1.0, DetailClearCoatNormalScale);
#endif

#if KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE && KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL
    highp vec3 normalFactor = vec3(baseNormalFactor.xy + tilableNormalFactor.xy, baseNormalFactor.z);
#elif KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE
    highp vec3 normalFactor = baseNormalFactor;
#elif KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL
    highp vec3 normalFactor = tilableNormalFactor;
#endif

#if KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE || KANZI_SHADER_USE_CLEARCOAT_NORMALMAP_TEXTURE_DETAIL
    highp vec3 N = normalize(tangentSpaceData.tbn * normalFactor);
#else
    highp vec3 N = normalize(tangentSpaceData.normal);
#endif

    return N;
}
#endif

float QueryMipLevels(samplerCube t)
{
    ivec2 size = textureSize(t, 0);
    return floor(log2(max(float(size.x), float(size.y)))) + 1.0;
}

float QueryMipLevels(sampler2D t)
{
    ivec2 size = textureSize(t, 0);
    return floor(log2(max(float(size.x), float(size.y)))) + 1.0;
}

vec3 IBLDiffuse(mediump vec3 sampledColor, vec3 baseColor)
{
    return sampledColor * baseColor.rgb;
}

vec3 IBLSpecular(mediump vec3 sampledColor, highp vec3 F0, highp float NdotV, highp float roughness)
{
#if KANZI_SHADER_USE_BRDF_LOOKUP_TABLE
    vec2 brdfSamplePoint = clamp(vec2(NdotV, roughness), vec2(0.0, 0.0), vec2(1.0, 1.0));
    mediump vec2 brdf = texture(BrdfLookUpTable, brdfSamplePoint).rg;
#else
    // Modified IBL BRDF based on UE4 mobile approximation
    // for reference see EnvBRDFApprox: https://www.unrealengine.com/en-US/blog/physically-based-shading-on-mobile
    const mediump vec4 constants0 = vec4(-0.97, -0.0165, -0.572, 0.027);
    const mediump vec4 constants1 = vec4(1.0, 0.03, 1.04, -0.04);
    mediump vec3 r = roughness * constants0.yzw + constants1.yzw;

    vec2 params = 1.0 - vec2(roughness, NdotV);
    params = 1.0 - params * vec2(params.x * params.x, params.y);
    float fresnelFactor =  mix(params.x, roughness, params.y) * constants0.x + constants1.x;
    mediump float fresnel = exp2(-9.28 * NdotV);

    mediump float a004 = fresnel * fresnelFactor + r.x;
    mediump vec2 brdf = vec2(-1.04, 1.04) * a004 + r.yz;
#endif  // KANZI_SHADER_USE_BRDF_LOOKUP_TABLE

    highp vec3 spec = (F0 * brdf.x + brdf.y);

    return sampledColor * spec;
}

// Calculate dominant direction to sample the radiance IBL cubemap texture.
// When roughness approaches one, the sampling direction approaches that of
// diffuse reflection (surface normal). At roughness zero, the sampling direction
// is the reflection vector R.
// Reference: "Moving Frostbite to Physically Based Rendering 3.0, Sebastien Lagarde and Charles de Rousiersm, 2014".
vec3 GetSpecularDominantDir(vec3 N, vec3 R, float roughness)
{
    float roughnessSqr = roughness * roughness;
    float glossiness = clamp(1. - roughnessSqr, 0., 1.);
    float lerpFactor = glossiness * (sqrt(glossiness) + roughnessSqr);
    return mix(N, R, lerpFactor);
}

void ImageBasedLight(inout ColorData color, mediump vec3 V, NormalData normalData, MaterialData mat)
{
#if KANZI_SHADER_USE_LIGHT_IMAGE_BASED

    vec3 dielectricSpecular = vec3(0.04);

    float mipLevels = QueryMipLevels(EnvironmentReflectionTexture);
    float roughnessOneLod = mipLevels - (float(KANZI_SHADER_ROUGHNESS_ONE_LOD_OFFSET) + 1.0);

    {
        highp vec3 N = normalData.normal;
        highp vec3 R = reflect(V, N);

        highp float NdotV = clamp(dot(N, -V), 0.0, 1.0);

        vec3 diffuseColor = texture(EnvironmentAmbientTexture, N).rgb * EnvironmentAmbientFactor;
        diffuseColor = IBLDiffuse(diffuseColor, mat.baseColor.rgb);
        diffuseColor *= mat.ambientOcclusion * mat.cDiffFactor;
        color.diffuse += diffuseColor;

        float roughnessMipLevel = mat.roughness * roughnessOneLod;
        vec3 dominantSpecularDirection = GetSpecularDominantDir(N, R, mat.roughness);
        vec3 reflectionCube = textureLod(EnvironmentReflectionTexture, dominantSpecularDirection,
                                         roughnessMipLevel).rgb * EnvironmentReflectionFactor;

        color.specular += IBLSpecular(reflectionCube, mat.F0, NdotV, mat.roughness);
    }

#if USE_CLEARCOAT
    {
        //Calculate Clear Coat
        lowp float ccRoughness = mix(0.03, 0.6, mat.clearCoatRoughness);
        highp vec3 ccNormal = normalData.clearCoatNormal;
        highp vec3 ccR = reflect(V, ccNormal);
        highp float ccNdotV = clamp(dot(ccNormal, -V), 0.0, 1.0);
        vec3 dominantSpecularDir = GetSpecularDominantDir(ccNormal, ccR, ccRoughness);
        vec3 ccReflectionCube = textureLod(EnvironmentReflectionTexture, dominantSpecularDir,
                ccRoughness * roughnessOneLod).rgb * EnvironmentReflectionFactor;

        // we pass in dielectricSpecular here instead of a calculated F0, because clearcoat's metalness is always 0.
        color.clearcoat += IBLSpecular(ccReflectionCube, dielectricSpecular, ccNdotV, ccRoughness);
    }
#endif  // USE_CLEARCOAT

#endif  // KANZI_SHADER_USE_LIGHT_IMAGE_BASED
}


void PlanarBasedLight(inout ColorData color, highp vec4 fragPos, mediump vec3 V, NormalData normalData, MaterialData mat)
{
#if KANZI_SHADER_RECEIVE_PLANAR_REFLECTION
    vec2 uv = PositionToProjectedUVs(vPlanarReflectionPosition, 0.0).xy;

    vec3 dielectricSpecular = vec3(0.04);

    // For now, reflectedColor acts as both diffuse and specular. Until we can generate
    // a diffuse convolution
    float mipLevels = QueryMipLevels(PlanarReflectionMap);

    {
        highp vec3 N = normalData.normal;
        highp float NdotV = clamp(dot(N, -V), 0.0, 1.0);

        //Always the second-to-last mip for the diffuse. Last mip might be too small.
        vec3 diffuseColor = textureLod(PlanarReflectionMap, uv, mipLevels-2.0).rgb;
        diffuseColor = IBLDiffuse(diffuseColor, mat.baseColor.rgb);
        diffuseColor *= mat.ambientOcclusion * mat.cDiffFactor;
        color.diffuse += diffuseColor;

        vec3 reflectedColor = textureLod(PlanarReflectionMap, uv, mat.roughness * mipLevels).rgb;
        color.specular += IBLSpecular(reflectedColor, mat.F0, NdotV, mat.roughness);
    }

#if USE_CLEARCOAT
    {
        lowp float ccRoughness = mix(0.03, 0.6, mat.clearCoatRoughness);
        highp vec3 ccNormal = normalData.clearCoatNormal;
        highp float ccNdotV = clamp(dot(ccNormal, -V), 0.0, 1.0);

        vec3 ccReflectedColor = textureLod(PlanarReflectionMap, uv, ccRoughness * mipLevels).rgb;

        color.clearcoat += IBLSpecular(ccReflectedColor, dielectricSpecular, ccNdotV, ccRoughness);
    }
#endif  // USE_CLEARCOAT

#endif  //KANZI_SHADER_RECEIVE_PLANAR_REFLECTION
}


void AmbientLight(inout ColorData color, mediump vec3 V, NormalData normalData, MaterialData mat)
{
    vec3 dielectricSpecular = vec3(0.04);

    {
        highp vec3 N = normalData.normal;
        float NdotV = clamp(dot(N, -V), 0.0, 1.0);

        vec3 diffuseColor = IBLDiffuse(Ambient.rgb, mat.baseColor.rgb);
        diffuseColor *= mat.ambientOcclusion * mat.cDiffFactor;

        color.diffuse += diffuseColor;
        color.specular += IBLSpecular(Ambient.rgb, mat.F0, NdotV, mat.roughness);
    }
#if USE_CLEARCOAT
    {
        lowp float ccRoughness = mix(0.03, 0.6, mat.clearCoatRoughness);
        highp vec3 ccNormal = normalData.clearCoatNormal;
        highp float ccNdotV = clamp(dot(ccNormal, -V), 0.0, 1.0);
        color.clearcoat += IBLSpecular(Ambient.rgb, dielectricSpecular, ccNdotV, ccRoughness);
    }
#endif //USE_CLEARCOAT
}


void DirectionalLight(inout ColorData color, mediump vec3 V, NormalData normalData, MaterialData mat)
{
#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
#if KANZI_SHADER_RECEIVE_DIRECTIONAL_SHADOW
    //Compute the light for the first directional light, considering shadow.
    float shadow = Shadow(DirectionalShadowMap,
                          vDirectionalLightShadowPosition, DirectionalShadowBias);

    ComputeLight(color, V, normalData, vDirectionalLightDirection[0],
                 DirectionalLightColor[0].rgb * shadow, mat);

    int i = 1;
#else
    int i = 0;
#endif
    for (; i < KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS; ++i)
    {
        ComputeLight(color, V, normalData, vDirectionalLightDirection[i],
            DirectionalLightColor[i].rgb, mat);
    }
#endif
}


void PointLight(inout ColorData color, mediump vec3 V, NormalData normalData, MaterialData mat)
{
#if KANZI_SHADER_NUM_POINT_LIGHTS
#if KANZI_SHADER_RECEIVE_POINT_SHADOW
    {
        mediump vec3 c = PointLightAttenuation[0];
        mediump float d = length(vPointLightDirection[0]);
        highp vec3 L = -vPointLightDirection[0]/d;

                                                                                  
        float shadow = PointShadow(PointShadowMap, -L, PointShadowBias);
       

        mediump float attenuation = 1.0 / (0.01 + c.x + c.y * d + c.z * d * d);
        attenuation *= (PointLightRadius[0] == 0.0) ? 1.0 : clamp(1.0 - pow((d / PointLightRadius[0] ),4.0), 0.0, 1.0);

        mediump vec3 pointLightColor = PointLightColor[0].rgb * attenuation;

        ComputeLight(color, V, normalData, L, pointLightColor * shadow, mat);
    }
    int i = 1;
#else
    int i = 0;
#endif

    for (;i < KANZI_SHADER_NUM_POINT_LIGHTS; ++i)
    {
        mediump vec3 c = PointLightAttenuation[i];
        mediump float d = length(vPointLightDirection[i]);
        highp vec3 L = -vPointLightDirection[i]/d;

        mediump float attenuation = 1.0 / (0.01 + c.x + c.y * d + c.z * d * d);
        attenuation *= (PointLightRadius[i] == 0.0) ? 1.0 : clamp(1.0 - pow((d / PointLightRadius[i]), 4.0), 0.0, 1.0);

        mediump vec3 pointLightColor = PointLightColor[i].rgb * attenuation;

        ComputeLight(color, V, normalData, L, pointLightColor, mat);
    }
#endif
}


float CalculateSpotLightAttenuation(vec3 lightDirection, vec3 spotDirection,
                                    vec3 attenuationData, vec3 coneData, vec3 N,
                                    float spotLightRadius, float lightDistance)
{
    highp float LdotN = dot(lightDirection, N);
    if (LdotN > 0.0)
    {
        highp float cosDirection = dot(lightDirection, -spotDirection);
        highp float cosOuter = coneData.x;
        highp float t = cosDirection - cosOuter;
        if (t > 0.0)
        {
            highp vec3 c = attenuationData;
            highp float denom = (0.01 + c.x + c.y * lightDistance + c.z * lightDistance * lightDistance) * coneData.z;

            mediump float rangeAttenuation = (spotLightRadius == 0.0) ? 1.0 : clamp(1.0 - pow((lightDistance / spotLightRadius), 4.0), 0.0, 1.0);

            return min(t / denom, 1.0) * rangeAttenuation;
        }
        return 0.0f;
    }
    return 0.0f;
}


void SpotLight(inout ColorData color, mediump vec3 V, NormalData normalData, MaterialData mat)
{
#if KANZI_SHADER_NUM_SPOT_LIGHTS
#if KANZI_SHADER_RECEIVE_SPOT_SHADOW
    //Compute the light for the first directional light, considering shadow.

    {
        highp float d = length(vSpotLightDirection[0]);
        highp vec3 L = -vSpotLightDirection[0] / d;

        float attenuation = CalculateSpotLightAttenuation(L,
                                            SpotLightDirection[0],
                                            SpotLightAttenuation[0],
                                            SpotLightConeParameters[0],
                                            normalData.normal,
                                            SpotLightRadius[0], d);

        float shadow = Shadow(SpotShadowMap,
                          vSpotLightShadowPosition, SpotShadowBias);
        vec3 spotLightColor = SpotLightColor[0].rgb * (shadow * attenuation);
        ComputeLight(color, V, normalData, L, spotLightColor, mat);
    }
    int i = 1;

#else
    int i = 0;
#endif
    for (; i < KANZI_SHADER_NUM_SPOT_LIGHTS; ++i)
    {
        highp float d = length(vSpotLightDirection[i]);
        highp vec3 L = -vSpotLightDirection[i] / d;

        mediump float attenuation = CalculateSpotLightAttenuation(L,
                                        SpotLightDirection[i],
                                        SpotLightAttenuation[i],
                                        SpotLightConeParameters[i],
                                        normalData.normal,
                                        SpotLightRadius[i], d);

        vec3 spotLightColor = SpotLightColor[i].rgb * attenuation;
        ComputeLight(color, V, normalData, L, spotLightColor, mat);
    }
#endif
}


mediump vec3 MixColor(inout ColorData inColor,
                      vec3 emissive,
                      mediump vec3 V,
                      NormalData normalData,
                      MaterialData mat)
{
    mediump vec3 color = inColor.diffuse + inColor.specular + emissive;

#if USE_CLEARCOAT
    vec3 dielectricSpecular = vec3(0.04);
    highp vec3 ccNormal = normalData.clearCoatNormal;
    highp float ccNdotV = max(0.0, dot(ccNormal, -V));
    highp vec3 ccFresnel = Fresnel(ccNdotV, dielectricSpecular) * mat.clearCoatStrength;

    inColor.clearcoat *= mat.clearCoatStrength;

    color = color * (1.0 - ccFresnel) + inColor.clearcoat;
#endif

    return color;
}


#if KANZI_SHADER_USE_GAMMA_CORRECTION
float LinearToSRGB(float src)
{
    if ( src < 0.0031308 )
    {
        return src * 12.92;
    }
    else
    {
        return 1.055 * pow(src, 1.0/2.4) - 0.055;
    }
}

vec3 LinearToSRGB(vec3 src)
{
    return vec3(
        LinearToSRGB(src.r),
        LinearToSRGB(src.g),
        LinearToSRGB(src.b));
}
#endif

float CalculateEffectiveAmbientOcclusion(float ao, float metalness, float roughness)
{
    return mix(ao, min(1.0, roughness * (1.0/0.33) ) * ao, metalness);
}

float ApplySpecularAntiAliasing(float roughness, vec3 normal)
{
#if KANZI_SHADER_USE_SPECULAR_ANTI_ALIASING
    // For reference see specular AA approximation intended for deferred shading in this
    // presentation:
    // http://www.jp.square-enix.com/tech/library/pdf/ImprovedGeometricSpecularAA(slides).pdf
    vec3 dNdx = dFdx(normal);
    vec3 dNdy = dFdy(normal);
    float variance = SpecularAntiAliasingStrength * (dot(dNdx, dNdx) + dot(dNdy, dNdy));
    float kernelRoughnessSquared = min(variance, SpecularAntiAliasingThreshold);
    return sqrt(clamp(roughness * roughness + kernelRoughnessSquared, 0.0, 1.0));
#else
    return roughness;
#endif
}

void main()
{
    mediump vec3 V = normalize(vViewDirection);

    NormalData normalData;
    TangentSpaceData tangentSpaceData = GetTangentSpaceData();
    normalData.normal = Normal(tangentSpaceData);
#if USE_CLEARCOAT
    normalData.clearCoatNormal = ClearCoatNormal(tangentSpaceData);
#endif

    MaterialData mat;
    vec3 dielectricSpecular = vec3(0.04);
#if USE_METALLIC_ROUGHNESS
    mat.baseColor = BaseColor();
    mat.metalness = Metalness();
    mat.roughness = Roughness();
    mat.cDiffFactor = mix(1.0 - dielectricSpecular.r, 0.0, mat.metalness);
    mat.F0 = mix(dielectricSpecular, mat.baseColor.rgb, mat.metalness);

    float effectiveMetalness = mat.metalness;
#elif USE_SPECULAR_GLOSSINESS
    mat.baseColor = Diffuse();
    mat.specular = Specular();
    mat.roughness = 1.0 - Glossiness();

    float maxSpecular = max(max(mat.specular.r, mat.specular.g), mat.specular.b);
    mat.cDiffFactor = 1.0 - maxSpecular;
    mat.F0 = mat.specular;

    float effectiveMetalness = max(0.0, (maxSpecular - dielectricSpecular.r) / (1.0 - dielectricSpecular.r));
#endif

    mat.roughness = ApplySpecularAntiAliasing(mat.roughness, normalData.normal);
    mat.emissive = Emissive();
    mat.ambientOcclusion = CalculateEffectiveAmbientOcclusion(AmbientOcclusion(),
                                                              effectiveMetalness,
                                                              mat.roughness);
#if USE_CLEARCOAT
    mat.clearCoatRoughness = ClearCoatRoughness();
    mat.clearCoatStrength = ClearCoatStrength();
    mat.clearCoatRoughness = ApplySpecularAntiAliasing(mat.clearCoatRoughness, normalData.clearCoatNormal);
#endif

    ColorData lightColor = ZeroColorData();

    ImageBasedLight(lightColor, V, normalData, mat);
    DirectionalLight(lightColor, V, normalData, mat);
    PointLight(lightColor, V, normalData, mat);
    SpotLight(lightColor, V, normalData, mat);
    PlanarBasedLight(lightColor, vFragPosition, V, normalData, mat);
    AmbientLight(lightColor, V, normalData, mat);

    #if KANZI_SHADER_USE_ALPHA_CUTOFF
    // NOTE: To guarantee uniform control flow up to this point, and thus valid
    // gradient calculation, discard must be made after all texture fetches.
    if (mat.baseColor.a < AlphaCutoff) discard;
    #endif

    mediump vec3 color = MixColor(lightColor, mat.emissive, V, normalData, mat);

    #if KANZI_SHADER_USE_EXPOSURE
    color *= pow(2.0, Exposure);
    #endif

    #if USE_TONEMAP
    color = Tonemap(color);
    #endif

    float outAlpha = BlendIntensity;

    #if KANZI_SHADER_USE_ALPHA
    outAlpha *= mat.baseColor.a;
    #endif

    #if KANZI_SHADER_USE_GAMMA_CORRECTION
    color = LinearToSRGB(color);
    #endif

    outColor = vec4(color * outAlpha, outAlpha);

#if KANZI_SHADER_DEBUG_OUTPUT
    outColor = mix(outColor, mat.baseColor, KanziPBR_Debug_Albedo);
    outColor = mix(outColor, vec4(mat.roughness, 0.0, 0.0, 1.0), KanziPBR_Debug_Roughness);
#if USE_METALLIC_ROUGHNESS
    outColor = mix(outColor, vec4(mat.metalness, 0.0, 0.0, 1.0), KanziPBR_Debug_Metalness);
#elif USE_SPECULAR_GLOSSINESS
    outColor = mix(outColor, vec4(mat.specular, 1.0), KanziPBR_Debug_Specular);
#endif
    outColor = mix(outColor, vec4(mat.emissive, 1.0), KanziPBR_Debug_Emissive);
    outColor = mix(outColor, vec4(normalData.normal*0.5 + 0.5, 1.0), KanziPBR_Debug_Normal);
    outColor = mix(outColor, vec4(mat.ambientOcclusion, mat.ambientOcclusion, mat.ambientOcclusion, 1.0), KanziPBR_Debug_AmbientOcclusion);

    outColor = mix(outColor, vec4(lightColor.diffuse + lightColor.specular, 1.0), KanziPBR_Debug_LightColor);
#if USE_CLEARCOAT
    outColor = mix(outColor, vec4(lightColor.clearcoat, 1.0), KanziPBR_Debug_ClearCoat);
#endif
#endif
}
