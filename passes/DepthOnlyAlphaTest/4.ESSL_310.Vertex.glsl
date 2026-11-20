#version 310 es

uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 ViewPositionAndTime;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 FogColor;
uniform vec4 SubPixelOffset;
uniform vec4 MeshContext;
uniform vec4 FogAndDistanceControl;

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
    vec4 _969 = i_data1;
    vec4 _970 = i_data2;
    vec4 _971 = i_data3;
    mat4 _656;
    _656[0] = vec4(_969.x, _970.x, _971.x, 0.0);
    _656[1] = vec4(_969.y, _970.y, _971.y, 0.0);
    _656[2] = vec4(_969.z, _970.z, _971.z, 0.0);
    _656[3] = vec4(_969.w, _970.w, _971.w, 1.0);
    vec4 _733 = _656 * vec4(a_position, 1.0);
    vec3 _706 = _733.xyz;
    vec4 _762 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _865 = u_proj;
    vec4 _832 = _865[2];
    _832.x += SubPixelOffset.x;
    _832.y -= SubPixelOffset.y;
    mat4 _874 = u_proj;
    _874[2] = _832;
    uvec2 _884 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _889 = vec2(float((_884.x & 32767u) << uint(1)), float((_884.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _889.x += (3.0517578125e-05 * ((2.0 * float((_884.x & 32768u) >> uint(15))) - 1.0));
    _889.y += (3.0517578125e-05 * ((2.0 * float((_884.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(0.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _706) / _762.z) + RenderChunkFogAlpha.x) - _762.x) / (_762.y - _762.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = _889;
    v_worldPos = _706;
    gl_Position = _874 * (u_view * vec4(_733.xyz, 1.0));
}

