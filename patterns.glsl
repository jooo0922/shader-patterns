#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution;
  coord.x *= u_resolution.x / u_resolution.y;

  // 화면의 좌표계를 3배로 늘려서 원을 더 작아보이게 만듦. -> 패턴화시킬 준비를 한 것!
  coord *= 3.;

  // fract() 또는 mod() 내장함수를 이용하면 확대된 좌표계에 패턴이 그려지게 됨
  // coord = mod(coord, 1.);
  coord = fract(coord);

  // 이번에는 각 픽셀들 좌표값을 이용해서 r, g 성분값을 지정함으로써, 정사각형 그라데이션을 그리고, 그것을 패턴화시킴.
  vec3 col = vec3(coord, 1.);

  gl_FragColor = vec4(col, 1.);
}

/*
  fract() / mod() 내장함수로 패턴 그리기


  fract() 는 인자로 넣어주는 float값의 소수 부분(fractional part)만 리턴해 줌.
  
  mod() 는 fract() 와 정확히 동일한 기능을 하는 내장함수는 아니지만,
  mod(나눠지는 값, 1.0(나눠주는 값)) 이렇게 사용하면 1로 나누면 나머지는 항상 0 ~ 1 사이의 값이 나오므로,
  사실상 fract() 내장함수와 동일한 기능을 한다고 보면 됨.

  근데, 어쨋든 fract(coord) 를 호출하기 전에는 원이 하나만 그려졌는데
  fract(coord)를 호출하고 나니까 원이 여러 개 그려지는 이유는 뭘까?

  예를 들어, 지금 우리가 화면의 좌표계를 3배로 늘렸지?
  그러면 맨 첫번째 원은 vec2(0.5, 0.5) 지점에 존재하니까, 
  아래의 step() 내장함수에 의해서 반지름 0.3의 원이 그려져야 하는 거잖아.

  근데, 두번째 원은 vec2(1.5, 0.5) 지점에 존재하기 때문에
  원래대로라면 원이 그려지면 안되는 게 맞음. 그냥 흰색으로 다 칠해져야 맞지.

  그런데, fract(coord)를 함으로 인해서,
  fract(vec2(1.5, 0.5)) 이렇게 해버리면 그 결과값이 결국 fract(vec2(0.5, 0.5))로 리턴되어버림.
  소수점 부분만 리턴해주니까!

  따라서, step() 함수 안으로 들어가는 coord값이 첫 번째 원에서와 동일하게
  vec2(0.5, 0.5) 로 들어가기 때문에, 이 영역에도 검정색 픽셀들이 칠해지게 되는 것임!


  따라서, 어떤 도형을 만든 다음, 
  그것을 패턴으로 만들고 싶다면, 두 가지 단계를 거쳐야 함.

  1. 화면의 좌표계를 n배로 확대함
  2. fract(coord) 또는 mod(coord, 1.0) 으로 
  각 픽셀들의 좌표값을 0 ~ 1 사이의 소수값으로 다시 리턴받은 뒤에 패턴을 그려주는 계산에 사용하도록 함. 
*/