/**
 * Colors Class
 * Manages the color palette and current pen color for the paint application.
 * Provides a predefined set of colors and methods to manipulate them.
 */
class Colors {
  color[] paletteColors;  // Array to store the color palette
  color penColor;         // Current selected pen color
  
  /**
   * Constructor - initializes the color palette with predefined colors
   * Colors include a range of hues, shades, and basic colors
   */
  Colors() {
    // Define palette with pixel-art friendly colors
    paletteColors = new color[] {
      #000000, #222034, #323c39, #3f3f74, #306082, #5b6ee1, #639bff, #5fcde4,  // Blues and dark tones
      #4b692f, #37946e, #6abe30, #99e550, #8f974a,                              // Greens
      #595652, #696a6a, #847e87, #9badb7, #cbdbfc,                              // Grays
      #663931, #45283c, #8f563b, #df7126, #d9a066, #eec39a,                    // Browns and skin tones
      #fbf236, #d95763, #d77bba, #76428a, #ac3232, #8a6f30,                    // Vibrant colors
      #ffffff                                                                    // White
    };
    penColor = color(0); // Initialize with black
  }
  
  /**
   * Sets the pen color using RGB values
   * @param r Red component (0-255)
   * @param g Green component (0-255)
   * @param b Blue component (0-255)
   */
  void setPenColor(int r, int g, int b) {
    penColor = color(r, g, b);
  }
  
  /**
   * Returns the current pen color
   * @return Current pen color as Processing color type
   */
  color getPenColor() {
    return penColor;
  }
  
  /**
   * Returns the array of palette colors
   * @return Array of predefined palette colors
   */
  color[] getPaletteColors() {
    return paletteColors;
  }
  
  /**
   * Sets the pen color from the palette using an index
   * @param index Index of the color in the palette array
   */
  void setPenColorFromPalette(int index) {
    if (index >= 0 && index < paletteColors.length) {
      penColor = paletteColors[index];
    }
  }
}
