/*
 * Main program file for the Sorting Algorithm Visualizer
 * This program demonstrates different sorting algorithms using a card-based visualization
 * Features:
 * - Side-by-side comparison of two sorting algorithms
 * - Real-time visualization of sorting steps
 * - Performance metrics and operation counting
 * - Interactive controls for customization
 */

import g4p_controls.*;

// Algorithm selection variables
String currentAlgorithm1 = "Selection Sort";  // Top algorithm
String currentAlgorithm2 = "Insertion Sort";  // Bottom algorithm
boolean isPaused = false;  // Controls animation state

// Card configuration
int cardCount = 10;  // Default number of cards
int startX;  // Starting X position for cards
int startY;  // Starting Y position for cards

// Animation control variables
int currentStep2 = 0;  // Current step in bottom algorithm
int animationSpeed = 2;  // Animation speed multiplier
int frameCounter2 = 0;  // Frame counter for bottom animation
int operationCount2 = 0;  // Operation counter for bottom algorithm
int animationDelay = 2;  // Delay between animation frames

// Dynamic background element properties
float dynamicElementX;
float dynamicElementY;
float dynamicElementSpeedX = 0.8;
float dynamicElementSpeedY = 0.6;

// Card deck arrays
Card[] cardDeck1;  // Top deck
Card[] cardDeck2;  // Bottom deck
int[] cardNumbers;  // Array to store card values

// Animation state tracking for bottom algorithm
ArrayList<Integer> swapIndices2 = new ArrayList<Integer>();
ArrayList<Integer> targetIndices2 = new ArrayList<Integer>();
ArrayList<Integer> animationFrames2 = new ArrayList<Integer>();

// Simulation states
enum SimulationState { DEALING, FLIPPING, SORTING, DONE };
SimulationState currentSimulationState2;

// Animation indices
int dealCardIndex = 0;
int flipCardIndex2 = 0;
int animationTimer = 0;

// Top algorithm animation variables
int dealCardIndexTop = 0;
int flipCardIndexTop = 0;
int currentStepTop = 0;
int frameCounterTop = 0;
int operationCountTop = 0;
ArrayList<Integer> swapIndicesTop = new ArrayList<Integer>();
ArrayList<Integer> targetIndicesTop = new ArrayList<Integer>();
ArrayList<Integer> animationFramesTop = new ArrayList<Integer>();
SimulationState currentSimulationStateTop;

// State tracking
boolean isCleanedUp = false;
int[] initialCardValues;  // Stores initial card values for reset

// Color definitions for card states
color defaultColor = color(240, 240, 240);  // Default card color
color comparingColor = color(255, 255, 0);  // Color when comparing
color swappingColor = color(255, 50, 50);   // Color when swapping
color sortedColor = color(50, 255, 50);     // Color when sorted

void setup() {
  size(1600, 900);
  startY = (height/4)-75;
  createGUI();
  frameRate(60);
  
  currentSimulationStateTop = SimulationState.DEALING;
  currentSimulationState2 = SimulationState.DEALING;
  
  dynamicElementX = width / 2;
  dynamicElementY = height / 2;
  
  // Initialize arrays after cardCount is set
  cardDeck1 = new Card[cardCount];
  cardDeck2 = new Card[cardCount];
  cardNumbers = new int[cardCount];
  
  isPaused = true;
  pauseB.setText("Start");
  pauseB.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  
  initializeSimulation();
}

void draw() {
  if (!isPaused && !isCleanedUp) {
    background(255);
    renderBackground();
    
    if (currentSimulationStateTop != null && currentSimulationState2 != null) {
      // Draw top algorithm visualization
      pushMatrix();
      translate(0, 0);
      if (cardDeck1 != null) {
        if (currentSimulationStateTop == SimulationState.DEALING) {
          handleDealingAnimationTop();
        } else if (currentSimulationStateTop == SimulationState.FLIPPING) {
          handleFlippingAnimation(1);
        } else if (currentSimulationStateTop == SimulationState.SORTING) {
          displayCards(1);
          animateSwaps(1);
        } else if (currentSimulationStateTop == SimulationState.DONE) {
          displayCards(1);
        }
      }
      popMatrix();
      
      // Draw bottom algorithm visualization
      pushMatrix();
      translate(0, height/2);
      if (cardDeck2 != null) {
        for (int i = 0; i < cardCount; i++) {
          if (cardDeck2[i] != null) {
            cardDeck2[i].y = startY;
          }
        }
        if (currentSimulationState2 == SimulationState.DEALING) {
          handleDealingAnimation(2);
        } else if (currentSimulationState2 == SimulationState.FLIPPING) {
          handleFlippingAnimation(2);
        } else if (currentSimulationState2 == SimulationState.SORTING) {
          displayCards(2);
          animateSwaps(2);
        } else if (currentSimulationState2 == SimulationState.DONE) {
          displayCards(2);
        }
      }
      popMatrix();
    }
    
    showMetrics();
  }
  
  if (currentSimulationStateTop == SimulationState.DONE && 
      currentSimulationState2 == SimulationState.DONE) {
    displayDoneMessage();
  }
}

