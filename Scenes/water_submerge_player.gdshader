shader_type canvas_item;

uniform bool cut_in_half = false;

void fragment() {
    vec2 uv = UV;

    if (cut_in_half && uv.y > 0.5) {
        discard;
    }

    COLOR = texture(TEXTURE, UV);
}
