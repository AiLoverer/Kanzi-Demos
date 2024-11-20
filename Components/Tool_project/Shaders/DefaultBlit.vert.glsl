precision mediump float;

attribute vec3 kzPosition;
attribute vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;

varying vec2 vTexCoord;

void main()
{
    vTexCoord = kzTextureCoordinate0;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition, 1.0);
}
