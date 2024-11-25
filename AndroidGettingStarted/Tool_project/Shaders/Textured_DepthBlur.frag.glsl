precision mediump float;

uniform sampler2D Texture;
uniform float BlendIntensity;
uniform float Bias;

varying vec2 vTexCoord;
varying float vBias;
varying vec2 v_blurTexCoords[8];
varying float vWorldFade;

void main()
{
    vec4 color = vec4(0.0);
    
    color += texture2D(Texture, v_blurTexCoords[0], Bias+vBias)*0.028532;
    color += texture2D(Texture, v_blurTexCoords[1], Bias+vBias)*0.067234;
    color += texture2D(Texture, v_blurTexCoords[2], Bias+vBias)*0.124009;
    color += texture2D(Texture, v_blurTexCoords[3], Bias+vBias)*0.179044;
    color += texture2D(Texture, vTexCoord, Bias+vBias)*0.202362;
    color += texture2D(Texture, v_blurTexCoords[4], Bias+vBias)*0.179044;
    color += texture2D(Texture, v_blurTexCoords[5], Bias+vBias)*0.124009;
    color += texture2D(Texture, v_blurTexCoords[6], Bias+vBias)*0.067234;
    color += texture2D(Texture, v_blurTexCoords[7], Bias+vBias)*0.028532;
        
    float a = vWorldFade * BlendIntensity;
    
    gl_FragColor.rgb = color.rgb * a;
    gl_FragColor.a = color.a * a;
}