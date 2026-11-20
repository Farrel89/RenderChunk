#version 310 es
precision mediump float;
precision highp int;

uniform highp vec4 FogColor;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;

in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;

void main()
{
    highp vec4 _800 = texture(s_MatTexture, v_texcoord0);
    if (false || (_800.w < 0.5))
    {
        discard;
    }
    highp vec4 _834 = _800;
    highp vec3 _836 = _834.xyz * v_color0.xyz;
    _800 = vec4(_836.x, _836.y, _836.z, _834.w);
    highp vec4 _1107 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _836.xyz, _800.w).xyz, FogColor.xyz, vec3(_1107.w)), _800.w);
}

