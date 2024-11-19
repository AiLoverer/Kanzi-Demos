precision mediump float;

attribute vec3 kzPosition;
attribute vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzWorldMatrix;
uniform vec2 TextureTiling;
uniform vec2 TextureOffset;
uniform float DepthOffset;
uniform float DepthScale;
uniform float BlurDirectionAngle;
uniform float BlurOffset;
uniform vec4 WorldFadeRange;

varying vec2 vTexCoord;
varying float vBias;
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
    
    float angleValue = cos(radians(BlurDirectionAngle));
    
    vTexCoord = kzTextureCoordinate0*TextureTiling+TextureOffset;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
    vBias = abs((gl_Position.z+DepthOffset)/DepthScale);
    
    v_blurTexCoords[0] = vTexCoord + vec2(-BlurOffset*4.0*angleValue, -BlurOffset*4.0*(1.0-angleValue))*vBias;
    v_blurTexCoords[1] = vTexCoord + vec2(-BlurOffset*3.0*angleValue, -BlurOffset*3.0*(1.0-angleValue))*vBias;
    v_blurTexCoords[2] = vTexCoord + vec2(-BlurOffset*2.0*angleValue, -BlurOffset*2.0*(1.0-angleValue))*vBias;
    v_blurTexCoords[3] = vTexCoord + vec2(-BlurOffset*angleValue, -BlurOffset*(1.0-angleValue))*vBias;
    v_blurTexCoords[4] = vTexCoord + vec2( BlurOffset*angleValue, BlurOffset*(1.0-angleValue))*vBias;
    v_blurTexCoords[5] = vTexCoord + vec2( BlurOffset*2.0*angleValue, BlurOffset*2.0*(1.0-angleValue))*vBias;
    v_blurTexCoords[6] = vTexCoord + vec2( BlurOffset*3.0*angleValue, BlurOffset*3.0*(1.0-angleValue))*vBias;
    v_blurTexCoords[7] = vTexCoord + vec2( BlurOffset*4.0*angleValue, BlurOffset*4.0*(1.0-angleValue))*vBias;
}