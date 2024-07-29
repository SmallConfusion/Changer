shader_type canvas_item;

global uniform float camera_zoom;
global uniform vec2 camera_offset;

uniform sampler2D noise_texture : filter_linear, repeat_enable;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;


float blackened(vec2 uv) {
	float noise = texture(noise_texture, uv * 5. + vec2(0.02, 0.03) * TIME).r * 2.;
	noise -= texture(noise_texture, uv * 5. + vec2(-0.01, 0.01) * TIME).r;
	noise = clamp(smoothstep(0, 1, noise * 0.42 - uv.y * 90. + 1.), 0, 1);

	return noise;
}

float fire(vec2 uv) {
	float sparks = texture(noise_texture, uv * vec2(25, 25)).r;
	float larger = texture(noise_texture, uv * vec2(2, 2) + vec2(0.01, 0.01) * TIME).r;

	larger = smoothstep(0, 0.5, -larger * 0.2 + uv.y * 20. - .3);
	sparks = step(0.8, sparks);

	sparks *= step(0.01, larger);
	
	sparks *= texture(noise_texture, uv * 10. + vec2(0.2, 0.2) * TIME).r;
	sparks *= step(texture(noise_texture, uv + vec2(0.02, 0.02) * TIME).r, 0.5);

	return clamp(sparks + larger * 0.9, 0, 1);
}

void fragment() {
	vec4 c = texture(screen_texture, SCREEN_UV);
	
	vec2 uv = UV;
	
	float black = blackened(uv + vec2(0, -0.01));
	
	c.rgb *= clamp(black * 1.4, 0.1, 1);

	c.r = mix(c.r, 1., fire(uv + vec2(0, 0.003)));
	
	COLOR = c;
}
