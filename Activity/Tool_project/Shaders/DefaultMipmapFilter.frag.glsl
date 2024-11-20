#version 300 es

precision mediump float;

uniform sampler2D MipmapSourceTexture;

in highp vec2 vTexCoord;
out vec4 fragColor;

void main()
{
    // Renders a new mipmap level by taking a bilinear sample averaging 2x2 texel
    // quad from the previous mipmap level (LOD bias -1).
    fragColor = texture(MipmapSourceTexture, vTexCoord, -1.);
}
