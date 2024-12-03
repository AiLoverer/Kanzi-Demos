precision mediump float;

attribute vec3 kzPosition;
uniform highp mat4 kzWorldMatrix;
uniform highp vec4 kzViewPosition;
uniform highp mat4 kzProjectionCameraWorldMatrix;

varying vec3 vViewDirection;

void main()
{
    vec4 position4 = vec4(kzPosition, 1.0);
    gl_Position = kzProjectionCameraWorldMatrix * position4;
    vec4 positionWorld = kzWorldMatrix * position4;
    vViewDirection = positionWorld.xyz * kzViewPosition.w - kzViewPosition.xyz;
}