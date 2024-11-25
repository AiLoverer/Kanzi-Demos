precision mediump float;

uniform sampler2D Texture;
uniform sampler2D MaskTexture;
uniform float BlendIntensity;
uniform float VisibleProportion;
uniform float KeepIntensity;

varying vec2 vTexCoord;
varying vec2 v_texCoord;
varying vec2 v_blurTexCoords[8];
varying float vWorldFade;

void main()
{
    float blend = (1.0 - clamp(vTexCoord.y / VisibleProportion,0.0,1.0)) * 0.7;
    
    vec4 color = vec4(0.0);
    color += texture2D(Texture, v_blurTexCoords[0])*0.028532;
    color += texture2D(Texture, v_blurTexCoords[1])*0.067234;
    color += texture2D(Texture, v_blurTexCoords[2])*0.124009;
    color += texture2D(Texture, v_blurTexCoords[3])*0.179044;
    color += texture2D(Texture, vTexCoord         )*0.202362;
    color += texture2D(Texture, v_blurTexCoords[4])*0.179044;
    color += texture2D(Texture, v_blurTexCoords[5])*0.124009;
    color += texture2D(Texture, v_blurTexCoords[6])*0.067234;
    color += texture2D(Texture, v_blurTexCoords[7])*0.028532;
    
    float a = blend * vWorldFade * BlendIntensity * color.a;
    
    gl_FragColor = vec4(color.rgb * a, a);
}
