#version 310 es
precision mediump float;
precision highp int;

float _1383;

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
    highp vec4 _1371 = v_color0;
    highp vec2 _1207 = v_ditheringAndMaskTinting;
    highp vec4 _820 = texture(s_MatTexture, v_texcoord0);
    if (_1207.y > 0.5)
    {
        highp vec3 _872 = mix(_820.xyz, _820.xyz * v_color0.xyz, vec3(_820.w)).xyz * _1371.w;
        _820 = vec4(_872.x, _872.y, _872.z, _820.w);
        _820.w = 1.0;
    }
    else
    {
        highp vec3 _880 = _820.xyz * v_color0.xyz;
        _820 = vec4(_880.x, _880.y, _880.z, _820.w);
        _820.w *= _1371.w;
    }
    highp vec2 _1181 = DitherParams2[2].xy;
    if (_1207.x > 0.5)
    {
        highp mat4 _992 = u_view;
        highp vec4 _1198 = v_clipPosition;
        highp vec2 _1038 = floor(((((v_clipPosition.xyz / vec3(_1198.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 _1040 = floor(_1038 * 0.25);
        highp vec2 _1041 = floor(_1038 * 0.5);
        highp vec2 _1042 = floor(_1038);
        if (smoothstep(_1181.x, _1181.y, dot(-normalize(vec4(_992[0].z, _992[1].z, _992[2].z, _1383).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((_1040.x * 0.5) + ((_1040.y * _1040.y) * 0.75)) * 0.25) + fract((_1041.x * 0.5) + ((_1041.y * _1041.y) * 0.75))) * 0.25) + fract((_1042.x * 0.5) + ((_1042.y * _1042.y) * 0.75))) * 64.0) + 0.5) * 0.015625))
        {
            _820.w = 0.0;
        }
    }
    highp vec4 _1161 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * _820.xyz, _820.w).xyz, FogColor.xyz, vec3(_1161.w)), _820.w);
}

