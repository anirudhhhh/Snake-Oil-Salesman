shader_type canvas_item;

// Wind sway shader for 2D foliage, grass tufts, flowers, and tree canopies.
// Anchors the bottom edge of the sprite (UV.y close to 1.0) and bends the top progressively.

uniform float speed : hint_range(0.1, 10.0) = 2.0;
uniform float min_strength : hint_range(0.0, 50.0) = 0.5;
uniform float max_strength : hint_range(0.0, 50.0) = 4.0;
uniform float strength_scale : hint_range(0.0, 10.0) = 1.0;
uniform float interval : hint_range(0.1, 10.0) = 3.5;
uniform float detail : hint_range(0.0, 5.0) = 0.3;
uniform float height_offset : hint_range(0.0, 1.0) = 0.0;
uniform float frequency : hint_range(0.001, 0.1) = 0.015;

void vertex() {
	// Base is anchored at bottom (UV.y == 1.0), tips sway at top (UV.y == 0.0)
	float diff = max(0.0, (1.0 - UV.y) - height_offset);
	float anchor_factor = pow(diff, 1.4);
	
	// Global position for wave coherence across neighboring objects
	vec2 world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	
	// Primary wind wave
	float wave = sin(TIME * speed + world_pos.x * frequency + world_pos.y * (frequency * 0.5));
	// Micro flutter for leaf/blade detail
	float micro = sin(TIME * speed * 2.3 + world_pos.x * 0.04) * detail;
	
	// Gust variation over time
	float gust = 0.5 + 0.5 * sin(TIME * (speed / interval) + world_pos.x * 0.005);
	float strength = mix(min_strength, max_strength, gust) * strength_scale;
	
	VERTEX.x += (wave + micro) * strength * anchor_factor;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
}
