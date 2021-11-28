shader_type canvas_item;

uniform vec4 mask_color : hint_color = vec4(1.0);
uniform bool masked = false;

void fragment() {
	if (masked) {
		COLOR = vec4(mask_color.rgb, texture(TEXTURE, UV).a * mask_color.a);	
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}
