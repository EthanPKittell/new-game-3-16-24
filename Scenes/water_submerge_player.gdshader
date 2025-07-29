shader_type canvas_item;

uniform bool cut_in_half = false;
uniform float sink_amount = 0.1; // 0.0 to 1.0 — how much to visually sink

void fragment() {
    vec2 uv = UV;

    if (cut_in_half) {
        uv.y -= sink_amount; // shift texture upward
        if (uv.y > 0.5) {
            discard; // still discard bottom half
        }
    }

    COLOR = texture(TEXTURE, uv);
}
