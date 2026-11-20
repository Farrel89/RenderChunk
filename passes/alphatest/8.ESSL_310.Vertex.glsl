#version 310 es

uniform mat4 u_proj;
uniform mat4 u_view;
uniform mat4 u_model[4];
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
    vec4 _831 = u_model[0] * vec4(a_position, 1.0);
    vec3 _832 = _831.xyz;
    vec3 _976 = _832 + vec3(0.5);
    vec3 _983 = normalize(_976 - ViewPositionAndTime.xyz);
    vec3 _986 = normalize(cross(vec3(0.0, 1.0, 0.0), _983));
    vec3 _973 = a_color0.xyz;
    vec3 _1006 = _976 - ((cross(_983, _986) * (_973.z - 0.5)) + (_986 * (_973.x - 0.5)));
    vec4 _920 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _1076 = u_proj;
    vec4 _1043 = _1076[2];
    _1043.x += SubPixelOffset.x;
    _1043.y -= SubPixelOffset.y;
    mat4 _1085 = u_proj;
    _1085[2] = _1043;
    vec4 _1075 = _1085 * (u_view * vec4(_1006, 1.0));
    uvec2 _1095 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1100 = vec2(float((_1095.x & 32767u) << uint(1)), float((_1095.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1100.x += (3.0517578125e-05 * ((2.0 * float((_1095.x & 32768u) >> uint(15))) - 1.0));
    _1100.y += (3.0517578125e-05 * ((2.0 * float((_1095.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _1163 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1156 = _1163;
    v_clipPosition = _1075;
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(notEqual((_1163 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _1006) / _920.z) + RenderChunkFogAlpha.x) - _920.x) / (_920.y - _920.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1156.y >> 4u, _1156.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1100;
    v_worldPos = _832;
    v_worldPosition = vec4(_831.xyz, 0.0);
    gl_Position = _1075;
}

