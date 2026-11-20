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
    vec4 _1288 = i_data1;
    vec4 _1289 = i_data2;
    vec4 _1290 = i_data3;
    mat4 _814;
    _814[0] = vec4(_1288.x, _1289.x, _1290.x, 0.0);
    _814[1] = vec4(_1288.y, _1289.y, _1290.y, 0.0);
    _814[2] = vec4(_1288.z, _1289.z, _1290.z, 0.0);
    _814[3] = vec4(_1288.w, _1289.w, _1290.w, 1.0);
    vec3 _864 = (_814 * vec4(a_position, 1.0)).xyz;
    vec3 _978 = _864 + vec3(0.5);
    vec3 _985 = normalize(_978 - ViewPositionAndTime.xyz);
    vec3 _988 = normalize(cross(vec3(0.0, 1.0, 0.0), _985));
    vec3 _975 = a_color0.xyz;
    vec3 _1008 = _978 - ((cross(_985, _988) * (_975.z - 0.5)) + (_988 * (_975.x - 0.5)));
    vec4 _922 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _1078 = u_proj;
    vec4 _1045 = _1078[2];
    _1045.x += SubPixelOffset.x;
    _1045.y -= SubPixelOffset.y;
    mat4 _1087 = u_proj;
    _1087[2] = _1045;
    uvec2 _1097 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1102 = vec2(float((_1097.x & 32767u) << uint(1)), float((_1097.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1102.x += (3.0517578125e-05 * ((2.0 * float((_1097.x & 32768u) >> uint(15))) - 1.0));
    _1102.y += (3.0517578125e-05 * ((2.0 * float((_1097.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _1165 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1158 = _1165;
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(notEqual((_1165 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _1008) / _922.z) + RenderChunkFogAlpha.x) - _922.x) / (_922.y - _922.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1158.y >> 4u, _1158.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1102;
    v_worldPos = _864;
    gl_Position = _1087 * (u_view * vec4(_1008, 1.0));
}

