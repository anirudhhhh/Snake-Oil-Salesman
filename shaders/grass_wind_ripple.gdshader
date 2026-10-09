shader_type canvas_item;

// Subtle ambient breeze highlight ripple across the open grass meadow.

uniform float wind_speed : hint_range(0.1, 5.0) = 1.1;
uniform float wave_frequency : hint_range(0.001, 0.05) = 0.007;
uniform float wave_intensity : hint_range(0.0, 0.3) = 0.07;
uniform vec4 wave_tint : source_color = vec4(0.88, 1.08, 0.78, 1.0);

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	// Screen coordinates for travelling wave bands across the entire field
	vec2 coord = FRAGCOORD.xy;
	float wave1 = sin(TIME * wind_speed + (coord.x + coord.y * 0.6) * wave_frequency);
	float wave2 = sin(TIME * wind_speed * 1.3 + (coord.x * 0.7 - coord.y * 0.5) * wave_frequency * 1.2);
	float combined = clamp((wave1 + wave2) * 0.5, 0.0, 1.0);
	
	vec3 color = mix(base.rgb, base.rgb * wave_tint.rgb, combined * wave_intensity);
	COLOR = vec4(color, base.a);
}
