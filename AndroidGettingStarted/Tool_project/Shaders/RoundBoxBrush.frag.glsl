precision mediump float;

uniform float ActualWidth;
uniform float ActualHeight;
uniform float RoundingRadius;
uniform float ButtonHighlight;
uniform vec4 Color;
uniform vec4 HighlightColor;
uniform vec4 ModulateColor;
uniform float BlendIntensity;

varying vec2 vTexCoord;

float roundedBox( vec2 pos, vec2 bounds, float radius )
{
    return length(max(abs(pos) - bounds + radius, 0.0)) - radius;
}

void main()
{
    vec2 pixelCoord = (vTexCoord * 2.0 - 1.0) * vec2(ActualWidth, ActualHeight);
    
    float radius = max(RoundingRadius * 2.0, 5.0);
    float distanceField = roundedBox(pixelCoord, vec2(ActualWidth, ActualHeight), radius);
    float smoothAlpha = 1.0-smoothstep(0.0, 2.0, distanceField);
    
    vec4 baseColor = mix(Color, HighlightColor, ButtonHighlight);
    
    float a = baseColor.a * ModulateColor.a * smoothAlpha * BlendIntensity;
    
    gl_FragColor.rgb = baseColor.rgb * ModulateColor.rgb * a;
    gl_FragColor.a   = a;
}