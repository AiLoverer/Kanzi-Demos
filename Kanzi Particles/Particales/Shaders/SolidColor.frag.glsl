uniform mediump float BlendIntensity;
uniform lowp vec4 Color;

void main()
{
    precision mediump float;
    gl_FragColor = vec4(Color)*BlendIntensity;
}