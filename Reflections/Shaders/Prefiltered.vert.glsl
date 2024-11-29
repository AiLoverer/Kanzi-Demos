#version 300 es
in vec3 kzPosition;
in vec3 kzNormal;
in vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzNormalMatrix;
uniform highp vec3 kzCameraPosition;

out mediump vec3 vNormal;
out mediump vec3 vViewDirection;
out mediump vec2 vTexCoord;

void main()
{
    precision mediump float;
    
    vec4 positionWorld = kzWorldMatrix * vec4(kzPosition.xyz, 1.0);
    vec3 V = normalize(positionWorld.xyz - kzCameraPosition);
    vec4 Norm = kzNormalMatrix * vec4(kzNormal, 1.0);
    vec3 N = normalize(Norm.xyz);
    
    vNormal = N;
    vViewDirection = V;
    vTexCoord = kzTextureCoordinate0;
    
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}