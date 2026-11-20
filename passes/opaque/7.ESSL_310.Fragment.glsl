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
    highp vec4 _825 = v_color0;
    highp vec4 _580 = texture(s_MatTexture, v_texcoord0);
    highp vec3 _581 = v_color0.xyz;
    highp vec3 _622 = (_580.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(_581.z))).xyz * vec3(_825.w);
    highp vec4 _583 = vec4(_622.x, _622.y, _622.z, _580.w);
    _583.w = 1.0;
    highp vec4 _568 = _583;
    highp vec4 _691 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _583.xyz, _568.w).xyz, FogColor.xyz, vec3(_691.w)), _568.w);
}

