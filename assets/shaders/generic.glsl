@header package main
@header import sg "../vendor/sokol/gfx"
// @header import m "../library/util"
// @ctype mat4 m.Mat4

@vs vs_main
// layout(binding=0) uniform vs_params {
//   mat4 mvp;
// };

in vec3 in_pos;
in vec4 in_col;
in vec2 in_uv;

out vec4 col;
out vec2 uv;

void main() {
  gl_Position = vec4(in_pos, 1.0);
  col = in_col;
  uv = in_uv;
}
@end

@fs fs_main
layout(binding=0) uniform texture2D sprite_texture;
layout(binding=0) uniform sampler sprite_sampler;

in vec4 col;
in vec2 uv;

out vec4 frag_color;

void main() {
  frag_color = texture(sampler2D(sprite_texture, sprite_sampler), uv) * col;
}
@end

@program generic vs_main fs_main
