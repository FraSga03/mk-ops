shader_type spatial;

uniform bool effect_enabled = false;
uniform sampler2D my_texture : source_color;

void fragment() {
	if(effect_enabled) {
	    float intensity = sin(TIME * 3.0) + 0.1;
	    vec3 violet = vec3(139, 23, 255);
		ALBEDO = violet * intensity * 0.01;
	    ALPHA = intensity * 0.3;
	} else {
	    vec4 tex_color = texture(my_texture, UV);

        ALBEDO = tex_color.rgb;
		ALPHA = 0.0;
	}
}
