shader_type canvas_item;

global uniform float camera_zoom;
global uniform vec2 camera_offset;
global uniform float flicker_time;


float smin(float a, float b, float k) {
  float h = clamp(0.5 + 0.5*(a-b)/k, 0.0, 1.0);
  return mix(a, b, h) - k*h*(1.0-h);
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec2 rot(vec2 v, float a) {
	return vec2(
		v.x * cos(a) - v.y * sin(a),
		v.x * sin(a) + v.y * cos(a)
	);
}

float symbol(vec2 p) {
	p = p * 2. - 1.;
	p = rot(p, PI * 0.25);
	
	float d1 = sdBox(p, vec2(0, 0.6));
	float d2 = sdBox(rot(p, PI * 0.5), vec2(0, 0.6));
	
	return step(smin(d1, d2, 0.125), 0.08);
}

float circle(vec2 p) {
	p = p * 2. - 1.;
	return step(length(p), 0.3);
}

void fragment() {
	vec4 c = COLOR;
	
	vec2 uv = SCREEN_UV / camera_zoom + camera_offset / vec2(3840, 2160) + camera_zoom;
	uv = uv / (SCREEN_PIXEL_SIZE / SCREEN_PIXEL_SIZE.x);
	
	uv += TIME * vec2(-1, 1) * 0.035;
	
	vec2 tiled_uv = fract(uv * 30.);

	if (c.b > c.r + c.g) {
		c.a *= 1. - circle(tiled_uv);
	} else {
		c.a *= 1. - symbol(tiled_uv);
	}
	
	c.a = max(c.a, 0.2);
	
	COLOR = c;
}
