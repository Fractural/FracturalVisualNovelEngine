shader_type canvas_item;

uniform vec4 tint_color: hint_color;
uniform float tint_amount: hint_range(0.0, 1.0);

void fragment()
{
	COLOR.a = texture(TEXTURE, UV).a;
    COLOR.rgb = mix(texture(TEXTURE, UV).rgb, tint_color.rgb, tint_amount);
}