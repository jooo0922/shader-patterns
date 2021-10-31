#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution;
  coord.x *= u_resolution.x / u_resolution.y;

  // 반지름이 0.3을 step() 내장함수로 그린 것
  // 즉, 각 픽셀들 좌표 ~ vec2(.5), 즉 원점 사이의 거리값을 잰 뒤, 0.3보다 크면 1, 작으면 0을 리턴해서 vec3로 만듦.
  // 그니까 원점에서 0.3 반경 내에 있으면 black, 바깥에 있으면 white가 칠해지겠지
  // 이제 이 원을 패턴화시켜줄 것임.
  vec3 col = vec3(step(.3, distance(coord, vec2(.5))));

  gl_FragColor = vec4(col, 1.);
}