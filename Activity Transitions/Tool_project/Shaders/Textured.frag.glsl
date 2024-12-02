uniform sampler2D Texture;
uniform lowp float BlendIntensity;
varying mediump vec2 vTexCoord;


void main()
{
    precision lowp float;

    vec4 color = texture2D(Texture, vTexCoord);
    gl_FragColor.rgba = color.rgba * BlendIntensity;
}
