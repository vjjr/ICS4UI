/**
 * Scribbly
 * A simple painting application built with Processing that allows users to draw,
 * create shapes, and manipulate them with various tools.
 */

import g4p_controls.*;  // Import GUI library for controls
Canvas canvas;         // Main canvas object that handles drawing

/**
 * Setup function - runs once at the start
 * Initializes the canvas and GUI components
 */
void setup() {
  size(600, 600);                    // Set window size
  canvas = new Canvas(600, 600);     // Create main canvas
  createGUI();                       // Initialize GUI controls
  surface.setTitle("Paint");         // Set window title
}

/**
 * Draw function - runs every frame
 * Updates the canvas with current pen size and redraws
 */
void draw() {
  if (canvas != null && penSizeSlider != null) {
    canvas.setStrokeSize(penSizeSlider.getValueI());
    canvas.draw();
  }
}

/**
 * Key event handler
 * Currently only handles canvas clearing with 'c' key
 */
void keyPressed() {
  if (key == 'c' || key == 'C') {
    canvas.clear();  // Clear canvas when 'c' is pressed
  }
}
