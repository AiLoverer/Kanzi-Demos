//kzPosition is the Center position
attribute vec3 kzPosition;
attribute vec2 kzTextureCoordinate0;
attribute vec4 kzColor0;

attribute vec3 kzNormal; // contains particle motion vector

uniform highp mat4 kzWorldMatrix;
uniform mediump vec3 kzCameraPosition;
uniform bool facingCamera;
uniform bool motionBlur;
uniform vec4 kzViewport;
uniform float uMotionBlurStrength;

uniform mediump float DofFocusDistance;
uniform mediump float DofBlurAmount;
uniform mediump float DofBlurMaxAmount;
uniform mediump float DofBlurMaxNearAmount;

varying lowp vec2 texCoord;
varying mediump vec4 vColor;

uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform highp mat4 kzProjectionMatrix;
varying mediump vec2 vTexCoord;
varying mediump float life;
varying mediump float motionAmt;
varying mediump float vFocus;

void main()
{
    precision highp float;
    vTexCoord = kzTextureCoordinate0;
    life = kzColor0.a;
    
    texCoord = kzTextureCoordinate0;
    vColor = kzColor0;
    
    vec2 coord = sign(kzTextureCoordinate0-0.5) * 0.2;
    
   
        // aspect ratio
        coord.y *= vColor.z;
        // rotation and scaling
        coord *= mat2(vColor.y, -vColor.x, vColor.x, vColor.y);
        
        // screen aspect ratio
        float aspectRatio = kzViewport.w/kzViewport.z; 
        coord.x *= aspectRatio;
        
        //coord *= (1.0-0.95*pow(life, 9.0))*3.0;
        coord /= 0.2+1.8*smoothstep(0.0, 1.0, pow(1.0-0.5*exp(1.0-life),0.9));
        coord /= 6.0;
        
        const float PROJECTION_COMP = 1000.0;
        
        
        
        vec4 startPos  = vec4(kzPosition.xyz, 1.0);
        vec4 motionPos = vec4(kzPosition.xyz + kzNormal/PROJECTION_COMP, 1.0);
        
        // calculate 2D projection of the motion vector
        vec4 projectedStart = kzProjectionCameraWorldMatrix * startPos;
        vec4 projectedMove  = kzProjectionCameraWorldMatrix * motionPos;
        vec2 ssMotionVec = (projectedStart / projectedStart.w - projectedMove / projectedMove.w).xy;
        ssMotionVec *= PROJECTION_COMP * (1.0 + uMotionBlurStrength);
        motionAmt = uMotionBlurStrength * 24.0 * distance(startPos.xyz, motionPos.xyz);        
        
        //DOF
        float dist = projectedStart.z;
        float near = max(-sign(DofFocusDistance - dist), 0.0);
        float minSize = mix(DofBlurMaxNearAmount, DofBlurMaxAmount, near);
        mediump float focus = min(abs(DofFocusDistance - dist) * DofBlurAmount * 0.1, minSize * 5.0);
        vFocus = focus;
        
        // rotate and scale the particle sprite in screen space
        // according to the motion vector
        vec2 motionVecN = normalize(ssMotionVec);
        mat2 rot = (motionBlur && length(ssMotionVec) > 0.001) ? mat2(motionVecN.y, -motionVecN.x, motionVecN.x, motionVecN.y) : mat2(1.0, 0.0, 0.0, 1.0);
        mat2 scale = mat2(1.0 + focus, 0.0, 0.0, 1.0 + (motionBlur ? motionAmt : 0.0) + focus);
        mat2 motionRot = rot * scale;
        vFocus = scale[0][0] * scale[1][1];
        gl_Position = kzProjectionCameraWorldMatrix * startPos + sqrt(2.0) * vec4(motionRot * coord, 0.0, 0.0) * length((kzProjectionMatrix * vec4(2.0, 2.0, 1.0, 1.0)).xy);
        
    
    
}