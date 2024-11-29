varying lowp vec4 vColor;
varying lowp vec3 vLight;
uniform lowp vec4 SurfaceMultiplier;

uniform samplerCube Reflection;
uniform samplerCube Irradiance;

uniform lowp float BlendIntensity;
uniform lowp float ReflectionCubeStrength;

varying mediump vec2 vTexCoord;
varying mediump vec3 vNormal;
varying mediump vec3 vViewDirection;

void main()
{
    precision lowp float;
    
    float Rough     = 1.0 - SurfaceMultiplier.r;
    float Cavity    = SurfaceMultiplier.g;
    float Metal     = SurfaceMultiplier.b;
    float AO        = SurfaceMultiplier.a;
    
    vec3 N = normalize(vNormal);
    vec3 V = normalize(vViewDirection);
    vec3 R = reflect(V,N);
    
    float Fresnel = 1.0-min(max(0.0,dot(N, V)),1.0);
    
    vec3 reflection = textureCube(Reflection,R).rgb * ReflectionCubeStrength * Cavity;
    vec3 irradiance = textureCube(Irradiance,R).rgb * ReflectionCubeStrength * AO;
    
    vec3 blurReflection = mix(reflection, irradiance, min((Rough*1.1 * pow(1.0-Fresnel, 0.31831)), 1.0));
    
    vec4 color = vec4(mix(vec3(0.03), vec3(1.0), 1.0-Metal), 1.0);

    vec3 mixReflection = mix(blurReflection * Fresnel, blurReflection, Metal) * vColor.rgb;
    
    gl_FragColor.rgba = color.rgba * (vColor*Cavity) + vec4(mixReflection,1.0) * BlendIntensity;
}
