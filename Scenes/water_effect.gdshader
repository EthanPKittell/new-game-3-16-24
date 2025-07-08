shader_type canvas_item;

uniform float speed = 3.0;
uniform float amplitude = 8.0;
uniform float frequency = 15.0;
uniform float transparency : hint_range(0.0, 1.0) = 0.6; // Alpha

void fragment() {
    vec2 uv = UV;
    uv.y += sin(UV.x * frequency + TIME * speed) * amplitude / 100.0;
    COLOR = texture(TEXTURE, uv);
    COLOR.a *= transparency;
}