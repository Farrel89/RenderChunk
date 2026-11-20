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
    vec3 _679 = (u_model[0] * vec4(a_position, 1.0)).xyz;
    vec3 _789 = _679 + vec3(0.5);
    vec3 _796 = normalize(_789 - ViewPositionAndTime.xyz);
    vec3 _799 = normalize(cross(vec3(0.0, 1.0, 0.0), _796));
    vec3 _786 = a_color0.xyz;
    vec3 _819 = _789 - ((cross(_796, _799) * (_786.z - 0.5)) + (_799 * (_786.x - 0.5)));
    vec4 _733 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _889 = u_proj;
    vec4 _856 = _889[2];
    _856.x += SubPixelOffset.x;
    _856.y -= SubPixelOffset.y;
    mat4 _898 = u_proj;
    _898[2] = _856;
    uvec2 _908 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 _913 = vec2(float((_908.x & 32767u) << uint(1)), float((_908.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _913.x += (3.0517578125e-05 * ((2.0 * float((_908.x & 32768u) >> uint(15))) - 1.0));
    _913.y += (3.0517578125e-05 * ((2.0 * float((_908.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _819) / _733.z) + RenderChunkFogAlpha.x) - _733.x) / (_733.y - _733.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = _913;
    v_worldPos = _679;
    gl_Position = _898 * (u_view * vec4(_819, 1.0));
}

