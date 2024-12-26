precision mediump float;

uniform sampler2D Texture;
uniform float BlendIntensity;

varying vec2 vTexCoord;

void main()
{
    vec4 color = texture2D(Texture, vTexCoord);
    gl_FragColor = color * BlendIntensity;
}
