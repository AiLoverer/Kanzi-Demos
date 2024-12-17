precision mediump float;

attribute vec3 kzPosition;

uniform highp vec4 kzViewPosition;
uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzProjectionCameraWorldMatrix;

varying vec3 vViewDirection;

void main()
{
    vec4 position = vec4(kzPosition.xyz, 1.);
    vViewDirection = (kzWorldMatrix * position).xyz * kzViewPosition.w - kzViewPosition.xyz;
    gl_Position = kzProjectionCameraWorldMatrix * position;
}
