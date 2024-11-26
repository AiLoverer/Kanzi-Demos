#version 300 es

precision highp float;

in vec3 kzPosition;

uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzProjectionCameraWorldMatrix;

out highp vec3 vViewDirection;

void main()
{
    vec4 position = vec4(kzPosition, 1.);

    // Calculate view direction used to sample cube map from cube
    // vertex positions assuming that the view position is at
    // origin (0,0,0).
    vViewDirection = (kzWorldMatrix * position).xyz;

    gl_Position = kzProjectionCameraWorldMatrix * position;
}