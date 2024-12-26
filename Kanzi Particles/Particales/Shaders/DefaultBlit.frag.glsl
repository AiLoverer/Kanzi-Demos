precision mediump float;

uniform sampler2D Texture0;
uniform float BlendIntensity;

varying vec2 vTexCoord;

void main()
{
    gl_FragColor = texture2D(Texture0, vTexCoord) * BlendIntensity;
}
