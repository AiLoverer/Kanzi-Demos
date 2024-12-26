precision highp float;

// The following vertex attributes correspond to the inputs
// from the particle billboard renderer.

// kzPosition is the particle center position.
attribute vec3 kzPosition;
// kzTextureCoordinate0 contains particle quad vertex positions.
attribute vec2 kzTextureCoordinate0;
// kzColor0 xy components contain 2D rotation.
// kzColor0 z component contains scale factor.
// kzColor0 w component contains normalized particle life [0-1].
attribute vec4 kzColor0;
// kzNormal contains the particle motion vector
attribute vec3 kzNormal;

uniform highp mat4 kzWorldMatrix;
uniform highp mat4 kzProjectionMatrix;
uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform mediump vec4 kzViewport;
uniform mediump vec3 kzCameraPosition;

// Material specific uniform inputs.
uniform bool colMotionBlur;
uniform mediump float colMotionBlurStrength;
uniform mediump float colDofFocusDistance;
uniform mediump float colDofBlurAmount;
uniform mediump float colDofBlurMaxAmount;
uniform mediump float colDofBlurMaxNearAmount;
uniform mediump float colFadeDistance;
uniform mediump float colFadeOut;
uniform mediump float colFadeIn;

// Fragment shader outputs.
varying mediump vec4 vColor;
varying mediump vec2 vTexCoord;
varying mediump float vLife;
varying mediump float vFade;

void main()
{
    // Write texture coordinates for fragment shader.
    vTexCoord = kzTextureCoordinate0;
    // Write color for fragment shader.
    vColor = kzColor0;
    // Write particle life time for fragment shader.
    vLife = kzColor0.a;
    
    // Procedural quad vertex coordinates.
    const float BILLBOARD_SCALE = 0.2;
    highp vec2 coord = sign(kzTextureCoordinate0 - 0.5) * BILLBOARD_SCALE;
    // Aspect ratio.
    coord.y *= vColor.z;
    // Rotation and scaling.
    coord *= mat2(vColor.y, -vColor.x, vColor.x, vColor.y);
        
    // Screen (viewport) aspect ratio.
    float aspectRatio = kzViewport.w/kzViewport.z;  
    
    // Calculate 2D projection of the motion vector.
    vec4 startPos  = vec4(kzPosition.xyz, 1.0);
    vec4 motionPos = vec4(kzPosition.xyz + kzNormal, 1.0);
    vec4 projectedStart = kzProjectionCameraWorldMatrix * startPos;
    vec4 projectedMove  = kzProjectionCameraWorldMatrix * motionPos;
    vec2 ssMotionVec = (projectedStart / projectedStart.w - projectedMove / projectedMove.w).xy;
    ssMotionVec *= colMotionBlurStrength;
    ssMotionVec.x /=aspectRatio;
    
    // Write motion amount scalar for fragment shader and to be used by motion blur below.
    float motionAmt = colMotionBlurStrength * length(ssMotionVec) ;        
        
    // Depth of field.
    float dist = projectedStart.z;
    float near = max(0.0, -sign(colDofFocusDistance - dist));
    float minSize = mix(colDofBlurMaxNearAmount, colDofBlurMaxAmount, near) * 0.25;
    float focus = min(abs(colDofFocusDistance - dist) * colDofBlurAmount * 0.1, minSize);
    
    // Fade out based on proximity, between a cut off point and focal distance
    // to reduce slowdowns from large particles causing overdraw.
    float proximityFadeout = smoothstep(colDofFocusDistance * colFadeDistance,
                                        max(0.0, colDofFocusDistance*(0.25+0.75*colFadeDistance)),
                                        dist);
    
    // Rotate and scale the particle sprite in screen space according to the motion vector.
    vec2 motionVecN = normalize(ssMotionVec);
    mat2 rot = (colMotionBlur && length(ssMotionVec) > 0.00001) ? mat2(motionVecN.y, -motionVecN.x, motionVecN.x, motionVecN.y) : mat2(1, 0, 0, 1);
    mat2 scale = mat2(1.0 + focus/vColor.y, 0.0, 0.0, 1.0 + (float(colMotionBlur) * motionAmt + focus)/(vColor.y*vColor.z));
    mat2 motionRot = rot * scale;
    
    // Particle area, taking into account DOF and motion blur.
    float area = scale[0][0] * scale[1][1];
    
    // Combine fade and focus for fragment shader.
    vFade = (smoothstep(0.0, colFadeIn, 1.0-vLife)) * (1.0-smoothstep(1.0-colFadeOut, 1.0, 1.0-vLife)) * proximityFadeout / area;
    
    // Output vertex positions based on the billboard quad projection,
    // projected motion blur stretching and depth of field and skip if too close to camera.
    if(proximityFadeout > 0.1)
    {
        const float sq2 = sqrt(2.0);
        gl_Position = kzProjectionCameraWorldMatrix * startPos + sq2 *
                      vec4(mat2(aspectRatio, 0, 0, 1) * motionRot * coord, 0.0, 0.0) *
                      length((kzProjectionMatrix * vec4(2, 2, 1, 1)).xy);
    }
    else
    {
        gl_Position = vec4(0);
    }
}