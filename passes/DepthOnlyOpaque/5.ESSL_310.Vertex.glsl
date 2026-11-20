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
    vec4 _1125 = i_data1;
    vec4 _1126 = i_data2;
    vec4 _1127 = i_data3;
    mat4 _712;
    _712[0] = vec4(_1125.x, _1126.x, _1127.x, 0.0);
    _712[1] = vec4(_1125.y, _1126.y, _1127.y, 0.0);
    _712[2] = vec4(_1125.z, _1126.z, _1127.z, 0.0);
    _712[3] = vec4(_1125.w, _1126.w, _1127.w, 1.0);
    vec3 _762 = (_712 * vec4(a_position, 1.0)).xyz;
    vec3 _876 = _762 + vec3(0.5);
    vec3 _883 = normalize(_876 - ViewPositionAndTime.xyz);
    vec3 _886 = normalize(cross(vec3(0.0, 1.0, 0.0), _883));
    vec3 _873 = a_color0.xyz;
    vec3 _906 = _876 - ((cross(_883, _886) * (_873.z - 0.5)) + (_886 * (_873.x - 0.5)));
    vec4 _820 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _976 = u_proj;
    vec4 _943 = _976[2];
    _943.x += SubPixelOffset.x;
    _943.y -= SubPixelOffset.y;
    mat4 _985 = u_proj;
    _985[2] = _943;
    vec2 _1004 = round(vec2(0.0));
    uvec2 _995 = uvec2(_1004);
    vec2 _1000 = vec2(float((_995.x & 32767u) << uint(1)), float((_995.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1000.x += (3.0517578125e-05 * ((2.0 * float((_995.x & 32768u) >> uint(15))) - 1.0));
    _1000.y += (3.0517578125e-05 * ((2.0 * float((_995.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _906) / _820.z) + RenderChunkFogAlpha.x) - _820.x) / (_820.y - _820.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = _1000;
    v_worldPos = _762;
    gl_Position = _985 * (u_view * vec4(_906, 1.0));
}

