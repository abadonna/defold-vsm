varying mediump vec2 var_texcoord0;
uniform highp sampler2D tex0;

uniform vec4 scale;

vec2 float_to_vec2(float v)
{
	vec3 enc = vec3(1.0, 255.0, 65025.0) * v;
	enc      = fract(enc);
	return enc.xy - enc.yz / 255.0 + 1.0/512.0;
}


float vec2_to_float(vec2 v) {
	return dot(v, vec2(1.0, 1./255.0) );
}

vec2 value (float offset) {
	vec2 uv = vec2(offset) * scale.xy;
	vec4 data = texture2D(tex0, var_texcoord0 + uv);
	return vec2(vec2_to_float(data.xy), vec2_to_float(data.zw));
}

void main()
{
	vec2 color = vec2(0.);
	color += value(-3.) * (1./64.);
	color += value(-2.) * (6./64.);
	color += value(-1.) * (15./64.);
	color += value(0.) * (20./64.);
	color += value(1.) * (15./64.);
	color += value(2.) * (6./64.);
	color += value(3.) * (1./64.);
	gl_FragColor = vec4(float_to_vec2(color.x), float_to_vec2(color.y));
}