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
    vec4 _849 = u_model[0] * vec4(a_position, 1.0);
    vec3 _850 = _849.xyz;
    vec4 _1574 = a_color0;
    vec3 _1013 = _850 + vec3(0.5);
    vec3 _1020 = normalize(_1013 - ViewPositionAndTime.xyz);
    vec3 _1023 = normalize(cross(vec3(0.0, 1.0, 0.0), _1020));
    vec3 _1010 = a_color0.xyz;
    vec3 _1043 = _1013 - ((cross(_1020, _1023) * (_1010.z - 0.5)) + (_1023 * (_1010.x - 0.5)));
    float _978 = length(ViewPositionAndTime.xyz - _1043);
    vec4 _957 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _1113 = u_proj;
    vec4 _1080 = _1113[2];
    _1080.x += SubPixelOffset.x;
    _1080.y -= SubPixelOffset.y;
    mat4 _1122 = u_proj;
    _1122[2] = _1080;
    vec4 _1112 = _1122 * (u_view * vec4(_1043, 1.0));
    uvec2 _1132 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _1137 = vec2(float((_1132.x & 32767u) << uint(1)), float((_1132.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _1137.x += (3.0517578125e-05 * ((2.0 * float((_1132.x & 32768u) >> uint(15))) - 1.0));
    _1137.y += (3.0517578125e-05 * ((2.0 * float((_1132.y & 32768u) >> uint(15))) - 1.0));
    vec4 _1358 = vec4(1.0);
    if (_1574.w < 0.949999988079071044921875)
    {
        vec4 _921 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
        _1358.w = mix(_1574.w, 1.0, clamp(_978 / _921.w, 0.0, 1.0));
    }
    uvec2 _1209 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1202 = _1209;
    v_clipPosition = _1112;
    v_color0 = _1358;
    v_ditheringAndMaskTinting = vec2(notEqual((_1209 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((_978 / _957.z) + RenderChunkFogAlpha.x) - _957.x) / (_957.y - _957.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1202.y >> 4u, _1202.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _1137;
    v_worldPos = _850;
    v_worldPosition = vec4(_849.xyz, 0.0);
    gl_Position = _1112;
}

