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
    vec4 _769 = u_model[0] * vec4(a_position, 1.0);
    vec3 _770 = _769.xyz;
    vec4 _856 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _959 = u_proj;
    vec4 _926 = _959[2];
    _926.x += SubPixelOffset.x;
    _926.y -= SubPixelOffset.y;
    mat4 _968 = u_proj;
    _968[2] = _926;
    vec4 _958 = _968 * (u_view * vec4(_769.xyz, 1.0));
    uvec2 _978 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _983 = vec2(float((_978.x & 32767u) << uint(1)), float((_978.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _983.x += (3.0517578125e-05 * ((2.0 * float((_978.x & 32768u) >> uint(15))) - 1.0));
    _983.y += (3.0517578125e-05 * ((2.0 * float((_978.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _1046 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _1039 = _1046;
    v_clipPosition = _958;
    v_color0 = a_color0;
    v_ditheringAndMaskTinting = vec2(notEqual((_1046 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _770) / _856.z) + RenderChunkFogAlpha.x) - _856.x) / (_856.y - _856.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_1039.y >> 4u, _1039.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _983;
    v_worldPos = _770;
    v_worldPosition = vec4(_769.xyz, 0.0);
    gl_Position = _958;
}

