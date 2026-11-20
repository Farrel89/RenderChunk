#version 310 es

uniform mat4 u_proj;
uniform mat4 u_view;
uniform mat4 u_model[4];
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
    vec4 _787 = u_model[0] * vec4(a_position, 1.0);
    vec3 _788 = _787.xyz;
    vec4 _1389 = a_color0;
    float _908 = length(ViewPositionAndTime.xyz - _788);
    vec4 _893 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _996 = u_proj;
    vec4 _963 = _996[2];
    _963.x += SubPixelOffset.x;
    _963.y -= SubPixelOffset.y;
    mat4 _1005 = u_proj;
    _1005[2] = _963;
    vec4 _995 = _1005 * (u_view * vec4(_787.xyz, 1.0));
    uvec2 _1015 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1020 = vec2(float((_1015.x & 32767u) << uint(1)), float((_1015.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1020.x += (3.0517578125e-05 * ((2.0 * float((_1015.x & 32768u) >> uint(15))) - 1.0));
    _1020.y += (3.0517578125e-05 * ((2.0 * float((_1015.y & 32768u) >> uint(15))) - 1.0));
    vec4 _1186 = a_color0;
    if (_1389.w < 0.949999988079071044921875)
    {
        vec4 _859 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
        _1186.w = mix(_1389.w, 1.0, clamp(_908 / _859.w, 0.0, 1.0));
    }
    uvec2 _1092 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1085 = _1092;
    v_clipPosition = _995;
    v_color0 = _1186;
    v_ditheringAndMaskTinting = vec2(notEqual((_1092 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((_908 / _893.z) + RenderChunkFogAlpha.x) - _893.x) / (_893.y - _893.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1085.y >> 4u, _1085.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1020;
    v_worldPos = _788;
    v_worldPosition = vec4(_787.xyz, 0.0);
    gl_Position = _995;
}

