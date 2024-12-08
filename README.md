# Realm of Uz Text Effects

![A demo image for the effects currently supported.](https://github.com/user-attachments/assets/8bbfb9dd-7762-4ec4-9196-23d75ce404ca)

A simple shader system for adding text shaders to Minecraft using a font.

The shaders work by very faintly coloring an entire font (separated by width so the background can be covered too without changing character width), and checking that in the text shader.
The provided implementations support only ASCII in the default Minecraft font. To make this work with your own font and/or a larger character set, you will need to make your own font implementation. This is the downside to this system, but the upside is you can use any color you want, and, for effects that use color, pass color as a parameter for various purposes.

The speed of periodic functions can be modified in `minecraft:shaders/core/rendertype_text.json`, though their units are not consistent.

## Currently supported effects:
- `rgb(255, 242, 242)`: Wave - Moves each character up and down on a sine wave.
- `rgb(242, 255, 242)`: Shake - Moves each character randomly using a noise function.
- `rgb(242, 242, 255)`: Rainbow/Gradient - If the text color is grayscale, color each character with a shifting rainbow multiplied by that color. Otherwise, create a white "shine" gradient that moves across the text.
- `rgb(242, 255, 255)`: Two-color - Moves the shadow so it overlaps with the text. Renders each pixel on the text if it is fully opaque and on the shadow otherwise, allowing you to use two colors at the same time by changing the text color and shadow color.

## Included implementation fonts:
- `text_effects:wave`: Implements Wave for ASCII in the default Minecraft font.
- `text_effects:shake`: Implements Shake for ASCII in the default Minecraft font.
- `text_effects:rainbow`: Implements Rainbow/Gradient for ASCII in the default Minecraft font.

## Known issues:
- Signs work, but use different units for position, so currently cause characters to fly off the sign.
- Effects that move characters do not work very well with bold text. I do not plan to fix this.
