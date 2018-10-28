uniform sampler2D inTex;
//uniform sampler2D texture;
uniform sampler2D outTex;
uniform vec2 texOffset;
uniform float fadeFactor;

varying vec2 vertTexCoord;

void main() {
  vec4 inCol = texture2D(inTex, vertTexCoord.st);
  vec4 outCol = texture2D(outTex, vertTexCoord.st);

  gl_FragColor = mix(inCol, outCol, fadeFactor);
  //gl_FragColor = vec4( vertTexCoord.st, 0.0, 1.0);
}
