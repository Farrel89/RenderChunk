#version 310 es
precision mediump float;
precision highp int;

uniform highp vec4 FogColor;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;

in highp vec4 v_color0;
in highp vec2 v_ditheringAndMaskTinting;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;

void main()
{
    highp vec4 _869 = v_color0;
    highp vec2 _710 = v_ditheringAndMaskTinting;
    highp vec4 _581 = texture(s_MatTexture, v_texcoord0);
    if (_710.y > 0.5)
    {
        highp vec3 _623 = mix(_581.xyz, _581.xyz * v_color0.xyz, vec3(_581.w)).xyz * _869.w;
        _581 = vec4(_623.x, _623.y, _623.z, _581.w);
        _581.w = 1.0;
    }
    else
    {
        highp vec3 _631 = _581.xyz * v_color0.xyz;
        _581 = vec4(_631.x, _631.y, _631.z, _581.w);
        _581.w *= _869.w;
    }
    highp vec4 _705 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _581.xyz, _581.w).xyz, FogColor.xyz, vec3(_705.w)), _581.w);
}

