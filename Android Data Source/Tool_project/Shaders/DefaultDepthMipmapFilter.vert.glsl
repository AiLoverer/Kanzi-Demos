#version 300 es

precision mediump float;

in vec3 kzPosition;
in vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp vec2 kzTextureSize0;
uniform mediump float CurrentMipmapLevel;

out highp vec2 vTexCoord;

void main()
{
    // Calculate a texture coordinate scale for source mipmap levels whose dimensions are odd to ensure sampling exactly
    // between texels for better filtering quality.
    highp vec2 sourceMipmapLevelSize = max(vec2(1.), floor(kzTextureSize0 / exp2(CurrentMipmapLevel - 1.)));
    // Scale is 1 for even dimensions, and slightly less than 1 for odd dimensions.
    highp vec2 textureCoordinateScale = 1. - mod(sourceMipmapLevelSize, 2.) / sourceMipmapLevelSize;
    // Scale input texture coodinates by the calculated scale.
    vTexCoord = kzTextureCoordinate0 * textureCoordinateScale;

    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition, 1.0);
}
