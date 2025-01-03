varying lowp vec4 vColor;

void main()
{
    precision lowp float;

    // For each fragment, Kanzi applies a constant interpolated assignment with the
    // same, lowp, precision. On most GPUs, this does not take longer than one cycle.
    gl_FragColor.rgba = vColor;
}