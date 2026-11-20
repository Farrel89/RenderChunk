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
    vec4 _616 = u_model[0] * vec4(a_position, 1.0);
    vec3 _617 = _616.xyz;
    vec4 _669 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _772 = u_proj;
    vec4 _739 = _772[2];
    _739.x += SubPixelOffset.x;
    _739.y -= SubPixelOffset.y;
    mat4 _781 = u_proj;
    _781[2] = _739;
    uvec2 _791 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _796 = vec2(float((_791.x & 32767u) << uint(1)), float((_791.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _796.x += (3.0517578125e-05 * ((2.0 * float((_791.x & 32768u) >> uint(15))) - 1.0));
    _796.y += (3.0517578125e-05 * ((2.0 * float((_791.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(0.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _617) / _669.z) + RenderChunkFogAlpha.x) - _669.x) / (_669.y - _669.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = _796;
    v_worldPos = _617;
    gl_Position = _781 * (u_view * vec4(_616.xyz, 1.0));
}

