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
    vec4 _963 = i_data1;
    vec4 _964 = i_data2;
    vec4 _965 = i_data3;
    mat4 _650;
    _650[0] = vec4(_963.x, _964.x, _965.x, 0.0);
    _650[1] = vec4(_963.y, _964.y, _965.y, 0.0);
    _650[2] = vec4(_963.z, _964.z, _965.z, 0.0);
    _650[3] = vec4(_963.w, _964.w, _965.w, 1.0);
    vec4 _727 = _650 * vec4(a_position, 1.0);
    vec3 _700 = _727.xyz;
    vec4 _756 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _859 = u_proj;
    vec4 _826 = _859[2];
    _826.x += SubPixelOffset.x;
    _826.y -= SubPixelOffset.y;
    mat4 _868 = u_proj;
    _868[2] = _826;
    vec2 _887 = round(vec2(0.0));
    uvec2 _878 = uvec2(_887);
    vec2 _883 = vec2(float((_878.x & 32767u) << uint(1)), float((_878.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _883.x += (3.0517578125e-05 * ((2.0 * float((_878.x & 32768u) >> uint(15))) - 1.0));
    _883.y += (3.0517578125e-05 * ((2.0 * float((_878.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(0.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _700) / _756.z) + RenderChunkFogAlpha.x) - _756.x) / (_756.y - _756.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = _883;
    v_worldPos = _700;
    gl_Position = _868 * (u_view * vec4(_727.xyz, 1.0));
}

