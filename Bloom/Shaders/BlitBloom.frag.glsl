uniform sampler2D Texture0;
uniform lowp vec4 PostProcessingColorMultiply;

varying mediump vec2 vTexCoord;

void main()
{
    precision lowp float;
    
    vec4 color = texture2D(Texture0, vTexCoord);
    color *= PostProcessingColorMultiply;
    gl_FragColor = color;
}