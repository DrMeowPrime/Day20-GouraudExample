#version 300 es

/* Assignment 5: Artistic Rendering
 * Original C++ implementation by UMN CSCI 4611 Instructors, 2012+
 * GopherGfx implementation by Evan Suma Rosenberg <suma@umn.edu>, 2022-2024
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * PUBLIC DISTRIBUTION OF SOURCE CODE OUTSIDE OF CSCI 4611 IS PROHIBITED
 */ 

precision mediump float;

// constants used to indicate the type of each light
#define POINT_LIGHT 0
#define DIRECTIONAL_LIGHT 1

// max number of simultaneous lights handled by this shader
const int MAX_LIGHTS = 8;


// INPUT FROM UNIFORMS SET WITHIN THE MAIN APPLICATION

// Transforms points and vectors from Model Space to World Space (modelToWorld)
uniform mat4 modelMatrix;
// Special version of the modelMatrix to use with normal vectors
uniform mat4 normalMatrix;
// Transforms points and vectors from World Space to View Space (a.k.a. Eye Space) (worldToView) 
uniform mat4 viewMatrix;
// Transforms points and vectors from View Space to Normalized Device Coordinates (viewToNDC)
uniform mat4 projectionMatrix;

// position of the camera in world coordinates
uniform vec3 eyePositionWorld;

// properties of the lights in the scene
uniform int numLights;
uniform int lightTypes[MAX_LIGHTS];
uniform vec3 lightPositionsWorld[MAX_LIGHTS];
uniform vec3 lightAmbientIntensities[MAX_LIGHTS];
uniform vec3 lightDiffuseIntensities[MAX_LIGHTS];
uniform vec3 lightSpecularIntensities[MAX_LIGHTS];

// material properties (coefficents of reflection)
uniform vec3 kAmbient;
uniform vec3 kDiffuse;
uniform vec3 kSpecular;
uniform float shininess;


// INPUT FROM THE MESH WE ARE RENDERING WITH THIS SHADER

// per-vertex data, points and vectors are defined in Model Space
in vec3 positionModel;
in vec3 normalModel;
in vec4 color;
in vec2 texCoords;


// OUTPUT TO RASTERIZER TO INTERPOLATE ACROSS TRIANGLES AND SEND TO FRAGMENT SHADERS

out vec4 interpColor;
out vec2 interpTexCoords;


void main()  {
    // PART 2.0: In class example
    vec4 positionModel4 = vec4(positionModel, 1);
    vec4 positionWorld = modelMatrix * positionModel4;
    vec4 normalWorld = normalMatrix * vec4(normalModel, 0);
    vec4 positionView = viewMatrix * positionWorld;

    // Required: compute the vertex position in clip coordinates
   
    vec3 illumination = vec3(0,0,0);
    for (int i = 0; i < numLights; i++) {
        // add in the ambient component
        illumination += kAmbient * lightAmbientIntensities[i];

        vec3 lWorld;
        // add in the diffuse component
        // n dot l
        if (lightTypes[i] == DIRECTIONAL_LIGHT) {
            lWorld = normalize(lightPositionsWorld[i]);
        } else {    
            lWorld = normalize(lightPositionsWorld[i] - positionWorld.xyz); // positionWorld.xyz is called "Swizzling", choosing what you want from it
        }        
        float diffuseIntesity = max(dot(normalWorld.xyz, lWorld), 0.0);
        illumination += kDiffuse * lightDiffuseIntensities[i] * diffuseIntesity;

        // add in the specular component
        vec3 eWorld = normalize(eyePositionWorld - positionModel);
        vec3 rWorld = reflect(-lWorld, normalWorld.xyz);
        float specularIntensity = pow(max(dot(eWorld, rWorld), 0.0), shininess);
        illumination += kSpecular * lightSpecularIntensities[i] * specularIntensity;

    }

    interpColor = vec4(illumination, 1);
    interpTexCoords = texCoords;

     // gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1); // this is to screen space
    gl_Position = projectionMatrix * positionView;
}
