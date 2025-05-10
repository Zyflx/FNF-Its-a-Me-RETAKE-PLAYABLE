#pragma header

uniform bool enabled;
uniform vec3 outlineColor;

void main(void) {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

    if(!enabled) {
        gl_FragColor = color;
        return;
    }

    vec4 outline = vec4(outlineColor.rgb, 1.0);
    vec4 replace = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 newColor;

    if((color.r + color.g + color.b + color.a) == (replace.r + replace.g + replace.b + replace.a)) {
        newColor = outline;
    } else {
        newColor = replace;
    }

    gl_FragColor = vec4(newColor.rgb, color.a);
}