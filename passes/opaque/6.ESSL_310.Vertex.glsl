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
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;

void main()
{
    vec4 _712 = u_model[0] * vec4(a_position, 1.0);
    vec3 _713 = _712.xyz;
    vec4 _765 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _868 = u_proj;
    vec4 _835 = _868[2];
    _835.x += SubPixelOffset.x;
    _835.y -= SubPixelOffset.y;
    mat4 _877 = u_proj;
    _877[2] = _835;
    uvec2 _887 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _892 = vec2(float((_887.x & 32767u) << uint(1)), float((_887.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _892.x += (3.0517578125e-05 * ((2.0 * float((_887.x & 32768u) >> uint(15))) - 1.0));
    _892.y += (3.0517578125e-05 * ((2.0 * float((_887.y & 32768u) >> uint(15))) - 1.0));
    uvec2 _955 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 _948 = _955;
    v_color0 = a_color0;
    v_ditheringAndMaskTinting = vec2(notEqual((_955 & uvec2(256u)), uvec2(0u)));
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _713) / _765.z) + RenderChunkFogAlpha.x) - _765.x) / (_765.y - _765.x), 0.0, 1.0));
    v_lightmapUV = vec2(uvec2(_948.y >> 4u, _948.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_texcoord0 = _892;
    v_worldPos = _713;
    gl_Position = _877 * (u_view * vec4(_712.xyz, 1.0));
}

