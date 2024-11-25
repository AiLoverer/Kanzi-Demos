precision mediump float;

attribute vec3 kzPosition;
attribute vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform vec2 TextureOffset;
uniform vec2 TextureTiling;

varying vec2 vTexCoord;
varying vec2 vTexCoordRaw;

void main()
{
    vTexCoord = kzTextureCoordinate0 * TextureTiling + TextureOffset;
    vTexCoordRaw = kzTextureCoordinate0;
    
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}