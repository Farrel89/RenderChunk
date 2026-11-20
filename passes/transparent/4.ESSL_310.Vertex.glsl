#version 310 es

uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 MeshContext;
uniform vec4 FogAndDistanceControl;
uniform vec4 ViewPositionAndTime;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 FogColor;
uniform vec4 SubPixelOffset;

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
    vec4 _1347 = i_data1;
    vec4 _1348 = i_data2;
    vec4 _1349 = i_data3;
    mat4 _827;
    _827[0] = vec4(_1347.x, _1348.x, _1349.x, 0.0);
    _827[1] = vec4(_1347.y, _1348.y, _1349.y, 0.0);
    _827[2] = vec4(_1347.z, _1348.z, _1349.z, 0.0);
    _827[3] = vec4(_1347.w, _1348.w, _1349.w, 1.0);
    vec4 _904 = _827 * vec4(a_position, 1.0);
    vec3 _877 = _904.xyz;
    vec4 _1506 = a_color0;
    float _1001 = length(ViewPositionAndTime.xyz - _877);
    vec4 _986 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _1089 = u_proj;
    vec4 _1056 = _1089[2];
    _1056.x += SubPixelOffset.x;
    _1056.y -= SubPixelOffset.y;
    mat4 _1098 = u_proj;
    _1098[2] = _1056;
    vec4 _1088 = _1098 * (u_view * vec4(_904.xyz, 1.0));
    uvec2 _1108 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1113 = vec2(float((_1108.x & 32767u) << uint(1)), float((_1108.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1113.x += (3.0517578125e-05 * ((2.0 * float((_1108.x & 32768u) >> uint(15))) - 1.0));
    _1113.y += (3.0517578125e-05 * ((2.0 * float((_1108.y & 32768u) >> uint(15))) - 1.0));
    vec4 _1279 = a_color0;
    if (_1506.w < 0.949999988079071044921875)
    {
        vec4 _952 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
        _1279.w = mix(_1506.w, 1.0, clamp(_1001 / _952.w, 0.0, 1.0));
    }
    uvec2 _1185 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1178 = _1185;
    v_clipPosition = _1088;
    v_color0 = _1279;
    v_ditheringAndMaskTinting = vec2(notEqual((_1185 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((_1001 / _986.z) + RenderChunkFogAlpha.x) - _986.x) / (_986.y - _986.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1178.y >> 4u, _1178.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1113;
    v_worldPos = _877;
    v_worldPosition = vec4(_904.xyz, 0.0);
    gl_Position = _1088;
}

