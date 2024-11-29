uniform sampler2D Texture0;
varying mediump vec2 vTexCoord;
uniform lowp float Threshold;

void main()
{
    precision lowp float;
    
    vec4 color = texture2D(Texture0, vTexCoord);
    
    float clipR = smoothstep(Threshold, 1.01, color.r);
    float clipG = smoothstep(Threshold, 1.01, color.g);
    float clipB = smoothstep(Threshold, 1.01, color.b);
    float clipA = smoothstep(Threshold, 1.01, color.a);
    vec4 clip = vec4(clipR, clipG, clipB, clipA);
    gl_FragColor.rgba = clip.rgba;
}
