shader_type canvas_item;

uniform bool cut_in_half = false;
uniform float sink_amount = 0.1; // range: 0.0 to 1.0
uniform bool blink_active = false;

void fragment() {
    vec2 uv = UV;

    // Apply sink effect by shifting UV upward
    if (cut_in_half) {
        uv.y -= sink_amount;

        // Discard lower half when submerged
        if (uv.y > 0.5) {
            discard;
        }
    }

    // Sample the texture after UV modification
    vec4 base_color = texture(TEXTURE, uv);

    // Apply blink effect by turning white
    if (blink_active) {
        base_color.rgb = vec3(1.0); // turn white but keep original alpha
    }

    COLOR = base_color;
}
