attribute vec3 kzPosition;
attribute vec3 kzNormal;
attribute vec3 kzTangent;
attribute vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzNormalMatrix;
uniform highp vec3 kzCameraPosition;
uniform mediump vec3 PointLightPosition[2];
uniform lowp vec4 PointLightColor[2];
uniform mediump vec3 PointLightAttenuation[2];
uniform lowp vec4 DirectionalLightColor[1];
uniform mediump vec3 DirectionalLightDirection[1];
uniform lowp float BlendIntensity;
uniform lowp vec4 Emissive;

uniform lowp vec4 Ambient;
uniform lowp vec4 Diffuse;
uniform lowp vec4 SpecularColor;
uniform mediump float SpecularPower;

varying lowp vec4 vColor;
varying lowp vec3 vLight;
varying lowp vec3 vSpec;
varying mediump vec3 vNormal;
varying mediump vec3 vTangent;
varying mediump vec3 vBinormal;
varying mediump vec2 vTexCoord;
varying mediump vec3 vViewDirection;
varying mediump vec3 vWorldPos;

void main()
{
    precision mediump float;
    
    vTexCoord = kzTextureCoordinate0;
    vWorldPos = (kzWorldMatrix * vec4(kzPosition.xyz, 1.0)).xyz;
    vViewDirection = (kzCameraPosition-vWorldPos.xyz);
     
    vec3 pointLightDirection[2];
    vec4 positionWorld = kzWorldMatrix * vec4(kzPosition.xyz, 1.0);
    vec3 V = normalize(positionWorld.xyz - kzCameraPosition);
    vec3 N = normalize((kzNormalMatrix * vec4(kzNormal.xyz, 1.0)).xyz);
    vNormal = N;
    vTangent = normalize((kzNormalMatrix * vec4(kzTangent.xyz, 1.0)).xyz);
    vBinormal = cross(vNormal, vTangent);
    
    pointLightDirection[0] = positionWorld.xyz - PointLightPosition[0];
    pointLightDirection[1] = positionWorld.xyz - PointLightPosition[1];
    
    vec3 L[3];
    vec3 H[3];
    float LdotN, NdotH;
    float specular;
    vec3 c;
    float d, attenuation;
    
    lowp vec3 vAmbDif = vec3(0.0);
    lowp vec3 vSpec = vec3(0.0);
    vLight = vec3(0.0);
    
    L[0] = vec3(1.0, 0.0, 0.0);
    if(length(DirectionalLightDirection[0]) > 0.01)
    {
        L[0] = normalize(-DirectionalLightDirection[0]);
    }
    H[0] = normalize(-V + L[0]);
    
    L[1] = normalize(-pointLightDirection[0]);
    H[1] = normalize(-V + L[1]);
    
    L[2] = normalize(-pointLightDirection[1]);
    H[2] = normalize(-V + L[2]);

    vAmbDif += Ambient.rgb;
  
    // Apply directional light 0.
    {
        LdotN = max(0.0, dot(L[0], N));
        NdotH = max(0.0, dot(N, H[0]));
        specular = pow(NdotH, SpecularPower);
        vAmbDif += (LdotN * Diffuse.rgb) * DirectionalLightColor[0].rgb;
        vSpec += SpecularColor.rgb * specular * DirectionalLightColor[0].rgb;
        vLight += LdotN * DirectionalLightColor[0].rgb;
    }
    
    // Apply point light 0.
    {
        LdotN = max(0.0, dot(L[1], N));
        NdotH = max(0.0, dot(N, H[1]));
        specular = pow(NdotH, SpecularPower);
        c = PointLightAttenuation[0];
        d = length(pointLightDirection[0]);
        attenuation = 1.0 / max(0.001, (c.x + c.y * d + c.z * d * d));
        vAmbDif += (LdotN * Diffuse.rgb) * attenuation * PointLightColor[0].rgb;
        vSpec +=  SpecularColor.rgb * specular * attenuation * PointLightColor[0].rgb;
        vLight += LdotN * PointLightColor[0].rgb;
    }

    // Apply point light 1.
    {
        LdotN = max(0.0, dot(L[2], N));
        NdotH = max(0.0, dot(N, H[2]));
        specular = (pow(NdotH, SpecularPower));
        c = PointLightAttenuation[1];
        d = length(pointLightDirection[1]);
        attenuation = 1.0 / max(0.001, (c.x + c.y * d + c.z * d * d));
        vAmbDif += (LdotN * Diffuse.rgb) * attenuation * PointLightColor[1].rgb;
        vSpec +=  SpecularColor.rgb * specular * attenuation * PointLightColor[1].rgb;
        vLight += LdotN * PointLightColor[1].rgb;
    }
    
    vColor.rgb = (vAmbDif.rgb + vSpec.rgb + Emissive.rgb) * BlendIntensity;
    vColor.a = BlendIntensity;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}