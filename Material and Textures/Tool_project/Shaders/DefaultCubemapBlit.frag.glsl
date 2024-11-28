precision mediump float;

uniform samplerCube TextureCubemap;
uniform float BlendIntensity;

varying vec3 vViewDirection;

void main()
{
    gl_FragColor = textureCube(TextureCubemap, vViewDirection) * BlendIntensity;
}
