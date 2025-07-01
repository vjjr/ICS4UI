/*
 * Card class for the Sorting Algorithm Visualizer
 * This class handles the visual representation and behavior of individual cards
 * Features:
 * - Card rendering with images or fallback text
 * - Animation and movement
 * - State management (comparing, swapping, sorted)
 * - Visual feedback through colors and effects
 */

class Card {
  // Position and movement properties
  float x, y;           // Current position
  float targetX;        // Target position for animation
  int value;            // Card's numerical value
  boolean faceUp;       // Card face state
  PImage cardImage;     // Card image
  int suit;             // Card suit (1-4)
  int cardValue;        // Card value (2-14)
  float moveSpeed = 0.08; // Base movement speed
  
  // State flags
  boolean isComparing = false;  // Card is being compared
  boolean isSwapping = false;   // Card is being swapped
  boolean isSorted = false;     // Card is in final position
  
  /**
   * Constructor for Card object
   * @param x Initial x position
   * @param y Initial y position
   * @param totalValue Combined value representing card (1-52)
   */
  Card(float x, float y, int totalValue) {
    this.x = x;
    this.y = y;
    this.targetX = x;
    this.value = totalValue;
    this.faceUp = false;
    
    // Calculate suit and card value from totalValue
    this.suit = (totalValue - 1) % 4 + 1;
    this.cardValue = (totalValue - 1) / 4 + 2;
    
    // Load card image
    String imagePath = "data/" + cardValue + "-" + suit + ".png";
    this.cardImage = loadImage(imagePath);
  }
  
  /**
   * Draws the card with appropriate visual state
   * Includes shadow, background, and face value
   */
  void drawCard() {
    pushMatrix();
    translate(x, y);
    
    // Draw card shadow
    fill(0, 50);
    noStroke();
    rect(5, 5, 90, 130, 10);
    
    // Draw card background with appropriate color
    if (isSorted) {
      fill(sortedColor);
      stroke(0, 200, 0);  // Green border for sorted
    } else if (isSwapping) {
      fill(swappingColor);
      stroke(200, 0, 0);  // Red border for swapping
    } else if (isComparing) {
      fill(comparingColor);
      stroke(200, 200, 0);  // Yellow border for comparing
    } else {
      fill(defaultColor);
      stroke(100);  // Gray border for default
    }
    strokeWeight(3);  
    rect(0, 0, 90, 130, 10);
    
    // Draw card face or back
    if (faceUp) {
      if (cardImage != null) {
        image(cardImage, 5, 5, 80, 120);
      } else {
        // Fallback if image not found
        drawCardText();
      }
    } else {
      drawCardBack();
    }
    
    popMatrix();
  }
  
  /**
   * Draws the card's face value and suit as text
   * Used as fallback when image is not available
   */
  private void drawCardText() {
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    String valueStr = getCardValueString();
    String suitStr = getSuitString();
    text(valueStr + suitStr, 45, 65);
  }
  
  /**
   * Draws the card back pattern
   */
  private void drawCardBack() {
    fill(200);
    rect(5, 5, 80, 120, 5);
    fill(100);
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 7; j++) {
        rect(10 + i*15, 10 + j*15, 10, 10, 2);
      }
    }
  }
  
  /**
   * Updates the card's visual state
   * @param comparing Whether card is being compared
   * @param swapping Whether card is being swapped
   * @param sorted Whether card is in final position
   */
  void setState(boolean comparing, boolean swapping, boolean sorted) {
    this.isComparing = comparing;
    this.isSwapping = swapping;
    this.isSorted = sorted;
  }
  
  /**
   * Moves card towards its target position
   * @return true if card has reached target position
   */
  boolean moveTowardsTarget() {
    float dx = targetX - x;
    if (abs(dx) < 1) {
      x = targetX;
      return true;
    }
    // Use animationSpeed to adjust movement speed
    x += dx * (moveSpeed * (animationSpeed / 5.0));
    return false;
  }
  
  /**
   * Sets the card's face up/down state
   * @param faceUp Whether card should be face up
   */
  void setFaceUp(boolean faceUp) {
    this.faceUp = faceUp;
  }
  
  /**
   * Gets the string representation of card value
   * @return String representation of card value (2-10, J, Q, K, A)
   */
  private String getCardValueString() {
    if (cardValue == 11) return "J";
    if (cardValue == 12) return "Q";
    if (cardValue == 13) return "K";
    if (cardValue == 14) return "A";
    return str(cardValue);
  }
  
  /**
   * Gets the string representation of card suit
   * @return String representation of card suit (♠, ♥, ♦, ♣)
   */
  private String getSuitString() {
    switch(suit) {
      case 1: return "♠";
      case 2: return "♥";
      case 3: return "♦";
      case 4: return "♣";
      default: return "";
    }
  }
}
