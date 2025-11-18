shader_type canvas_item;

uniform float intensity : hint_range(0.0, 2.0) = 0.0;
uniform vec4 poison_color : source_color = vec4(0.2, 1.0, 0.2, 1.0);

void fragment() {
    vec4 c = texture(TEXTURE, UV);

    if (c.a == 0.0) {
        // Fully transparent texel — keep it transparent
        COLOR = c;
    } else {
        // Pulse the tint using TIME (built-in)
        float glow = (sin(TIME * 5.0) + 1.0) * 0.5; // 0..1
        glow *= intensity;

        c.rgb = mix(c.rgb, poison_color.rgb, glow);
        COLOR = c;
    }
}
