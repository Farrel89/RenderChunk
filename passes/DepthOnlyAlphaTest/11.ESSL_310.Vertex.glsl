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
    vec4 _1131 = i_data1;
    vec4 _1132 = i_data2;
    vec4 _1133 = i_data3;
    mat4 _718;
    _718[0] = vec4(_1131.x, _1132.x, _1133.x, 0.0);
    _718[1] = vec4(_1131.y, _1132.y, _1133.y, 0.0);
    _718[2] = vec4(_1131.z, _1132.z, _1133.z, 0.0);
    _718[3] = vec4(_1131.w, _1132.w, _1133.w, 1.0);
    vec3 _768 = (_718 * vec4(a_position, 1.0)).xyz;
    vec3 _882 = _768 + vec3(0.5);
    vec3 _889 = normalize(_882 - ViewPositionAndTime.xyz);
    vec3 _892 = normalize(cross(vec3(0.0, 1.0, 0.0), _889));
    vec3 _879 = a_color0.xyz;
    vec3 _912 = _882 - ((cross(_889, _892) * (_879.z - 0.5)) + (_892 * (_879.x - 0.5)));
    vec4 _826 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _982 = u_proj;
    vec4 _949 = _982[2];
    _949.x += SubPixelOffset.x;
    _949.y -= SubPixelOffset.y;
    mat4 _991 = u_proj;
    _991[2] = _949;
    uvec2 _1001 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1006 = vec2(float((_1001.x & 32767u) << uint(1)), float((_1001.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1006.x += (3.0517578125e-05 * ((2.0 * float((_1001.x & 32768u) >> uint(15))) - 1.0));
    _1006.y += (3.0517578125e-05 * ((2.0 * float((_1001.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _912) / _826.z) + RenderChunkFogAlpha.x) - _826.x) / (_826.y - _826.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = _1006;
    v_worldPos = _768;
    gl_Position = _991 * (u_view * vec4(_912, 1.0));
}

