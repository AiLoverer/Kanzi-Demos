// This shader takes the size of an image in a tile
// atlas from the Layout Width and Layout Height
// properties of the node that you use to draw that image.

precision mediump float;

attribute vec2 kzTextureCoordinate0;
attribute vec3 kzPosition;

uniform mediump float Width;
uniform mediump float Height;
uniform highp mat4 kzProjectionCameraWorldMatrix;

// TileAtlasSize sets the size of a tile atlas image in pixels.
// X sets the width of the tile atlas.
// Y sets the height of the tile atlas.

// OffsetInTileAtlas sets the offset of an image in a tile atlas
// relative to the top left corner of the tile atlas.
// X sets the offset on the X axis.
// Y sets the offset on the Y axis.

uniform vec2 TileAtlasSize;
uniform vec2 OffsetInTileAtlas;

varying vec2 vTexCoord;

void main()
{
   // Scale the UVs based on the size of the image in a tile atlas and move them based on the given offset.
   vTexCoord.x = kzTextureCoordinate0.x * (Width / TileAtlasSize.x) + (OffsetInTileAtlas.x / TileAtlasSize.x);
   
   // Y Includes an extra calculation to ensure that the offset works for the top left corner of a tile atlas.
   vTexCoord.y = kzTextureCoordinate0.y * (Height / TileAtlasSize.y) + (((TileAtlasSize.y - OffsetInTileAtlas.y) - Height) / TileAtlasSize.y);
   
   gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}