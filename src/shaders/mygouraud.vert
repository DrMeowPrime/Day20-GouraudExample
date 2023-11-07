#version 300 es

precision mediump float;

#define POINT_LIGHT 0
#define DIRECTIONAL_LIGHT 1

const int MAX_LIGHTS = 8;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform vec3 eyePosition;

uniform int numLights;
uniform int lightTypes[MAX_LIGHTS];
uniform vec3 lightPositions[MAX_LIGHTS];
uniform vec3 ambientIntensities[MAX_LIGHTS];
uniform vec3 diffuseIntensities[MAX_LIGHTS];
uniform vec3 specularIntensities[MAX_LIGHTS];

uniform vec3 kAmbient;
uniform vec3 kDiffuse;
uniform vec3 kSpecular;
uniform float shininess;

in vec3 position;
in vec3 normal;
in vec4 color;
in vec2 texCoord;

out vec4 vertColor;
out vec2 uv;

void main() 
{
    gl_Position = vec4(0,0,0,1);
}