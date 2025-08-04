shader_type canvas_item;

uniform vec4 modulate_color : source_color = vec4(1.0); // Supports modulate
uniform bool cut_in_half = false;
uniform float sink_amount = 0.1; // 0.0 to 1.0

void fragment() {
    vec2 uv = UV;

    // If underwater, visually shift the sprite up and clip the lower half
    if (cut_in_half) {
        uv.y -= sink_amount;
        if (uv.y > 0.5) {
            discard;
        }
    }

    // Sample the texture and apply modulate color
    vec4 base_color = texture(TEXTURE, uv);
    COLOR = base_color * modulate_color;
}

