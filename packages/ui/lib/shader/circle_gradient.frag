#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float iTime;
uniform float isLightMode;

out vec4 fragColor;

#define S(a, b, t) smoothstep(a, b, t)

// Individual color constants instead of array
const vec3 colorA = vec3(0.109804, 0.376471, 0.909804); // 0x1c60e8
const vec3 colorB = vec3(0.117647, 0.243137, 0.878431); // 0x1e3ee0  
const vec3 colorC = vec3(0.117647, 0.243137, 0.878431); // 0x1e3ee0
const vec3 colorD = vec3(0.117647, 0.878431, 0.788235); // 0x1ee0c9

float blur = .4;
float radius = .05;
vec2 center = vec2(.5);

float variation(vec2 v1, vec2 v2, float strength, float speed) {
	return sin(
        dot(normalize(v1), normalize(v2)) * strength + iTime * speed
    ) / 200.0;
}

float paintCircle(vec2 uv, vec2 center, float rad, float  blur) {
    vec2 diff = (center - uv) / (min(uSize.x, uSize.y) * 0.001) * vec2(uSize.x / uSize.y, 1.0);
    float len = length(diff);

    len += variation(diff, vec2(0.0, 1.0), 5.0, 2.0);
    len -= variation(diff, vec2(1.0, 0.0), 5.0, 2.0);
    
    float circle = smoothstep(rad, rad + blur, len);
    return circle;
}

mat2 Rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(2127.1, 81.17)), dot(p, vec2(1269.5, 283.37)));
	return fract(sin(p) * 43758.5453);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
	
	vec2 u = f * f * (3.0 - 2.0 * f);

    float n = mix(
                mix(
                    dot(-1.0 + 2.0 * hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)), 
                    dot(-1.0 + 2.0 * hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), 
                    u.x
                ),
                mix(
                    dot(-1.0 + 2.0 * hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)), 
                    dot(-1.0 + 2.0 * hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), 
                    u.x
                ), 
                u.y
            );
	return 0.5 * (n + 1.0);
}

vec3 gradient(in vec2 uv) {
    float ratio = uv.x / uv.y;

    vec2 tuv = uv;

    // rotate with Noise
    float degree = noise(vec2(iTime * .1, tuv.x * tuv.y));

    tuv.y *= 1. / ratio;
    tuv *= Rot(radians((degree - .5) * 720. + 180.));
	tuv.y *= ratio;

    
    // Wave warp with sin
    float frequency = 100.;
    float amplitude = 30.;
    float speed = iTime * 2.;
    tuv.y += sin(tuv.y * frequency + speed) / amplitude;
   	tuv.x += sin(tuv.x * frequency * 1.5 + speed) / (amplitude * .5);
    
    // draw the image
    vec3 layer1 = mix(
        colorA, 
        colorB, 
        S(-.3, .2, (tuv * Rot(radians(-5.))).x)
    );
    vec3 layer2 = mix(
        colorC, 
        colorD, 
        S(-.3, .2, (tuv * Rot(radians(-5.))).x)
    );
    vec3 finalComp = mix(layer1, layer2, S(.1, -.5, tuv.y));
    
    return finalComp;
}

void main() {
	vec2 uv = FlutterFragCoord() / uSize;

    // Set background color based on light/dark mode
    vec3 bgColor = isLightMode > 0.5 ? vec3(0.9490196, 0.9686274, 0.9686274) : vec3(0.101961, 0.121569, 0.133333); // 0x1a1f22

    vec3 color = gradient(uv);
    float circle = paintCircle(uv, center, radius, blur);
    color = mix(color, bgColor, circle);

	fragColor = vec4(color, 1.0);
}
