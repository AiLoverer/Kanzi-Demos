precision mediump float;

// Generic uniform inputs from kanzi.
uniform sampler2D Texture;
uniform float BlendIntensity;

// Material specific uniform inputs.
uniform sampler2D colTextureOverLife;
uniform vec4 colColorBegin;
uniform vec4 colColorEnd;
uniform vec2 colGradientValues;
uniform float colMotionBlurStrength;
uniform float colUniformSpread;
uniform float colExposure;
uniform bool colLinearOutput;
uniform bool colUseLifeGradient;

// Data from vertex shader.
varying mediump vec4 vColor;
varying mediump vec2 vTexCoord;
varying mediump float vLife;
varying mediump float vFade;

const float gamma = 2.2;

mediump vec4 gammaToLin(highp vec4 x)
{
    return pow(x, vec4(vec3(gamma), 1.0));
}

mediump vec4 linToGamma(highp vec4 x)
{
    return pow(x, vec4(vec3(1.0/gamma), 1.0));
}

float gradientRadial(vec2 value)
{
    float d = min(length(vTexCoord-vec2(0.5)) * 2.0, 1.0);
    float x = 1.0 - smoothstep(value.x, value.y + value.x, d);
    return x;
}

void main()
{
    vec4 spriteTexel = texture2D(Texture, vTexCoord);
    vec4 lifeGradient = colUseLifeGradient ? texture2D(colTextureOverLife, vec2(1.0 - vLife, 0.5)) : vec4(1.0);
    vec4 lifeColor = mix(gammaToLin(colColorEnd), gammaToLin(colColorBegin), vLife);
    float shapeGradient = gradientRadial(colGradientValues);
    float exposureFactor = 1.0 / max(0.001, colExposure);
    
    if(!colLinearOutput)
        lifeColor = linToGamma(lifeColor);
    
    vec3 color = spriteTexel.rgb * lifeGradient.rgb * lifeColor.rgb * exposureFactor;
    float alpha = spriteTexel.a * lifeGradient.a * lifeColor.a * shapeGradient * BlendIntensity * vFade;
    gl_FragColor.rgb = color * alpha;
    gl_FragColor.a = alpha;
}