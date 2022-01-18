varying highp vec4 var_position;
uniform mediump mat4 mtx_proj;

vec4 float_to_rgba(float v)
{
    vec4 enc = vec4(1.0, 255.0, 65025.0, 16581375.0) * v;
    enc      = fract(enc);
    enc     -= enc.yzww * vec4(1.0/255.0,1.0/255.0,1.0/255.0,0.0);
    return enc;
}

void main()
{
    const float esm_factor = 1.;
    //vec4 p = mtx_proj * var_position;
    float color = exp(esm_factor * var_position.z);
    gl_FragColor = float_to_rgba(color);
}

