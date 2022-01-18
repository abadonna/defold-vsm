varying highp vec4 var_position;

vec2 float_to_vec2(float v)
{
    vec3 enc = vec3(1.0, 255.0, 65025.0) * v;
    enc      = fract(enc);
    return enc.xy - enc.yz / 255.0 + 1.0/512.0;
}


void main()
{
    float depth = gl_FragCoord.z;
    float dx = dFdx(depth);
    float dy = dFdy(depth);
    float moment2 = depth * depth + 0.25 * (dx * dx + dy * dy);
    gl_FragColor = vec4(float_to_vec2(depth), float_to_vec2(moment2));
}

