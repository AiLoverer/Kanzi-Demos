uniform sampler2D Texture0;
uniform sampler2D Texture1;
uniform sampler2D Texture2;
uniform sampler2D Texture3;

uniform lowp float Pass1Multiplier;
uniform lowp float Pass2Multiplier;
uniform lowp float Pass3Multiplier;
uniform lowp float Pass4Multiplier;

uniform lowp float Intensity;

varying mediump vec2 vTexCoord;

void main()
{
    precision lowp float;
    
    vec4 color = texture2D(Texture0, vTexCoord)*Pass1Multiplier;
    color += texture2D(Texture1, vTexCoord)*Pass2Multiplier;
    color += texture2D(Texture2, vTexCoord)*Pass3Multiplier;
    color += texture2D(Texture3, vTexCoord)*Pass4Multiplier;
    
    gl_FragColor.rgba = color;
}