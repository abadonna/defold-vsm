varying mediump vec2 var_texcoord0;
uniform highp sampler2D tex0;

uniform vec4 scale;


vec2 value (float offset) {
	vec2 uv = vec2(offset) * scale.xy;
	return texture2D(tex0, var_texcoord0 + uv).xy;
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
	gl_FragColor = vec4(color.xy, 0 ,0);
}