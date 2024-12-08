#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

uniform float RainbowFrequency;
uniform float GradientFrequency;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
flat in int effect;
in vec3 screenPos;

out vec4 fragColor;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    if(effect == 1 || effect == 2) color = vec4(vertexColor.rgb, color.a);
    else if(effect == 3) {
        vec3 newColor;
        if(vertexColor.r == vertexColor.g && vertexColor.g == vertexColor.b){
            newColor = hsv2rgb(vec3(screenPos.x/200.+fract(GameTime * RainbowFrequency), 1.0, 0.75)) * vertexColor.rgb;
        } else {
            newColor = mix(vertexColor.rgb, fract(screenPos.z)<0.01?vec3(0.5):vec3(1.0), pow(cos(6.283 * fract((screenPos.x+screenPos.y)/100.+GameTime*GradientFrequency))/2.0+0.5, 3));
        }
        if (color.a < 0.5) {
            discard;
        }
        color = vec4(newColor, 1.0);
    }
    else if(effect == 4) {
    	if(color.a < 0.1) discard;
	if(fract(screenPos.z)<0.01 && color.a == 1.0) discard;
	if(fract(screenPos.z)>=0.01 && color.a < 1.0) discard;
	color = vertexColor;
	color.a = 1.;
    }
    else color = color * vertexColor;

    color = color * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
