#version 310 es

uniform mat4 u_proj;
uniform mat4 u_view;
uniform mat4 u_model[4];
uniform vec4 ViewPositionAndTime;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 FogColor;
uniform vec4 SubPixelOffset;
uniform vec4 MeshContext;
uniform vec4 FogAndDistanceControl;

in vec4 a_color0;
in vec2 a_texcoord1;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;

void main()
{
    vec3 _775 = (u_model[0] * vec4(a_position, 1.0)).xyz;
    vec3 _885 = _775 + vec3(0.5);
    vec3 _892 = normalize(_885 - ViewPositionAndTime.xyz);
    vec3 _895 = normalize(cross(vec3(0.0, 1.0, 0.0), _892));
    vec3 _882 = a_color0.xyz;
    vec3 _915 = _885 - ((cross(_892, _895) * (_882.z - 0.5)) + (_895 * (_882.x - 0.5)));
    vec4 _829 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _985 = u_proj;
    vec4 _952 = _985[2];
    _952.x += SubPixelOffset.x;
    _952.y -= SubPixelOffset.y;
    mat4 _994 = u_proj;
    _994[2] = _952;
    uvec2 _1004 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1009 = vec2(float((_1004.x & 32767u) << uint(1)), float((_1004.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1009.x += (3.0517578125e-05 * ((2.0 * float((_1004.x & 32768u) >> uint(15))) - 1.0));
    _1009.y += (3.0517578125e-05 * ((2.0 * float((_1004.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _1072 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1065 = _1072;
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(notEqual((_1072 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _915) / _829.z) + RenderChunkFogAlpha.x) - _829.x) / (_829.y - _829.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1065.y >> 4u, _1065.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1009;
    v_worldPos = _775;
    gl_Position = _994 * (u_view * vec4(_915, 1.0));
}

