#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;

#define PI 3.14159265359

#define TRANSPARENT vec4(0.0, 0.0, 0.0, 0.0)

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

out vec4 fragColor;

void main(){

    vec2 uv = FlutterFragCoord().xy / uSize;
        
    float mag=distance(uv,vec2(0.5));
    
    float saturation=2.*mag; //goes from 0 to 1
    
    vec2 position=vec2(0.5)-uv; //goes from -0.5 to 0.5
        
    float a=atan(position.y,position.x); // goes from -pi to pi
    
    float hue=(a+PI)/(2.*PI); // from 0 to 1
    
    fragColor = mag>0.5 ? TRANSPARENT:vec4(hsv2rgb(vec3(hue,saturation*saturation,1.0)),1.0);

}