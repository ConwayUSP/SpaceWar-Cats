extern number percent;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(tex, texture_coords) * color;

    // Área que deve ficar cinza.
    // 0% = nenhuma área
    // 100% = imagem inteira
    float fill = percent;

    if (texture_coords.y >= fill) {
      float gray = dot(pixel.rgb, vec3(0.299, 0.287, 0.114));

      pixel.rgb = vec3(gray);
    }

    return pixel;
}