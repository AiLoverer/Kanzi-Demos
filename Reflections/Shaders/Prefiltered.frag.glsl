#version 300 es
precision mediump float;

uniform samplerCube CubeRadiance;
uniform samplerCube CubeIrradiance;
uniform sampler2D DiffuseTexture;
uniform sampler2D Roughness;
uniform lowp float BlendIntensity;
uniform lowp vec4 Diffuse;
uniform lowp float Metalness;
uniform mediump float ior;
uniform lowp float RoughnessDirection;
uniform lowp float RoughnessStrength;
uniform lowp vec4 TextureCoordinates;

in mediump vec3 vNormal;
in mediump vec3 vViewDirection;
in mediump vec2 vTexCoord;

out mediump vec4 outColor;

vec3 Fresnel_Schlick(float cosT, vec3 F0)
{
  return F0 + (1.0-F0) * pow( 1.0 - cosT, 5.0);
}

void main()
{
    
    float roughnessFloat = texture(Roughness, (vTexCoord * TextureCoordinates.xy) + TextureCoordinates.zw).r;
    roughnessFloat = RoughnessStrength * mix(roughnessFloat, 1.0-roughnessFloat, RoughnessDirection);
    
    vec4 diffuseTex = pow(texture(DiffuseTexture, (vTexCoord * TextureCoordinates.xy) + TextureCoordinates.zw), vec4(0.6,0.6,0.6,1.0));
        
    vec3 N = normalize(vNormal);
    
    vec3 F0 = vec3(abs ((1.0 - ior) / (1.0 + ior)));
    F0 = F0 * F0;
    F0 = mix(F0, Diffuse.rgb * diffuseTex.rgb, Metalness);
    vec3 Fresnel = Fresnel_Schlick(min(max(dot(N,-vViewDirection),0.1),1.0), F0);
    
    vec3 R = reflect(normalize(vViewDirection), N);
    
    lowp vec3 irradianceColor = texture(CubeIrradiance, N).rgb * mix(1.0, 0.02, Metalness) * Diffuse.rgb * diffuseTex.rgb;
    lowp vec3 radianceColor = textureLod(CubeRadiance, R, min(pow(roughnessFloat, 0.6) * 9.0, 7.0)).rgb * Fresnel;

    
    lowp vec3 color = irradianceColor + radianceColor;

    outColor.rgb = color * BlendIntensity;
    outColor.a = BlendIntensity * diffuseTex.a;
    //outColor.rgb = vec3(radianceColor);
} 