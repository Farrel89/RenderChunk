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
    highp vec4 _811 = v_color0;
    highp vec2 _671 = v_ditheringAndMaskTinting;
    highp vec4 _552 = texture(s_MatTexture, v_texcoord0);
    if (_671.y > 0.5)
    {
        highp vec3 _588 = mix(_552.xyz, _552.xyz * v_color0.xyz, vec3(_552.w)).xyz * _811.w;
        _552 = vec4(_588.x, _588.y, _588.z, _552.w);
        _552.w = 1.0;
    }
    else
    {
        highp vec3 _596 = _552.xyz * v_color0.xyz;
        _552 = vec4(_596.x, _596.y, _596.z, _552.w);
        _552.w = _811.w;
    }
    highp vec4 _666 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _552.xyz, _552.w).xyz, FogColor.xyz, vec3(_666.w)), _552.w);
}

