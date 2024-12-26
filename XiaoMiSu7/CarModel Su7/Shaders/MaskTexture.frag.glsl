precision mediump float;

uniform sampler2D Texture;
uniform sampler2D MaskTexture;
uniform float BlendIntensity;
uniform vec2 MaskTextureOffset;
uniform vec2 MaskTextureTiling;

varying vec2 vTexCoord;
varying vec2 vTexCoordMask;

void main()
{
    vec4 color = texture2D(Texture, vTexCoord);
    float mask = texture2D(MaskTexture, vTexCoordMask).r;
    
    gl_FragColor = color * BlendIntensity * mask;
}
