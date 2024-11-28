precision mediump float;
    
attribute vec3 kzPosition;
attribute vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform vec2 TextureOffset;
uniform vec2 TextureTiling;
uniform vec2 MaskTextureOffset;
uniform vec2 MaskTextureTiling;

varying vec2 vTexCoord;
varying vec2 vTexCoordMask;

void main()
{
    vTexCoord     = kzTextureCoordinate0 * TextureTiling     + TextureOffset;
    vTexCoordMask = kzTextureCoordinate0 * MaskTextureTiling + MaskTextureOffset;
    
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}