void renderBackground() {
  // Gradient background
  noStroke();
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(255, 255, 255), color(220, 230, 255), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  // Subtle grid pattern 
  stroke(240, 150);
  for (int i = 0; i < width; i += 50) {
    line(i, 0, i, height);
  }
  for (int i = 0; i < height; i += 50) {
    line(0, i, width, i);
  }
  
  // Dynamic glowing orb
  noStroke();
  fill(100, 150, 255, 80);
  ellipse(dynamicElementX, dynamicElementY, 150, 150);
  
  // Move the orb
  dynamicElementX += dynamicElementSpeedX;
  dynamicElementY += dynamicElementSpeedY;
  
  // Bounce off walls
  if (dynamicElementX < 0 || dynamicElementX > width) {
    dynamicElementSpeedX *= -1;
  }
  if (dynamicElementY < 0 || dynamicElementY > height) {
    dynamicElementSpeedY *= -1;
  }
}

void displayCards(int deckNum) {
  Card[] deck = (deckNum == 1) ? cardDeck1 : cardDeck2;
  if (deck != null) {
    for (int i = 0; i < cardCount; i++) {
      if (deck[i] != null) {
        deck[i].drawCard();
      }
    }
  }
}

void showMetrics() {
  // Draw stats for first algorithm
  fill(255, 230);
  stroke(180);
  strokeWeight(2);
  rect(20, 20, 400, 120, 15);
  
  fill(0);
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Algorithm 1: " + currentAlgorithm1, 40, 50);
  
  textSize(18);
  if (currentAlgorithm1.equals("Insertion Sort")) {
    text("Time Complexity: O(n²) worst, O(n) best", 40, 80);
  } else {
    text("Time Complexity: O(n²)", 40, 80);
  }
  text("Total Operations: " + operationCountTop, 40, 110);
  
  // Draw stats for second algorithm
  fill(255, 230);
  stroke(180);
  strokeWeight(2);
  rect(20, height/2 + 20, 400, 120, 15);
  
  fill(0);
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Algorithm 2: " + currentAlgorithm2, 40, height/2 + 50);
  
  textSize(18);
  if (currentAlgorithm2.equals("Insertion Sort")) {
    text("Time Complexity: O(n²) worst, O(n) best", 40, height/2 + 80);
  } else {
    text("Time Complexity: O(n²)", 40, height/2 + 80);
  }
  text("Total Operations: " + operationCount2, 40, height/2 + 110);
  
  // Draw current state
  fill(255, 230);
  stroke(180);
  strokeWeight(2);
  rect(width - 420, 20, 400, 120, 15);
  
  fill(0);
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Current State:", width - 400, 50);
  
  textSize(18);
  String state1 = "Top: " + getStateString(currentSimulationStateTop);
  String state2 = "Bottom: " + getStateString(currentSimulationState2);
  text(state1, width - 400, 80);
  text(state2, width - 400, 110);
  
  if (isPaused) {
    fill(0, 180);
    noStroke();
    rect(0, height/2 - 50, width, 100);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(60);
    text("PAUSED", width/2, height/2);
  }
  
  // Draw legend for card colors
  int legendX = 40;
  int legendY = 150;
  int boxW = 30;
  int boxH = 30;
  int spacing = 10;
  int textOffset = 40;
  textAlign(LEFT, CENTER);
  textSize(18);
  // Default
  fill(defaultColor); stroke(100); strokeWeight(3);
  rect(legendX, legendY, boxW, boxH, 5);
  fill(0); noStroke();
  text("Default", legendX + textOffset, legendY + boxH/2);
  // Comparing
  fill(comparingColor); stroke(200,200,0); strokeWeight(3);
  rect(legendX, legendY + boxH + spacing, boxW, boxH, 5);
  fill(0); noStroke();
  text("Comparing", legendX + textOffset, legendY + boxH + spacing + boxH/2);
  // Swapping
  fill(swappingColor); stroke(200,0,0); strokeWeight(3);
  rect(legendX, legendY + 2*(boxH + spacing), boxW, boxH, 5);
  fill(0); noStroke();
  text("Swapping", legendX + textOffset, legendY + 2*(boxH + spacing) + boxH/2);
  // Sorted
  fill(sortedColor); stroke(0,200,0); strokeWeight(3);
  rect(legendX, legendY + 3*(boxH + spacing), boxW, boxH, 5);
  fill(0); noStroke();
  text("Sorted", legendX + textOffset, legendY + 3*(boxH + spacing) + boxH/2);
}

String getStateString(SimulationState state) {
  switch(state) {
    case DEALING: return "Dealing Cards";
    case FLIPPING: return "Flipping Cards";
    case SORTING: return "Sorting";
    case DONE: return "Complete";
    default: return "Unknown";
  }
}

