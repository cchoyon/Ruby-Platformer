shader_type canvas_item;

uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;
uniform float opacity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);
	float vignette = smoothstep(0.2, 0.7, dist) * vignette_intensity;
	COLOR = vec4(0.0, 0.0, 0.0, vignette * opacity);
}