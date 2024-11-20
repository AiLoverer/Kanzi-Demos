precision mediump float; 

uniform sampler2D Texture;
uniform sampler2D Texture2;
uniform float BlendIntensity;
uniform float offset;
uniform float smoothing;

varying vec2 vTexCoord;
varying vec2 vTexCoordRaw;

void main()
{    
    vec4 color1 = texture2D(Texture, vTexCoord);
    vec4 color2 = texture2D(Texture2, vTexCoord);

    float mask = smoothstep(vTexCoordRaw.x, vTexCoordRaw.x + smoothing, offset * (1.0 + smoothing));
    
    vec4 mixedColor = mix(color1, color2, mask);

    gl_FragColor = mixedColor * BlendIntensity;
}