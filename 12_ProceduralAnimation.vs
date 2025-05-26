#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;

uniform mat4 view;
uniform mat4 projection;
uniform mat4 model;  // <- ¡Esto es lo que recibes desde el programa!

uniform float time;
uniform float radius;
uniform float selfRotationSpeed;

mat4 rotateX(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat4(
        vec4(1.0, 0.0, 0.0, 0.0),
        vec4(0.0,  c, -s, 0.0),
        vec4(0.0,  s,  c, 0.0),
        vec4(0.0, 0.0, 0.0, 1.0)
    );
}

mat4 rotateY(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat4(
        vec4( c, 0.0, s, 0.0),
        vec4(0.0, 1.0, 0.0, 0.0),
        vec4(-s, 0.0, c, 0.0),
        vec4(0.0, 0.0, 0.0, 1.0)
    );
}

void main()
{
    // 1. Corregimos la orientación para estar horizontal
    mat4 orientationFix = rotateX(radians(-90.0));

    // 2. Rotación propia como planeta
    mat4 selfRotation = rotateY(time * selfRotationSpeed);

    // 3. Aplicamos rotaciones locales
    vec4 rotated = selfRotation * orientationFix * vec4(aPos, 1.0);

    // 4. Traslación circular en XZ (órbita)
    rotated.x += radius * cos(time);
    rotated.z += radius * sin(time);

    // 5. APLICAMOS transformaciones globales del CPU (modelo)
    vec4 worldPos = model * rotated;

    // 6. Transformación final
    gl_Position = projection * view * worldPos;

    TexCoords = aTexCoords;
}
