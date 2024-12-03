precision mediump float;

uniform float BlendIntensity;
uniform sampler2D Texture;
uniform vec4 PrimaryColor;
uniform vec4 SecondaryColor;
uniform bool UseSecondaryColor;

varying vec2 vTexCoord;

void main()
{
    float colorIn = texture2D(Texture, vTexCoord).r;
    gl_FragColor = colorIn * mix(PrimaryColor, SecondaryColor, float(UseSecondaryColor));
}