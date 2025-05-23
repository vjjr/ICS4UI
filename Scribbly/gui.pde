/**
 * GUI Component
 * Handles all graphical user interface elements of the paint application.
 * Uses G4P library for creating and managing UI controls.
 */

// Main control window and UI elements
GWindow controlsWindow;              // Window for all controls
GSlider redSlider, greenSlider, blueSlider, penSizeSlider;  // Color and size controls
GButton setColorButton;              // Button to apply selected color
GButton saveButton;                  // Button to save canvas
GTextField filenameField;            // Input field for save filename
GSlider eraserSizeSlider;           // Control for eraser size
GDropList toolDropList;              // Tool selection dropdown

/**
 * Creates and initializes all GUI elements
 * Sets up the control window with all necessary UI components
 */
public void createGUI() {
  controlsWindow = GWindow.getWindow(this, "Paint Controls", 0, 0, 360, 450, JAVA2D);
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "drawControlsWindow");

  // === TOOL DROPDOWN ===
  toolDropList = new GDropList(controlsWindow, 10, 180, 150, 120);
  toolDropList.setItems(new String[] {"Pen", "Eraser", "Rectangle", "Circle", "Triangle"}, 0);
  toolDropList.addEventHandler(this, "handleToolSelect");

  // === PEN SIZE SLIDER ===
  GLabel penSizeLabel = new GLabel(controlsWindow, 10, 215, 100, 20);
  penSizeLabel.setText("Pen Size:");
  penSizeLabel.setOpaque(false);

  penSizeSlider = new GSlider(controlsWindow, 110, 215, 100, 20, 10);
  penSizeSlider.setLimits(3, 1, 50); // default = 3, min = 1, max = 50
  penSizeSlider.setShowValue(true);
  penSizeSlider.setNumberFormat(G4P.INTEGER, 0);
  penSizeSlider.setShowTicks(true);
  penSizeSlider.setNbrTicks(5);
  penSizeSlider.setEasing(6.5);
  penSizeSlider.setOpaque(true);
  penSizeSlider.setTextOrientation(G4P.ORIENT_LEFT);

  // === RGB SLIDERS ===
  GLabel redLabel = new GLabel(controlsWindow, 10, 240, 20, 20);
  redLabel.setText("R:");
  redLabel.setOpaque(false);

  GLabel greenLabel = new GLabel(controlsWindow, 10, 265, 20, 20);
  greenLabel.setText("G:");
  greenLabel.setOpaque(false);

  GLabel blueLabel = new GLabel(controlsWindow, 10, 290, 20, 20);
  blueLabel.setText("B:");
  blueLabel.setOpaque(false);

  redSlider = new GSlider(controlsWindow, 30, 240, 180, 20, 10);
  redSlider.setLimits(128, 0, 255); // default = 128, range 0–255
  redSlider.setShowValue(true);
  redSlider.setNumberFormat(G4P.INTEGER, 0);
  redSlider.setShowTicks(true);
  redSlider.setNbrTicks(5);
  redSlider.setEasing(6.5);
  redSlider.setOpaque(true);
  redSlider.setTextOrientation(G4P.ORIENT_LEFT);

  greenSlider = new GSlider(controlsWindow, 30, 265, 180, 20, 10);
  greenSlider.setLimits(128, 0, 255);
  greenSlider.setShowValue(true);
  greenSlider.setNumberFormat(G4P.INTEGER, 0);
  greenSlider.setShowTicks(true);
  greenSlider.setNbrTicks(5);
  greenSlider.setEasing(6.5);
  greenSlider.setOpaque(true);
  greenSlider.setTextOrientation(G4P.ORIENT_LEFT);

  blueSlider = new GSlider(controlsWindow, 30, 290, 180, 20, 10);
  blueSlider.setLimits(128, 0, 255);
  blueSlider.setShowValue(true);
  blueSlider.setNumberFormat(G4P.INTEGER, 0);
  blueSlider.setShowTicks(true);
  blueSlider.setNbrTicks(5);
  blueSlider.setEasing(6.5);
  blueSlider.setOpaque(true);
  blueSlider.setTextOrientation(G4P.ORIENT_LEFT);

  setColorButton = new GButton(controlsWindow, 220, 275, 120, 30);
  setColorButton.setText("Set Color");
  setColorButton.addEventHandler(this, "handleSetPenColor");

  GLabel eraserSizeLabel = new GLabel(controlsWindow, 10, 320, 100, 20);
  eraserSizeLabel.setText("Eraser Size:");
  eraserSizeLabel.setOpaque(false);

  eraserSizeSlider = new GSlider(controlsWindow, 110, 320, 100, 20, 10);
  eraserSizeSlider.setLimits(20, 1, 100); // default = 20, min = 1, max = 100
  eraserSizeSlider.setShowValue(true);
  eraserSizeSlider.setNumberFormat(G4P.INTEGER, 0);
  eraserSizeSlider.setShowTicks(true);
  eraserSizeSlider.setNbrTicks(5);
  eraserSizeSlider.setEasing(6.5);
  eraserSizeSlider.setOpaque(true);
  eraserSizeSlider.setTextOrientation(G4P.ORIENT_LEFT);

  // === FILENAME INPUT FIELD ===
  GLabel filenameLabel = new GLabel(controlsWindow, 10, 360, 100, 20);
  filenameLabel.setText("Filename:");
  filenameLabel.setOpaque(false);

  filenameField = new GTextField(controlsWindow, 10, 380, 340, 25);
  filenameField.setPromptText("Enter filename (without .png)");

  // === SAVE BUTTON ===
  saveButton = new GButton(controlsWindow, 10, 410, 340, 30);
  saveButton.setText("Save Canvas");
  saveButton.addEventHandler(this, "handleSaveCanvas");
}

