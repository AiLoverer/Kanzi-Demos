#version 300 es

precision mediump float;

uniform sampler2D MipmapSourceTexture;

in highp vec2 vTexCoord;

void main()
{
    gl_FragDepth = texture(MipmapSourceTexture, vTexCoord, -1.).r;
}
