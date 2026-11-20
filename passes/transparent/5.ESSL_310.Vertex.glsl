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
    vec4 _1519 = i_data1;
    vec4 _1520 = i_data2;
    vec4 _1521 = i_data3;
    mat4 _889;
    _889[0] = vec4(_1519.x, _1520.x, _1521.x, 0.0);
    _889[1] = vec4(_1519.y, _1520.y, _1521.y, 0.0);
    _889[2] = vec4(_1519.z, _1520.z, _1521.z, 0.0);
    _889[3] = vec4(_1519.w, _1520.w, _1521.w, 1.0);
    vec4 _966 = _889 * vec4(a_position, 1.0);
    vec3 _939 = _966.xyz;
    vec4 _1700 = a_color0;
    vec3 _1106 = _939 + vec3(0.5);
    vec3 _1113 = normalize(_1106 - ViewPositionAndTime.xyz);
    vec3 _1116 = normalize(cross(vec3(0.0, 1.0, 0.0), _1113));
    vec3 _1103 = a_color0.xyz;
    vec3 _1136 = _1106 - ((cross(_1113, _1116) * (_1103.z - 0.5)) + (_1116 * (_1103.x - 0.5)));
    float _1071 = length(ViewPositionAndTime.xyz - _1136);
    vec4 _1050 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _1206 = u_proj;
    vec4 _1173 = _1206[2];
    _1173.x += SubPixelOffset.x;
    _1173.y -= SubPixelOffset.y;
    mat4 _1215 = u_proj;
    _1215[2] = _1173;
    vec4 _1205 = _1215 * (u_view * vec4(_1136, 1.0));
    uvec2 _1225 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1230 = vec2(float((_1225.x & 32767u) << uint(1)), float((_1225.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1230.x += (3.0517578125e-05 * ((2.0 * float((_1225.x & 32768u) >> uint(15))) - 1.0));
    _1230.y += (3.0517578125e-05 * ((2.0 * float((_1225.y & 32768u) >> uint(15))) - 1.0));
    vec4 _1451 = vec4(1.0);
    if (_1700.w < 0.949999988079071044921875)
    {
        vec4 _1014 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
        _1451.w = mix(_1700.w, 1.0, clamp(_1071 / _1014.w, 0.0, 1.0));
    }
    uvec2 _1302 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1295 = _1302;
    v_clipPosition = _1205;
    v_color0 = _1451;
    v_ditheringAndMaskTinting = vec2(notEqual((_1302 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((_1071 / _1050.z) + RenderChunkFogAlpha.x) - _1050.x) / (_1050.y - _1050.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1295.y >> 4u, _1295.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1230;
    v_worldPos = _939;
    v_worldPosition = vec4(_966.xyz, 0.0);
    gl_Position = _1205;
}

