varying highp vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;


uniform mediump vec4 mtx_light0;
uniform mediump vec4 mtx_light1;
uniform mediump vec4 mtx_light2;
uniform mediump vec4 mtx_light3;

uniform mediump vec4 mtx_lv0;
uniform mediump vec4 mtx_lv1;
uniform mediump vec4 mtx_lv2;
uniform mediump vec4 mtx_lv3;

uniform lowp sampler2D tex0;
uniform lowp sampler2D tex1;
uniform lowp vec4 tint;
float rgba_to_float(vec4 rgba)
{
    return dot(rgba, vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0));
}

mat4 get_shadow_mat()
{
    return mat4(mtx_light0, mtx_light1, mtx_light2, mtx_light3);
}

mat4 get_light_mat()
{
    return mat4(mtx_lv0, mtx_lv1, mtx_lv2, mtx_lv3);
}

float get_shadow(vec3 proj)
{
    if (proj.x < 0. || proj.x > 1. || proj.y < 0. || proj.y > 1.)
    {
        return 1;
    }
    const float esm_bias   = -1.;
    const float esm_factor = 1.;

    float occluder = rgba_to_float(texture(tex1, proj.xy));
    vec4 p  = get_light_mat() * var_position;

    
    float receiver = exp(esm_bias - esm_factor * p.z);
    return 1.- occluder * receiver;
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

