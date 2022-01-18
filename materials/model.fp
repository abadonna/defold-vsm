varying highp vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;


uniform mediump vec4 mtx_light0;
uniform mediump vec4 mtx_light1;
uniform mediump vec4 mtx_light2;
uniform mediump vec4 mtx_light3;

uniform lowp sampler2D tex0;
uniform lowp sampler2D tex1;
uniform lowp vec4 tint;
float rgba_to_float(vec4 rgba)
{
    return dot(rgba, vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0));
}

float vec2_to_float(vec2 v) {
    return dot(v, vec2(1.0, 1./255.0) );
}

mat4 get_shadow_mat()
{
    return mat4(mtx_light0, mtx_light1, mtx_light2, mtx_light3);
}

float linstep(float min, float max, float v) 
{
    return clamp((v - min) / (max-min), 0., 1.);
}

float get_shadow(vec3 proj)
{
    if (proj.x < 0. ||proj.x > 1. || proj.y < 0. ||proj.y > 1.)
    {
        return  1.;
    }
    vec4 data = texture2D(tex1, proj.xy);
    float m1 = vec2_to_float(data.xy);
    float m2 = vec2_to_float(data.zw);
    float p = step(proj.z, m1);
    float variance = max(m2 -  m1 * m1, .00002);
    float d = proj.z - m1;
    float pMax = linstep(0.5, 1., variance / (variance  + d * d));
    return max(p, pMax);
}
void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 color = texture2D(tex0, var_texcoord0.xy) * tint_pm;

    // Diffuse light calculations
    vec3 ambient_light = vec3(0.2);
    vec3 diff_light = vec3(normalize(var_light.xyz - var_position.xyz));
    diff_light = max(dot(var_normal,diff_light), 0.0) + ambient_light;
    diff_light = clamp(diff_light, 0.0, 1.0);

    vec4 dp = get_shadow_mat() * var_position;
    dp = dp / dp.w;
    
    float shadow = clamp(get_shadow(dp.xyz), 0.3, 1.);

    gl_FragColor = vec4(shadow*color.rgb*diff_light,1.0);
}

