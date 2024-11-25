uniform lowp    vec4  Ambient;
uniform lowp    vec4  Diffuse;
uniform lowp    vec4  SpecularColor;
uniform mediump float SpecularExponent;
uniform lowp    vec4  Emissive;
uniform lowp    float BlendIntensity;

varying mediump vec3 vNormal;
varying mediump vec3 vViewDirection;

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE || KANZI_SHADER_USE_NORMALMAP_TEXTURE
varying mediump vec2 vTexCoord;
#endif

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE
uniform lowp sampler2D Texture;
#endif

#if KANZI_SHADER_USE_NORMALMAP_TEXTURE
uniform lowp sampler2D NormalMapTexture;
uniform lowp float     NormalMapStrength;
varying mediump vec3   vTangent;
varying mediump vec3   vBinormal;
#endif

#if KANZI_SHADER_USE_REFLECTION_CUBE
uniform lowp samplerCube TextureCube;
uniform lowp vec4        CubemapColor;
#endif

#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
uniform lowp    vec4 DirectionalLightColor     [KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
varying mediump vec3 vDirectionalLightDirection[KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS];
#endif

#if KANZI_SHADER_NUM_POINT_LIGHTS
uniform lowp    vec4 PointLightColor      [KANZI_SHADER_NUM_POINT_LIGHTS];
uniform mediump vec3 PointLightAttenuation[KANZI_SHADER_NUM_POINT_LIGHTS];
varying mediump vec3 vPointLightDirection [KANZI_SHADER_NUM_POINT_LIGHTS];
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
uniform mediump vec4  SpotLightColor         [KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform mediump vec3  SpotLightDirection     [KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform mediump vec3  SpotLightConeParameters[KANZI_SHADER_NUM_SPOT_LIGHTS];
uniform mediump vec3  SpotLightAttenuation   [KANZI_SHADER_NUM_SPOT_LIGHTS];
varying mediump vec3  vSpotLightDirection    [KANZI_SHADER_NUM_SPOT_LIGHTS];
#endif

void main()
{
    precision mediump float;
    
    lowp vec3 color = vec3(0.0);
    
#if KANZI_SHADER_USE_NORMALMAP_TEXTURE    
    vec3 textureNormal = texture2D(NormalMapTexture, vTexCoord).xyz * 2.0 - vec3(1.0);
    vec3 NormalFactor = mix(vec3(0.0, 0.0, 1.0), textureNormal, NormalMapStrength);
    vec3 N = normalize(vec3(vTangent * NormalFactor.x + 
                            vBinormal * NormalFactor.y +
                            vNormal * NormalFactor.z));
#else
    vec3 N = normalize(vNormal);
#endif

    vec3 V = normalize(vViewDirection);
    
#if KANZI_SHADER_USE_REFLECTION_CUBE    
    vec3 R = reflect(V, N);
#endif

#if KANZI_SHADER_USE_BASECOLOR_TEXTURE
    lowp vec4 baseColor = texture2D(Texture, vTexCoord);
#else
    lowp vec4 baseColor = vec4(1.0);
#endif

    color += baseColor.rgb * Ambient.rgb;

    // Apply directional light 0.
#if KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_DIRECTIONAL_LIGHTS; ++i)
    {
        vec3 L = vDirectionalLightDirection[i];
        vec3 H = normalize(-V + L);
        
        float LdotN = max(0.0, dot(L, N));
        float NdotH = max(0.0, dot(N, H));
        float specular = pow(NdotH, SpecularExponent);
        lowp vec3 lightColor = (LdotN * Diffuse.rgb * baseColor.rgb) + SpecularColor.rgb * specular;
        lightColor *= DirectionalLightColor[i].rgb;
        color += lightColor;
    }
#endif
    
#if KANZI_SHADER_NUM_POINT_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_POINT_LIGHTS; ++i)
    {
        vec3 L = normalize(-vPointLightDirection[i]);
        vec3 H = normalize(-V + L);
        float LdotN = max(0.0, dot(L, N));
        float NdotH = max(0.0, dot(N, H));
        float specular = pow(NdotH, SpecularExponent);
        vec3  c = PointLightAttenuation[i];
        float d = length(vPointLightDirection[i]);
        float attenuation = 1.0 / (0.01 + c.x + c.y * d + c.z * d * d);
        vec3 lightColor = (LdotN * Diffuse.rgb * baseColor.rgb) + SpecularColor.rgb * specular;
        lightColor *= attenuation;
        lightColor *= PointLightColor[i].rgb;
        color += lightColor;
    }
#endif

#if KANZI_SHADER_NUM_SPOT_LIGHTS
    for (int i = 0; i < KANZI_SHADER_NUM_SPOT_LIGHTS; ++i)
    {
        vec3 L = normalize(-vSpotLightDirection[i]);
        float LdotN = dot(L, N);
        if (LdotN > 0.0)
        {
            float cosDirection = dot(L, -SpotLightDirection[i]);
            float cosOuter = SpotLightConeParameters[i].x;
            float t = cosDirection - cosOuter;
            if (t > 0.0)
            {
                vec3 H = normalize(-V + L);
                float NdotH = max(0.0, dot(N, H));
                float specular = pow(NdotH, SpecularExponent);
                vec3  c = SpotLightAttenuation[i];
                float d = length(vSpotLightDirection[i]);
                float denom = (0.01 + c.x + c.y * d + c.z * d * d) * SpotLightConeParameters[i].z;
                float attenuation = min(t / denom, 1.0);
                vec3 lightColor = (LdotN * Diffuse.rgb * baseColor.rgb) + SpecularColor.rgb * specular;
                lightColor *= attenuation;
                lightColor *= SpotLightColor[i].rgb;
                color += lightColor;
            }
        }
    }
#endif    

#if KANZI_SHADER_USE_REFLECTION_CUBE
    color += textureCube(TextureCube, R).rgb * CubemapColor.rgb;
#endif

    color += Emissive.rgb;
    gl_FragColor = vec4(color, baseColor.a) * BlendIntensity;
}
