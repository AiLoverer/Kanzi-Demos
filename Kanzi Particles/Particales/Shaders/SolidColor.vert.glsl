attribute vec3 kzPosition;
uniform highp mat4 kzProjectionCameraWorldMatrix;
void main()
{
    precision mediump float;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}