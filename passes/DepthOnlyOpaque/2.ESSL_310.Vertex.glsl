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
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;

void main()
{
    vec3 _673 = (u_model[0] * vec4(a_position, 1.0)).xyz;
    vec3 _783 = _673 + vec3(0.5);
    vec3 _790 = normalize(_783 - ViewPositionAndTime.xyz);
    vec3 _793 = normalize(cross(vec3(0.0, 1.0, 0.0), _790));
    vec3 _780 = a_color0.xyz;
    vec3 _813 = _783 - ((cross(_790, _793) * (_780.z - 0.5)) + (_793 * (_780.x - 0.5)));
    vec4 _727 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 _883 = u_proj;
    vec4 _850 = _883[2];
    _850.x += SubPixelOffset.x;
    _850.y -= SubPixelOffset.y;
    mat4 _892 = u_proj;
    _892[2] = _850;
    vec2 _911 = round(vec2(0.0));
    uvec2 _902 = uvec2(_911);
    vec2 _907 = vec2(float((_902.x & 32767u) << uint(1)), float((_902.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    _907.x += (3.0517578125e-05 * ((2.0 * float((_902.x & 32768u) >> uint(15))) - 1.0));
    _907.y += (3.0517578125e-05 * ((2.0 * float((_902.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - _813) / _727.z) + RenderChunkFogAlpha.x) - _727.x) / (_727.y - _727.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = _907;
    v_worldPos = _673;
    gl_Position = _892 * (u_view * vec4(_813, 1.0));
}

