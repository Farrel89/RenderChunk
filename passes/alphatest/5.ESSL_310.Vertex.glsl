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
    vec4 _1442 = i_data1;
    vec4 _1443 = i_data2;
    vec4 _1444 = i_data3;
    mat4 _871;
    _871[0] = vec4(_1442.x, _1443.x, _1444.x, 0.0);
    _871[1] = vec4(_1442.y, _1443.y, _1444.y, 0.0);
    _871[2] = vec4(_1442.z, _1443.z, _1444.z, 0.0);
    _871[3] = vec4(_1442.w, _1443.w, _1444.w, 1.0);
    vec4 _948 = _871 * vec4(a_position, 1.0);
    vec3 _921 = _948.xyz;
    vec3 _1069 = _921 + vec3(0.5);
    vec3 _1076 = normalize(_1069 - ViewPositionAndTime.xyz);
    vec3 _1079 = normalize(cross(vec3(0.0, 1.0, 0.0), _1076));
    vec3 _1066 = a_color0.xyz;
    vec3 _1099 = _1069 - ((cross(_1076, _1079) * (_1066.z - 0.5)) + (_1079 * (_1066.x - 0.5)));
    vec4 _1013 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _1169 = u_proj;
    vec4 _1136 = _1169[2];
    _1136.x += SubPixelOffset.x;
    _1136.y -= SubPixelOffset.y;
    mat4 _1178 = u_proj;
    _1178[2] = _1136;
    vec4 _1168 = _1178 * (u_view * vec4(_1099, 1.0));
    uvec2 _1188 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1193 = vec2(float((_1188.x & 32767u) << uint(1)), float((_1188.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1193.x += (3.0517578125e-05 * ((2.0 * float((_1188.x & 32768u) >> uint(15))) - 1.0));
    _1193.y += (3.0517578125e-05 * ((2.0 * float((_1188.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _1256 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1249 = _1256;
    v_clipPosition = _1168;
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(notEqual((_1256 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _1099) / _1013.z) + RenderChunkFogAlpha.x) - _1013.x) / (_1013.y - _1013.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1249.y >> 4u, _1249.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1193;
    v_worldPos = _921;
    v_worldPosition = vec4(_948.xyz, 0.0);
    gl_Position = _1168;
}