/**
 * Draws the control window contents
 * Handles the color palette grid and RGB preview
 * @param appc PApplet context for drawing
 * @param data Window data
 */
synchronized public void drawControlsWindow(PApplet appc, GWinData data) {
  appc.background(230); // light gray background
  appc.noStroke();

  // === PALETTE BUTTON GRID ===
  int cols = 8;
  int buttonSize = 25;
  int padding = 5;
  int startX = 10;
  int startY = 10;
  int buttonX = startX;
  int buttonY = startY;

  color[] paletteColors = canvas.getColors().getPaletteColors();

  for (int i = 0; i < paletteColors.length; i++) {
    appc.fill(paletteColors[i]);
    appc.rect(buttonX, buttonY, buttonSize, buttonSize);

    buttonX += buttonSize + padding;
    if ((i + 1) % cols == 0) {
      buttonX = startX;
      buttonY += buttonSize + padding;
    }
  }

  // check if user clicked inside grid
  if (
    appc.mousePressed &&
    appc.mouseX > startX &&
    appc.mouseX < (startX + cols * (buttonSize + padding)) &&
    appc.mouseY > startY &&
    appc.mouseY < (startY + (paletteColors.length / cols + 1) * (buttonSize + padding))
  ) {
    int x = (appc.mouseX - startX) / (buttonSize + padding);
    int y = (appc.mouseY - startY) / (buttonSize + padding);
    int index = y * cols + x;
    canvas.getColors().setPenColorFromPalette(index);
  }

  // === RGB PREVIEW BOX ===
  int r = redSlider.getValueI();
  int g = greenSlider.getValueI();
  int b = blueSlider.getValueI();
  color previewColor = color(r, g, b);

  appc.stroke(0);
  appc.strokeWeight(1);
  appc.fill(previewColor);
  appc.rect(220, 240, 120, 30);
  appc.fill(0);
  appc.text("Preview", 255, 235);

  // update eraser size
  canvas.setEraserSize(eraserSizeSlider.getValueI());
}

/**
 * Event handler for the Set Color button
 * Updates the current pen color with the RGB slider values
 */
public void handleSetPenColor(GButton button, GEvent event) {
  if (button == setColorButton && event == GEvent.CLICKED) {
    canvas.getColors().setPenColor(
      redSlider.getValueI(),
      greenSlider.getValueI(),
      blueSlider.getValueI()
    );
    canvas.setEraserActive(false); // make sure you're not stuck in eraser mode
  }
}

/**
 * Event handler for the Save button
 * Saves the canvas as a PNG file with the specified filename
 */
public void handleSaveCanvas(GButton button, GEvent event) {
  if (button == saveButton && event == GEvent.CLICKED) {
    String filename = filenameField.getText();
    if (filename != null && !filename.trim().isEmpty()) {
      canvas.save(filename);
      filenameField.setText(""); // clear field after save
    } else {
      canvas.save(null); // fallback to default name
    }
  }
}

/**
 * Event handler for tool selection dropdown
 * Updates the current tool based on user selection
 */
public void handleToolSelect(GDropList list, GEvent event) {
  if (event == GEvent.SELECTED) {
    String selected = list.getSelectedText();

    if (selected.equals("Pen")) {
      canvas.setEraserActive(false);
      canvas.setCurrentTool("Pen");
    }

    else if (selected.equals("Eraser")) {
      canvas.setEraserActive(true);
      canvas.setCurrentTool("Eraser");
    }

    else if (selected.equals("Rectangle")) {
      canvas.setEraserActive(false);
      canvas.setShape("Rectangle");
      canvas.setCurrentTool("Shape");
    }

    else if (selected.equals("Circle")) {
      canvas.setEraserActive(false);
      canvas.setShape("Circle");
      canvas.setCurrentTool("Shape");
    }

    else if (selected.equals("Triangle")) {
      canvas.setEraserActive(false);
      canvas.setShape("Triangle");
      canvas.setCurrentTool("Shape");
    }
  }
}
