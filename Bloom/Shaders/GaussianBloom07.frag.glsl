#version 300 es
precision mediump float;

in vec2 vTexCoord;

uniform sampler2D Texture0;
uniform vec2 kzTextureSize0;
uniform lowp vec2 BlurDirection;
uniform float BlurRadius;
uniform float BlendIntensity;
uniform float Intensity;

out vec4 outColor;

const float GAUSSIAN_KERNEL[7] = float[7]
(
    0.028116,    0.102883,    0.223922,    0.290156,    0.223922,    0.102883,    0.028116
);

vec4 gaussianBlur(mediump vec2 coord, lowp vec2 dir)
{
    vec2 texel = 1.0 / kzTextureSize0;
    vec4 sum = vec4(0.0);
    vec2 tc = coord;
    float blur = BlurRadius;
    float hstep = dir.x * texel.x * blur;
    float vstep = dir.y * texel.y * blur;
    
    for(int i = 0; i < int(GAUSSIAN_KERNEL.length()); i++)
    {
        float pixelOffset = (float(i) - floor(float(GAUSSIAN_KERNEL.length()) * 0.5));
        sum += texture(Texture0, vec2(tc.x + pixelOffset * hstep, tc.y + pixelOffset * vstep)) * GAUSSIAN_KERNEL[i];
    }
    
    return sum * Intensity;
    
}

void main()
{
    vec4 retColor = gaussianBlur(vTexCoord, BlurDirection);
    
    outColor = retColor;
}