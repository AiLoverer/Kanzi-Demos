precision mediump float;

uniform float ActualWidth;
uniform float ActualHeight;
uniform float BorderThickness;
uniform float RoundingRadius;
uniform vec4 Color;
uniform vec4 ModulateColor;
uniform float BlendIntensity;

varying vec2 vTexCoord;

float roundedBox( vec2 pos, vec2 bounds, float radius )
{
    return length(max(abs(pos) - bounds + radius, 0.0)) - radius;;
}

float box( vec2 pos, vec2 bounds )
{
    vec2 d = abs(pos) - bounds;
    return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}

float getDistance( vec2 pos, vec2 bounds, float radius )
{
    float distanceBox = box(pos, bounds);
    float distanceBoxRound = roundedBox(pos, bounds, radius);
    //Swtich to a box distance field when radius is very small
    return ((radius <= 10.0) ? distanceBox : distanceBoxRound);
}

void main()
{
    vec2 pixelCoord = (vTexCoord * 2.0 - 1.0) * vec2(ActualWidth, ActualHeight);
    
    float radius    = RoundingRadius * 2.0;
    float thickness = min(BorderThickness * 2.0, ((radius <= 10.0) ? 1000.0 : radius-2.0));
    vec2  bounds    = vec2(ActualWidth, ActualHeight);
    
    float distanceField = getDistance(pixelCoord, bounds, radius);
    
    float smoothAlpha  = 1.0-smoothstep(0.0, 3.0, distanceField);
          smoothAlpha *= 1.0-smoothstep(0.0, -2.0, distanceField + thickness);
    
    float a = Color.a * ModulateColor.a * smoothAlpha * BlendIntensity;
    
    gl_FragColor.rgb = Color.rgb * ModulateColor.rgb * a;
    gl_FragColor.a   = a;
}