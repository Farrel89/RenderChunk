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
out vec4 v_clipPosition;
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;
out vec4 v_worldPosition;

void main()
{
    vec4 _1270 = i_data1;
    vec4 _1271 = i_data2;
    vec4 _1272 = i_data3;
    mat4 _809;
    _809[0] = vec4(_1270.x, _1271.x, _1272.x, 0.0);
    _809[1] = vec4(_1270.y, _1271.y, _1272.y, 0.0);
    _809[2] = vec4(_1270.z, _1271.z, _1272.z, 0.0);
    _809[3] = vec4(_1270.w, _1271.w, _1272.w, 1.0);
    vec4 _886 = _809 * vec4(a_position, 1.0);
    vec3 _859 = _886.xyz;
    vec4 _949 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _1052 = u_proj;
    vec4 _1019 = _1052[2];
    _1019.x += SubPixelOffset.x;
    _1019.y -= SubPixelOffset.y;
    mat4 _1061 = u_proj;
    _1061[2] = _1019;
    vec4 _1051 = _1061 * (u_view * vec4(_886.xyz, 1.0));
    uvec2 _1071 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1076 = vec2(float((_1071.x & 32767u) << uint(1)), float((_1071.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1076.x += (3.0517578125e-05 * ((2.0 * float((_1071.x & 32768u) >> uint(15))) - 1.0));
    _1076.y += (3.0517578125e-05 * ((2.0 * float((_1071.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _1139 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1132 = _1139;
    v_clipPosition = _1051;
    v_color0 = a_color0;
    v_ditheringAndMaskTinting = vec2(notEqual((_1139 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _859) / _949.z) + RenderChunkFogAlpha.x) - _949.x) / (_949.y - _949.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1132.y >> 4u, _1132.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1076;
    v_worldPos = _859;
    v_worldPosition = vec4(_886.xyz, 0.0);
    gl_Position = _1051;
}

