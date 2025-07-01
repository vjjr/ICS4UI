/*
 * GUI Implementation for Sorting Algorithm Visualizer
 * This file handles all user interface elements and interactions
 * Features:
 * - Control panel with algorithm selection
 * - Animation speed control
 * - Card count adjustment
 * - Play/Pause/Reset controls
 */

// GUI Components
GWindow window1;        // Main control window
GButton pauseB;         // Play/Pause button
GButton resetB;         // Reset button
GDropList sortingType1; // Top algorithm selector
GDropList sortingType2; // Bottom algorithm selector
GLabel algoLabel2;      // Bottom algorithm label
GSlider numCards;       // Card count slider
GSlider speedSlider;    // Animation speed slider
GLabel title;           // Window title
GLabel algoLabel1;      // Top algorithm label
GLabel cardsLabel;      // Card count label
GLabel speedLabel;      // Speed control label

// Constants
final String[] SORTING_ALGORITHMS = {"Bubble Sort", "Insertion Sort", "Selection Sort"};

// Window state
boolean isWindowInitialized = false;

/**
 * Draws the control panel window background
 */
synchronized public void win_draw1(PApplet appc, GWinData data) {
  appc.background(240);
}

/**
 * Handles play/pause button clicks
 * Toggles animation state and updates button appearance
 */
public void pauseBClicked(GButton source, GEvent event) {
  isPaused = !isPaused;                                              
  if (isPaused) {                                                    
    source.setText("Resume");                                     
    source.setLocalColorScheme(GCScheme.GREEN_SCHEME);            
  } else {                                                         
    source.setText("Pause");                                     
    source.setLocalColorScheme(GCScheme.RED_SCHEME);             
  }                                                               
}

/**
 * Handles reset button clicks
 * Resets the simulation to initial state
 */
public void resetBClicked(GButton source, GEvent event) {
  isPaused = true;
  pauseB.setText("Start");
  pauseB.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  initializeSimulation();
}

/**
 * Handles animation speed slider changes
 * Converts slider value to animation speed
 */
public void speedSliderChanged(GSlider source, GEvent event) {
  // Convert slider value (0-100) to animation speed (1-10) and cast to int
  animationSpeed = (int)map(source.getValueI(), 0, 100, 1, 10);
}

/**
 * Handles top algorithm selection changes
 * Updates algorithm and resets simulation
 */
public void sortingType1Changed(GDropList source, GEvent event) {
  int idx = source.getSelectedIndex();
  if (idx >= 0 && idx < SORTING_ALGORITHMS.length) {
    currentAlgorithm1 = SORTING_ALGORITHMS[idx];
    isPaused = true;
    pauseB.setText("Start");
    pauseB.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    initializeSimulation();
  }
}

/**
 * Handles bottom algorithm selection changes
 * Updates algorithm and resets simulation
 */
public void sortingType2Changed(GDropList source, GEvent event) {
  int idx = source.getSelectedIndex();
  if (idx >= 0 && idx < SORTING_ALGORITHMS.length) {
    currentAlgorithm2 = SORTING_ALGORITHMS[idx];
    isPaused = true;
    pauseB.setText("Start");
    pauseB.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    initializeSimulation();
  }
}

/**
 * Handles card count slider changes
 * Updates number of cards and resets simulation
 */
public void numCardsChanged(GSlider source, GEvent event) {
  cardCount = source.getValueI();                                            
  isPaused = true;                                                      
  pauseB.setText("Start");                                            
  pauseB.setLocalColorScheme(GCScheme.GREEN_SCHEME);                   
  initializeSimulation();                                                             
}

/**
 * Creates and initializes the GUI
 * Sets up all controls and their event handlers
 */
public void createGUI() {
  // Initialize GUI settings
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sorting Algorithm Visualizer");
  
  // Create control panel window
  window1 = GWindow.getWindow(this, "Controls", 1650, 0, 400, 600, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw1");
  
  // Create and configure all GUI elements
  createTitle();
  createControlButtons();
  createAlgorithmSelectors();
  createCardControls();
  createSpeedControl();
  
  window1.loop();
}

/**
 * Creates the window title
 */
private void createTitle() {
  title = new GLabel(window1, 20, 20, 360, 40);
  title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  title.setText("Sorting Algorithm Visualizer");
  title.setOpaque(false);
}

/**
 * Creates play/pause and reset buttons
 */
private void createControlButtons() {
  pauseB = new GButton(window1, 20, 80, 360, 40);
  pauseB.setText("Start");
  pauseB.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  pauseB.addEventHandler(this, "pauseBClicked");
  
  resetB = new GButton(window1, 20, 130, 360, 40);
  resetB.setText("Reset");
  resetB.setLocalColorScheme(GCScheme.RED_SCHEME);
  resetB.addEventHandler(this, "resetBClicked");
}

/**
 * Creates algorithm selection dropdowns
 */
private void createAlgorithmSelectors() {
  // Top algorithm selector
  algoLabel1 = new GLabel(window1, 20, 190, 360, 30);
  algoLabel1.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  algoLabel1.setText("Top Algorithm:");
  algoLabel1.setOpaque(false);
  
  sortingType1 = new GDropList(window1, 20, 230, 360, 200, 3, 10);
  sortingType1.setItems(SORTING_ALGORITHMS, 2);
  sortingType1.addEventHandler(this, "sortingType1Changed");
  
  // Bottom algorithm selector
  algoLabel2 = new GLabel(window1, 20, 290, 360, 30);
  algoLabel2.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  algoLabel2.setText("Bottom Algorithm:");
  algoLabel2.setOpaque(false);
  
  sortingType2 = new GDropList(window1, 20, 330, 360, 200, 3, 10);
  sortingType2.setItems(SORTING_ALGORITHMS, 1);
  sortingType2.addEventHandler(this, "sortingType2Changed");
}

/**
 * Creates card count control
 */
private void createCardControls() {
  cardsLabel = new GLabel(window1, 20, 390, 360, 30);
  cardsLabel.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  cardsLabel.setText("Number of Cards:");
  cardsLabel.setOpaque(false);
  
  numCards = new GSlider(window1, 20, 430, 360, 40, 10);
  numCards.setLimits(8, 0, 16);
  numCards.setShowValue(true);
  numCards.setShowLimits(true);
  numCards.setNumberFormat(G4P.INTEGER, 0);
  numCards.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  numCards.addEventHandler(this, "numCardsChanged");
}

/**
 * Creates animation speed control
 */
private void createSpeedControl() {
  speedLabel = new GLabel(window1, 20, 480, 360, 30);
  speedLabel.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  speedLabel.setText("Animation Speed:");
  speedLabel.setOpaque(false);
  
  speedSlider = new GSlider(window1, 20, 520, 360, 40, 10);
  speedSlider.setLimits(50, 0, 100); // Default to middle speed
  speedSlider.setShowValue(true);
  speedSlider.setShowLimits(true);
  speedSlider.setNumberFormat(G4P.INTEGER, 0);
  speedSlider.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  speedSlider.addEventHandler(this, "speedSliderChanged");
} 