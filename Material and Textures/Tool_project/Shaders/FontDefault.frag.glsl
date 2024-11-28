precision mediump float;

uniform sampler2D ContentTexture;

uniform lowp vec4 FontColor;
uniform float BlendIntensity;

varying vec2 vTexCoord;

void main()
{
    float a = texture2D(ContentTexture, vTexCoord).a;
    float alpha = FontColor.a * a * BlendIntensity;
    
    gl_FragColor = vec4(FontColor.rgb * alpha, alpha);
}
