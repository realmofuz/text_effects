#version 150

#moj_import <minecraft:fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;

uniform float WaveFrequency;
uniform float ShakeFrequency;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
flat out int effect;
out vec3 screenPos;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
  vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

void main() {
    effect = 0;
    vec3 font_color = texture(Sampler0, UV0).rgb; //checks 
    if(font_color == vec3(1.0, 242.0/255.0, 242.0/255.0)) effect = 1; // wave
    if(font_color == vec3(242.0/255.0, 1.0, 242.0/255.0)) effect = 2; // shake
    if(font_color == vec3(242.0/255.0, 242.0/255.0, 1.0)) effect = 3; // rainbow/gradient
    if(font_color == vec3(242.0/255.0, 1.0, 1.0)) effect = 4; // two-color

    vec3 vertex_pos = Position;
    int character = gl_VertexID/4;

    if(effect == 1) vertex_pos += vec3(0.,2.*sin((character+GameTime*WaveFrequency)/15.),0.);
    if(effect == 2) vertex_pos += vec3(1.5*noise(vec2(GameTime*ShakeFrequency,character)),1.5*noise(vec2(character,GameTime*ShakeFrequency)),0.);
    if(effect == 4 && fract(vertex_pos.z) < 0.01) vertex_pos -= vec3(1.,1.,0.);

    screenPos = vertex_pos;
    gl_Position = ProjMat * ModelViewMat * vec4(vertex_pos, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
}
