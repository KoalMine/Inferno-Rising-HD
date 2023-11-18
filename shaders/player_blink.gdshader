shader_type canvas_item;

uniform float blink_modifier;

void fragment() {
	vec4 color = texture(TEXTURE, UV);// * vec4(0,0,0,1);
	color.rgb = mix(COLOR.rgb,vec3(1,1,1),blink_modifier);
	COLOR = color;
}
