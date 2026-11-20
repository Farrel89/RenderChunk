#version 310 es
precision mediump float;
precision highp int;

uniform highp sampler2D s_MatTexture;

centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;

void main()
{
    highp vec4 _324 = texture(s_MatTexture, v_texcoord0);
    if (_324.w < 0.5)
    {
        discard;
    }
    bgfx_FragColor = vec4(0.0);
}