void initializeSimulation() {
  cleanup();
  
  // Get the current card count from the slider
  cardCount = numCards.getValueI();
  
  // Initialize arrays after cardCount is set
  cardDeck1 = new Card[cardCount];
  cardDeck2 = new Card[cardCount];
  cardNumbers = new int[cardCount];
  
  // Reset simulation states
  currentSimulationStateTop = SimulationState.DEALING;
  currentSimulationState2 = SimulationState.DEALING;
  
  // Reset counters
  dealCardIndex = 0;
  flipCardIndex2 = 0;
  currentStep2 = 0;
  frameCounter2 = 0;
  operationCount2 = 0;
  
  // Clear animation data
  swapIndices2.clear();
  targetIndices2.clear();
  animationFrames2.clear();
  
  // Calculate starting X position
  startX = (width/16)*((16-cardCount)/2);
  
  // Initialize cards - only generate new values if initialCardValues is null or length doesn't match
  if (initialCardValues == null || initialCardValues.length != cardCount) {
    initialCardValues = new int[cardCount];
    for (int i = 0; i < cardCount; i++) {
      int suit = round(random(1, 4));
      int value = int(random(2, 14));
      initialCardValues[i] = (4*(value-2)+suit);
    }
  }
  
  // Use the stored initial values
  for (int i = 0; i < cardCount; i++) {
    cardNumbers[i] = initialCardValues[i];
  }
  
  // Create card objects
  float initialXLocation = startX;
  for (int i = 0; i < cardCount; i++) {
    cardDeck1[i] = new Card(initialXLocation, startY, cardNumbers[i]);
    cardDeck2[i] = new Card(initialXLocation, startY, cardNumbers[i]);
    initialXLocation += 100;
  }
  
  // Set all cards face down
  for (int i = 0; i < cardCount; i++) {
    cardDeck1[i].setFaceUp(false);
    cardDeck2[i].setFaceUp(false);
  }
  
  // Prepare sorting steps
  prepareSortingSteps(2);
  prepareSortingStepsTop();
  
  // Reset additional counters
  dealCardIndexTop = 0;
  flipCardIndexTop = 0;
  animationTimer = 0;
  
  // Ensure it start paused
  isPaused = true;
  pauseB.setText("Start");
  pauseB.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  isCleanedUp = false;
}


boolean areAllCardsSorted(int deckNum) {
  Card[] deck = (deckNum == 1) ? cardDeck1 : cardDeck2;
  if (deck == null) return false;
  
  for (int i = 0; i < cardCount; i++) {
    if (deck[i] == null || !deck[i].isSorted) {
      return false;
    }
  }
  return true;
}

void displayDoneMessage() {
  // Only show completion message if all cards have green borders
  if (!areAllCardsSorted(1) || !areAllCardsSorted(2)) {
    return;
  }
  
  fill(0, 180);
  noStroke();
  rect(0, height/2 - 100, width, 200); 
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(80);  
  text("SORTING COMPLETE", width/2, height/2 - 30);
  
  // Complemetion stats
  textSize(36); 
  text("Top Algorithm Comparisons: " + operationCountTop, width/2, height/2 + 30);
  text("Bottom Algorithm Comparisons: " + operationCount2, width/2, height/2 + 80);
  
  if (!isCleanedUp) {
    cleanup();
    isPaused = true;
    isCleanedUp = true;
  }
}

void cleanup() {
  if (cardDeck1 != null) {
    for (Card card : cardDeck1) {
      if (card != null && card.cardImage != null) {
        card.cardImage = null;
      }
    }
    cardDeck1 = null;
  }
  
  if (cardDeck2 != null) {
    for (Card card : cardDeck2) {
      if (card != null && card.cardImage != null) {
        card.cardImage = null;
      }
    }
    cardDeck2 = null;
  }
  
  cardNumbers = null;
  
  swapIndices2.clear();
  targetIndices2.clear();
  animationFrames2.clear();
  
  swapIndicesTop.clear();
  targetIndicesTop.clear();
  animationFramesTop.clear();
  // Garbage Collenction
  System.gc();
}

void handleDealingAnimationTop() {
  // Display all cards that have been dealt so far
  for (int i = 0; i < dealCardIndexTop; i++) {
    if (cardDeck1 != null && cardDeck1[i] != null) {
      cardDeck1[i].drawCard();
    }
  }
  
  if (dealCardIndexTop < cardCount) {
    if (cardDeck1 != null && cardDeck1[dealCardIndexTop] != null) {
      // Initialize the current card off-screen to the right
      if (cardDeck1[dealCardIndexTop].x == cardDeck1[dealCardIndexTop].targetX) {
        cardDeck1[dealCardIndexTop].x = width + 100;
      }
      
      // Draw the current card being dealt
      cardDeck1[dealCardIndexTop].drawCard();
      
      // Move the current card towards its target position
      boolean reachedTarget = cardDeck1[dealCardIndexTop].moveTowardsTarget();
      
      if (reachedTarget) {
        dealCardIndexTop++;
        if (dealCardIndexTop == cardCount) {
          currentSimulationStateTop = SimulationState.FLIPPING;
          flipCardIndexTop = 0;
          animationTimer = 0;
        }
      }
    }
  }
}
