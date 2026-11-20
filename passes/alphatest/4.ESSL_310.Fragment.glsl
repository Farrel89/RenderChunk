#version 310 es
precision mediump float;
precision highp int;

uniform highp vec4 FogColor;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_SeasonsTexture;

in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;

void main()
{
    highp vec4 _1373 = v_color0;
    highp vec4 _838 = texture(s_MatTexture, v_texcoord0);
    if (false || (_838.w < 0.5))
    {
        discard;
    }
    highp vec3 _862 = v_color0.xyz;
    highp vec3 _1115 = (_838.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(_862.z))).xyz * vec3(_1373.w);
    highp vec4 _864 = vec4(_1115.x, _1115.y, _1115.z, _838.w);
    _864.w = 1.0;
    _838 = _864;
    highp vec4 _1184 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _864.xyz, _838.w).xyz, FogColor.xyz, vec3(_1184.w)), _838.w);
}

