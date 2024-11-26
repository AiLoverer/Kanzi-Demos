#define PI 3.141592
#define TWO_PI_INV 0.1591549430

precision mediump float;

uniform vec4 Color;
uniform float BlendIntensity;

uniform float Progress;
uniform float ProgressSmoothness;

uniform float RingThickness;
uniform float RingSmoothness;

varying vec2 vTexCoord;

float ringMask(vec2 pos, float r)
{
    float dist = length(pos);
    float s = max(RingSmoothness, 0.001);
    
    float mask  = 1.0-smoothstep(1.0-s, 1.0, dist);
          mask *=     smoothstep(  r-s,   r, dist);
          
    return mask;
}

float smoothRamp(float pos, float smoothness, float x)
{
    return smoothstep(0.0, smoothness, (x * (1.0 - smoothness) + smoothness) - pos);
}

void main(void)
{       
    vec2 uv = vTexCoord * 2.0 - 1.0;
    
    float angle = atan(-uv.x, -uv.y) * TWO_PI_INV + 0.5;
    
    float progressMask = 1.0-smoothRamp(Progress * 0.01, ProgressSmoothness, angle);
    float ringMask = ringMask(uv, 1.0-RingThickness);

    float a = Color.a * progressMask * ringMask * BlendIntensity;
    
    gl_FragColor.rgb = Color.rgb * a;
    gl_FragColor.a   = a;
}