#version 310 es
precision mediump float;
precision highp int;

float _1455;

uniform highp mat4 u_view;
uniform highp vec4 FogColor;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 ViewPositionAndTime;
uniform highp sampler2D s_SeasonsTexture;

in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec2 v_ditheringAndMaskTinting;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
in highp vec4 v_worldPosition;
layout(location = 0) out highp vec4 bgfx_FragData0;

void main()
{
    highp vec4 _1441 = v_color0;
    highp vec2 _1278 = v_ditheringAndMaskTinting;
    highp vec4 _859 = texture(s_MatTexture, v_texcoord0);
    highp vec2 _1238 = DitherParams2[2].xy;
    bool _1451;
    if (_1278.x > 0.5)
    {
        highp mat4 _1020 = u_view;
        highp vec4 _1229 = v_clipPosition;
        highp vec2 _1066 = floor(((((v_clipPosition.xyz / vec3(_1229.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 _1068 = floor(_1066 * 0.25);
        highp vec2 _1069 = floor(_1066 * 0.5);
        highp vec2 _1070 = floor(_1066);
        _1451 = smoothstep(_1238.x, _1238.y, dot(-normalize(vec4(_1020[0].z, _1020[1].z, _1020[2].z, _1455).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((_1068.x * 0.5) + ((_1068.y * _1068.y) * 0.75)) * 0.25) + fract((_1069.x * 0.5) + ((_1069.y * _1069.y) * 0.75))) * 0.25) + fract((_1070.x * 0.5) + ((_1070.y * _1070.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        _1451 = false;
    }
    if (_1451 || (_859.w < 0.5))
    {
        discard;
    }
    highp vec3 _883 = v_color0.xyz;
    highp vec3 _1157 = (_859.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(_883.z))).xyz * vec3(_1441.w);
    highp vec4 _885 = vec4(_1157.x, _1157.y, _1157.z, _859.w);
    _885.w = 1.0;
    _859 = _885;
    highp vec4 _1226 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _885.xyz, _859.w).xyz, FogColor.xyz, vec3(_1226.w)), _859.w);
}

