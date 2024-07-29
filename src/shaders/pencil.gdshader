shader_type canvas_item;

#include "include/fast_noise_lite.gdshaderinc"

global uniform float camera_zoom;
global uniform vec2 camera_offset;
global uniform float flicker_time;

void fragment() {
	vec4 c = COLOR;
	
	fnl_state state = fnlCreateState(8249);
	state.frequency = 350.;
	
	vec2 uv = SCREEN_UV / camera_zoom + camera_offset / vec2(3840, 2160) + camera_zoom;
	uv = uv / (SCREEN_PIXEL_SIZE / SCREEN_PIXEL_SIZE.x);
	
	float tz = mod(floor(TIME / flicker_time), 14285.24994);
	float nv = fnlGetNoise3D(state, uv.x, uv.y, tz);
	nv = nv * 0.5 + 0.5;
	nv = pow(smoothstep(0, 1, nv), 0.4);
	
	c.a *= nv;
	
	COLOR = c;
}