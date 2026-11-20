#version 310 es
precision mediump float;
precision highp int;

float _1376;

uniform highp mat4 u_view;
uniform highp vec4 FogColor;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 ViewPositionAndTime;

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
    highp vec2 _1201 = v_ditheringAndMaskTinting;
    highp vec4 _822 = texture(s_MatTexture, v_texcoord0);
    highp vec2 _1162 = DitherParams2[2].xy;
    bool _1373;
    if (_1201.x > 0.5)
    {
        highp mat4 _981 = u_view;
        highp vec4 _1153 = v_clipPosition;
        highp vec2 _1027 = floor(((((v_clipPosition.xyz / vec3(_1153.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 _1029 = floor(_1027 * 0.25);
        highp vec2 _1030 = floor(_1027 * 0.5);
        highp vec2 _1031 = floor(_1027);
        _1373 = smoothstep(_1162.x, _1162.y, dot(-normalize(vec4(_981[0].z, _981[1].z, _981[2].z, _1376).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((_1029.x * 0.5) + ((_1029.y * _1029.y) * 0.75)) * 0.25) + fract((_1030.x * 0.5) + ((_1030.y * _1030.y) * 0.75))) * 0.25) + fract((_1031.x * 0.5) + ((_1031.y * _1031.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        _1373 = false;
    }
    if (_1373 || (_822.w < 0.5))
    {
        discard;
    }
    highp vec4 _877 = _822;
    highp vec3 _879 = _877.xyz * v_color0.xyz;
    _822 = vec4(_879.x, _879.y, _879.z, _877.w);
    highp vec4 _1150 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _879.xyz, _822.w).xyz, FogColor.xyz, vec3(_1150.w)), _822.w);
}

