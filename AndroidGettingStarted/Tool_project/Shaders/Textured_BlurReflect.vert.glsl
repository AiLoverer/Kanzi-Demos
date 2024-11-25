precision mediump float;

attribute vec3 kzPosition;
attribute vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzWorldMatrix;
uniform float BlurOffset;
uniform vec4 WorldFadeRange;

varying vec2 vTexCoord;
varying vec2 v_texCoord;
varying vec2 v_blurTexCoords[8];
varying float vWorldFade;

float remap(float x, float from1, float to1, float from2, float to2)
{
    return clamp((x - from1) / (to1 - from1) * (to2 - from2) + from2, min(from2, to2), max(from2, to2));
}

void main()
{
    vec3 worldPos = vec4(kzWorldMatrix * vec4(kzPosition.xyz, 1.0)).xyz;

    vWorldFade = 1.0;
    //Near fade
    vWorldFade *= 1.0-remap(worldPos.z, WorldFadeRange.x, WorldFadeRange.y, 0.0, 1.0);
    //Far fade
    vWorldFade *= 1.0-remap(-worldPos.z, WorldFadeRange.z, WorldFadeRange.w, 0.0, 1.0);
    
    vTexCoord = kzTextureCoordinate0;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
    v_blurTexCoords[0] = vTexCoord + vec2(-BlurOffset*4.0, 0.0);
    v_blurTexCoords[1] = vTexCoord + vec2(-BlurOffset*3.0, 0.0);
    v_blurTexCoords[2] = vTexCoord + vec2(-BlurOffset*2.0, 0.0);
    v_blurTexCoords[3] = vTexCoord + vec2(-BlurOffset, 0.0);
    v_blurTexCoords[4] = vTexCoord + vec2( BlurOffset, 0.0);
    v_blurTexCoords[5] = vTexCoord + vec2( BlurOffset*2.0, 0.0);
    v_blurTexCoords[6] = vTexCoord + vec2( BlurOffset*3.0, 0.0);
    v_blurTexCoords[7] = vTexCoord + vec2( BlurOffset*4.0, 0.0);
}