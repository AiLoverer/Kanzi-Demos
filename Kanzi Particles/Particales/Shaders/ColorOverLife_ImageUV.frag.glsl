precision mediump float;

uniform sampler2D sourceTex;
uniform sampler2D Texture;
uniform sampler2D TextureOverLife;
uniform vec4 start_color;
uniform vec4 end_color;
uniform vec4 ColorFade;
uniform vec2 GradientValues;
uniform float BlendIntensity;
uniform float uMotionBlurStrength;
uniform float uUniformSpread;
uniform bool LinearOutput;
uniform mediump float Exposure;
uniform lowp float SampleSize;
uniform lowp float FadeToLuminance;

uniform mediump float kzTextureWidth2;
uniform mediump float kzTextureHeight2;

varying mediump vec2 vSourceCoord;
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

float luminance(vec3 rgb)
{
    // Algorithm from Chapter 10 of Graphics Shaders.
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    return dot(rgb, W);
}

void main()
{
    vec4 pix = texture2D(Texture, vTexCoord);
    vec4 texLife = texture2D(TextureOverLife, vec2(1.0-life, 0.5));
    
    //Image mapping
    vec2 po = (vec2(1.0)/vec2(kzTextureWidth2, kzTextureHeight2)) * SampleSize;
    vec4 imgColor = texture2D(sourceTex, (vSourceCoord + (vTexCoord * 2.0 -1.0) * po), 0.0);
    
    float gradient = gradientRadial(GradientValues);
    
    vec4 color = mix( gammaToLin(end_color), gammaToLin(start_color), life);
    
    if(!LinearOutput)
    {
        color = linToGamma(color);
    }
    
    float e = 1.0/Exposure;
    
    vec3 c = imgColor.rgb * pix.rgb * texLife.rgb * color.rgb * e;
    float a = imgColor.a * pix.a * texLife.a * gradient * BlendIntensity * e;
    
    
    c = mix(c, ColorFade.rgb * luminance(c), FadeToLuminance);
    
    gl_FragColor.rgb = c * a;
    gl_FragColor.a = a;
    
    //gl_FragColor.rgb = vec3(a);

}