shader_type canvas_item;

global uniform float camera_zoom;
global uniform vec2 camera_offset;
global uniform float flicker_time;

uniform sampler2D noise_texture : filter_linear, repeat_enable;


void fragment() {
	vec4 c = COLOR;
	
	vec2 uv = SCREEN_UV / camera_zoom + camera_offset / vec2(3840, 2160) + camera_zoom;
	uv = uv / (SCREEN_PIXEL_SIZE / SCREEN_PIXEL_SIZE.x);
	
	float tz = mod(floor(TIME / flicker_time), 14285.24994);
	float n = texture(noise_texture, uv + vec2(tz * 10.546)).r;
	n = pow(smoothstep(0, 1, n), 0.4);
	
	c.a *= n;
	
	COLOR = c;
}