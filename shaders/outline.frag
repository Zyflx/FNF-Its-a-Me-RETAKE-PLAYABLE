#pragma header

uniform bool enabled;
uniform vec3 outlineColor;

void main(void) {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

    if(!enabled) {
        gl_FragColor = color;
        return;
    }

    vec4 replaceColor = vec4(0., 0., 0., 1.);
    float dist = distance(color.rgb, replaceColor.rgb);
    float alpha = smoothstep(0., .1, dist);
    vec4 newColor = mix(vec4(outlineColor, 1.), replaceColor, alpha) * color.a;

    gl_FragColor = newColor;
}