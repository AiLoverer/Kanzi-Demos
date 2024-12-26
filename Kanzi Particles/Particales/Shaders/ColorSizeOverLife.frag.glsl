precision mediump float;

uniform sampler2D Texture;
uniform sampler2D TextureOverLife;
uniform vec4 start_color;
uniform vec4 end_color;
uniform vec2 GradientValues;
uniform float BlendIntensity;
uniform float uMotionBlurStrength;
uniform float uUniformSpread;
uniform bool LinearOutput;
uniform mediump float Exposure;

varying mediump vec2 vTexCoord;
varying mediump float life;
varying mediump float motionAmt;
varying mediump float vFocus;

mediump vec4 gammaToLin(highp vec4 x)
{
    return pow(x,vec4(vec3(2.22), 1.0));
}

mediump vec4 linToGamma(highp vec4 x)
{
    return pow(x,vec4(vec3(0.45454), 1.0));
}

float gradientRadial(vec2 value)
{
    float d = min(length(vTexCoord-vec2(0.5)) * 2.0, 1.0);
    float x = 1.0-smoothstep(value.x, value.y, d);
    return x;
}

void main()
{
    vec4 pix = texture2D(Texture, vTexCoord)*1.5;
    float opacity = length(pix.rgb)*pix.a*mix(start_color.a, end_color.a, life);  // +++++++++++++++
    float motionSpread = mix(1.0, 1.0+pow(motionAmt, 0.5), uUniformSpread);  // ++++++++++++
    vec4 texLife = texture2D(TextureOverLife, vec2(1.0-life, 0.5));
    float gradient = gradientRadial(GradientValues);
    
    vec4 color = mix( gammaToLin(end_color), gammaToLin(start_color), life) / vFocus;
 
    
    if(!LinearOutput)
    {
        color = linToGamma(color);
    }
    
    float e = 1.0/Exposure;
    
    vec3 c = pix.rgb * texLife.rgb * color.rgb * e;
    float a = pix.a * texLife.a * gradient * BlendIntensity * e;

    gl_FragColor.rgb = c * a;
    gl_FragColor.a = a;
}