precision mediump float;

uniform samplerCube TextureCube;
uniform float BlendIntensity;
varying vec3 vViewDirection;

void main()
{
    gl_FragColor = textureCube(TextureCube, vViewDirection) * BlendIntensity;
}
