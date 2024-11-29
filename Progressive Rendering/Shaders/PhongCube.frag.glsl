uniform samplerCube TextureCube;

uniform lowp vec4 DirectionalLightColor[1];
uniform lowp vec4 PointLightColor[2];
uniform mediump vec3 PointLightAttenuation[2];

uniform lowp vec4 Ambient;
uniform lowp vec4 Diffuse;
uniform lowp vec4 SpecularColor;
uniform mediump float SpecularExponent;
uniform lowp vec4 Emissive;
uniform lowp vec4 CubemapColor;
uniform lowp float BlendIntensity;

varying mediump vec3 vNormal;
varying mediump vec3 vViewDirection;
varying mediump vec3 vDirectionalLightDirection;
varying mediump vec3 vPointLightDirection[2];
varying mediump vec2 vTexCoord;

void main()
{
    precision mediump float;

    vec3 L[3];
    vec3 H[3];
    float LdotN, NdotH;
    float specular;
    lowp vec3 lightColor;
    vec3 c;
    float d, attenuation;
    
    lowp vec3 color = vec3(0.0);
    vec3 N = normalize(vNormal);
    vec3 V = normalize(vViewDirection);    
    vec3 R = reflect(V, N);
    
    L[0] = vDirectionalLightDirection;
    H[0] = normalize(-V + L[0]);
    
    L[1] = normalize(-vPointLightDirection[0]);
    H[1] = normalize(-V + L[1]);
    
    L[2] = normalize(-vPointLightDirection[1]);
    H[2] = normalize(-V + L[2]);
        
    color += Ambient.rgb;
    
    // Apply directional light 0.
    {
        LdotN = max(0.0, dot(L[0], N));
        NdotH = max(0.0, dot(N, H[0]));
        specular = pow(NdotH, SpecularExponent);
        lightColor = (LdotN * Diffuse.rgb) + SpecularColor.rgb * specular;
        lightColor *= DirectionalLightColor[0].rgb;
        color += lightColor;
    }
    
    // Apply point light 0.
    {
        LdotN = max(0.0, dot(L[1], N));
        NdotH = max(0.0, dot(N, H[1]));
        specular = pow(NdotH, SpecularExponent);
        c = PointLightAttenuation[0];
        d = length(vPointLightDirection[0]);
        attenuation = 1.0 / (0.01 + c.x + c.y * d + c.z * d * d);
        lightColor = (LdotN * Diffuse.rgb) + SpecularColor.rgb * specular;
        lightColor *= attenuation;
        lightColor *= PointLightColor[0].rgb;
        color += lightColor;
    }

    // Apply point light 1.
    {
        LdotN = max(0.0, dot(L[2], N));
        NdotH = max(0.0, dot(N, H[2]));
        specular = pow(NdotH, SpecularExponent);
        c = PointLightAttenuation[1];
        d = length(vPointLightDirection[1]);
        attenuation = 1.0 / (0.01 + c.x + c.y * d + c.z * d * d);
        lightColor = (LdotN * Diffuse.rgb) + SpecularColor.rgb * specular;
        lightColor *= attenuation;
        lightColor *= PointLightColor[1].rgb;
        color += lightColor;
    }
    color += textureCube(TextureCube, R).rgb * CubemapColor.rgb;
    color += Emissive.rgb;
    gl_FragColor.rgb = color * BlendIntensity;
    gl_FragColor.a = BlendIntensity;
}