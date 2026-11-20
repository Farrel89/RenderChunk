#version 310 es

uniform mat4 u_proj;
uniform mat4 u_view;
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
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;

void main()
{
    vec4 _1126 = i_data1;
    vec4 _1127 = i_data2;
    vec4 _1128 = i_data3;
    mat4 _752;
    _752[0] = vec4(_1126.x, _1127.x, _1128.x, 0.0);
    _752[1] = vec4(_1126.y, _1127.y, _1128.y, 0.0);
    _752[2] = vec4(_1126.z, _1127.z, _1128.z, 0.0);
    _752[3] = vec4(_1126.w, _1127.w, _1128.w, 1.0);
    vec4 _829 = _752 * vec4(a_position, 1.0);
    vec3 _802 = _829.xyz;
    vec4 _858 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _961 = u_proj;
    vec4 _928 = _961[2];
    _928.x += SubPixelOffset.x;
    _928.y -= SubPixelOffset.y;
    mat4 _970 = u_proj;
    _970[2] = _928;
    uvec2 _980 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _985 = vec2(float((_980.x & 32767u) << uint(1)), float((_980.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _985.x += (3.0517578125e-05 * ((2.0 * float((_980.x & 32768u) >> uint(15))) - 1.0));
    _985.y += (3.0517578125e-05 * ((2.0 * float((_980.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _1048 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1041 = _1048;
    v_color0 = a_color0;
    v_ditheringAndMaskTinting = vec2(notEqual((_1048 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _802) / _858.z) + RenderChunkFogAlpha.x) - _858.x) / (_858.y - _858.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1041.y >> 4u, _1041.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _985;
    v_worldPos = _802;
    gl_Position = _970 * (u_view * vec4(_829.xyz, 1.0));
}

