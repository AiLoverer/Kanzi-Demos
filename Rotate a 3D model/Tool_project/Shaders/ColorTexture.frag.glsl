precision mediump float;

uniform sampler2D Texture;
uniform float BlendIntensity;
uniform lowp vec4 Ambient;

varying vec2 vTexCoord;

void main()
{
    vec4 color = texture2D(Texture, vTexCoord);
    
    float alpha = Ambient.a * BlendIntensity;
    
    gl_FragColor.rgb = color.rgb * Ambient.rgb * alpha;
    gl_FragColor.a   = color.a * alpha;
}
