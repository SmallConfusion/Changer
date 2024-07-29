shader_type canvas_item;

#include "include/fast_noise_lite.gdshaderinc"

global uniform float camera_zoom;
global uniform vec2 camera_offset;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;


float blackened(vec2 uv) {
	fnl_state state = fnlCreateState(42844);
	state.frequency = 75.;
	
	float noise = fnlGetNoise3D(state, uv.x, uv.y, TIME * 0.004);
	noise = noise * .5 + 0.5;

	noise = clamp(smoothstep(0, 1, noise * 0.42 - uv.y * 60. + 1.), 0, 1);

	return noise;
}

float fire(vec2 uv) {
	fnl_state state_sparks = fnlCreateState(32832);
	state_sparks.frequency = 2000.;

	fnl_state state_larger = fnlCreateState(84239);
	state_larger.frequency = 50.;

	float sparks = fnlGetNoise3D(state_sparks, uv.x, uv.y, TIME * 0.0005);
	float larger = fnlGetNoise3D(state_larger, uv.x, uv.y, TIME * 0.005);

	larger = smoothstep(0, 0.5, -larger * 0.2 + uv.y * 20. - .3);
	sparks = step(sparks, -0.8);

	sparks *= step(0.01, larger);

	return clamp(sparks + larger * 0.9, 0, 1);
}

void fragment() {
	vec4 c = texture(screen_texture, SCREEN_UV);
	
	vec2 uv = UV;
	
	float black = blackened(uv);
	
	c.rgb *= clamp(black * 1.1, 0.2, 1);

	c.r = mix(c.r, 1., fire(uv));
	
	COLOR = c;
}
