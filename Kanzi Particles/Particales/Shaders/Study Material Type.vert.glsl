attribute vec3 kzPosition;
uniform highp mat4 kzProjectionCameraWorldMatrix;
uniform lowp float counter;

varying lowp vec4 vColor;

void main()
{
   precision mediump float;

   // Kanzi performs the trigonometric operations only for each vertex.
   // For example, for a quad, which consists of two triangles that each
   // have three vertices, that is six times.
   vColor = vec4(cos(counter), sin(counter), 1, 1);

   gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}