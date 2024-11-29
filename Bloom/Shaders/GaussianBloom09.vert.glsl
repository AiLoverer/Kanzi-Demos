#version 300 es
precision mediump float;

in vec3 kzPosition;
in vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;

out vec2 vTexCoord;

void main()
{
    vTexCoord = kzTextureCoordinate0;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}