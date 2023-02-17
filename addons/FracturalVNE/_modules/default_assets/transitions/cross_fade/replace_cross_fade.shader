shader_type canvas_item;

uniform sampler2D old_texture;
uniform float progress : hint_range(0, 1);

void fragment() 
{
	vec4 old_color = texture(old_texture, UV);
	vec4 new_color = texture(TEXTURE, UV);
	
	if (old_color.a == 0.0f && new_color.a != 0.0f)
		COLOR.rgb = new_color.rgb;
	else if (old_color.a != 0.0f && new_color.a == 0.0f)
		COLOR.rgb = old_color.rgb;
	else
		COLOR.rgb = mix(old_color.rgb, new_color.rgb, progress);
	COLOR.a = mix(old_color.a, new_color.a, progress);
}