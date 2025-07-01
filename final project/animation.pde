/*
 * Animation System for Sorting Algorithm Visualizer
 * This file handles all animation states and transitions for the card sorting visualization
 * Features:
 * - Card dealing animation
 * - Card flipping animation
 * - Swap animations (neighbor and long-distance)
 * - State transitions between different animation phases
 */

/**
 * Handles the initial dealing animation of cards
 * Cards are dealt from right to left with smooth movement
 * @param deckNum The deck number (1 for top, 2 for bottom)
 */
void handleDealingAnimation(int deckNum) {
  Card[] deck = (deckNum == 1) ? cardDeck1 : cardDeck2;
  int dealCardIdx = (deckNum == 1) ? dealCardIndexTop : dealCardIndex;
  
  // Display all cards that have been dealt so far
  for (int i = 0; i < dealCardIdx; i++) {
    if (deck != null && deck[i] != null) {
      deck[i].drawCard();
    }
  }
  
  if (dealCardIdx < cardCount) {
    if (deck != null && deck[dealCardIdx] != null) {
      // Initialize the current card off-screen to the right
      if (deck[dealCardIdx].x == deck[dealCardIdx].targetX) {
        deck[dealCardIdx].x = width + 100;
      }
      
      // Draw the current card being dealt
      deck[dealCardIdx].drawCard();
      
      // Move the current card towards its target position
      boolean reachedTarget = deck[dealCardIdx].moveTowardsTarget();
      
      if (reachedTarget) {
        if (deckNum == 1) dealCardIndexTop++;
        else dealCardIndex++;
        
        if (dealCardIdx + 1 == cardCount) {
          // Ensure all cards are dealt and visible before transitioning
          for (int i = 0; i < cardCount; i++) {
            if (deck[i] != null) {
              deck[i].x = deck[i].targetX;
              deck[i].drawCard();
            }
          }
          
          // Immediately transition to flipping state
          if (deckNum == 1) {
            currentSimulationStateTop = SimulationState.FLIPPING;
            flipCardIndexTop = 0;
            animationTimer = 0;
          } else {
            currentSimulationState2 = SimulationState.FLIPPING;
            flipCardIndex2 = 0;
            animationTimer = 0;
          }
        }
      }
    }
  }
}

/**
 * Handles the card flipping animation sequence
 * Cards are flipped one at a time with a delay between each flip
 * @param deckNum The deck number (1 for top, 2 for bottom)
 */
void handleFlippingAnimation(int deckNum) {
  Card[] deck = (deckNum == 1) ? cardDeck1 : cardDeck2;
  int currentFlipIndex = (deckNum == 1) ? flipCardIndexTop : flipCardIndex2;
  
  // Display all cards
  for (int i = 0; i < cardCount; i++) {
    if (deck[i] != null) {
      deck[i].drawCard();
    }
  }
  
  if (currentFlipIndex < cardCount) {
    animationTimer++;
    if (animationTimer >= animationDelay / 2) {
      // Flip the current card
      if (deck[currentFlipIndex] != null) {
        deck[currentFlipIndex].setFaceUp(true);
        deck[currentFlipIndex].drawCard();
      }
      
      // Update the flip index
      if (deckNum == 1) {
        flipCardIndexTop++;
      } else {
        flipCardIndex2++;
      }
      animationTimer = 0;
      
      // Special handling for the last card
      if (currentFlipIndex + 1 >= cardCount) {
        // Force flip all remaining cards
        for (int i = currentFlipIndex; i < cardCount; i++) {
          if (deck[i] != null) {
            deck[i].setFaceUp(true);
            deck[i].drawCard();
          }
        }
        
        // Transition to sorting state
        if (deckNum == 1) {
          currentSimulationStateTop = SimulationState.SORTING;
          currentStepTop = 0;
          frameCounterTop = 0;
        } else {
          currentSimulationState2 = SimulationState.SORTING;
          currentStep2 = 0;
          frameCounter2 = 0;
        }
      }
    }
  }
  
  // Additional check to ensure last card is flipped
  if (currentFlipIndex >= cardCount - 1) {
    if (deck[cardCount - 1] != null) {
      deck[cardCount - 1].setFaceUp(true);
      deck[cardCount - 1].drawCard();
    }
  }
}

/**
 * Manages the swap animations during sorting
 * Handles both neighbor swaps and long-distance swaps
 * @param deckNum The deck number (1 for top, 2 for bottom)
 */
void animateSwaps(int deckNum) {
  String currentAlgorithm = (deckNum == 1) ? currentAlgorithm1 : currentAlgorithm2;
  ArrayList<Integer> swapIndices = (deckNum == 1) ? swapIndicesTop : swapIndices2;
  ArrayList<Integer> targetIndices = (deckNum == 1) ? targetIndicesTop : targetIndices2;
  ArrayList<Integer> animationFrames = (deckNum == 1) ? animationFramesTop : animationFrames2;
  int currentStep = (deckNum == 1) ? currentStepTop : currentStep2;
  int frameCounter = (deckNum == 1) ? frameCounterTop : frameCounter2;
  Card[] cardDeck = (deckNum == 1) ? cardDeck1 : cardDeck2;
  
  // Reset all card states first - none are sorted during the process
  for (int i = 0; i < cardCount; i++) {
    if (cardDeck[i] != null) {
      cardDeck[i].setState(false, false, false);
    }
  }
  
  if (currentAlgorithm.equals("Selection Sort")) {
    if (currentStep < animationFrames.size()) {
      // Set comparing state for the current comparison
      if (cardDeck[targetIndices.get(currentStep)] != null) {
        cardDeck[targetIndices.get(currentStep)].setState(true, false, false);
      }
      performLongDistanceSwap(deckNum);
    } else {
      // Mark all cards as sorted at once when done
      for (int i = 0; i < cardCount; i++) {
        if (cardDeck[i] != null) {
          cardDeck[i].setState(false, false, true);
        }
      }
      // Ensure all cards are drawn as sorted before setting DONE
      for (int i = 0; i < cardCount; i++) {
        if (cardDeck[i] != null) {
          cardDeck[i].drawCard();
        }
      }
      if (deckNum == 1) currentSimulationStateTop = SimulationState.DONE;
      else currentSimulationState2 = SimulationState.DONE;
    }
  }
  else {
    if (currentStep < swapIndices.size()) {
      // Set comparing and swapping states
      int currentSwapIndex = swapIndices.get(currentStep);
      if (cardDeck[currentSwapIndex] != null) {
        cardDeck[currentSwapIndex].setState(true, true, false);
      }
      if (cardDeck[currentSwapIndex + 1] != null) {
        cardDeck[currentSwapIndex + 1].setState(true, true, false);
      }
      performNeighborSwap(deckNum);
    } else {
      // Mark all cards as sorted at once when done
      for (int i = 0; i < cardCount; i++) {
        if (cardDeck[i] != null) {
          cardDeck[i].setState(false, false, true);
        }
      }
      // Ensure all cards are drawn as sorted before setting DONE
      for (int i = 0; i < cardCount; i++) {
        if (cardDeck[i] != null) {
          cardDeck[i].drawCard();
        }
      }
      if (deckNum == 1) currentSimulationStateTop = SimulationState.DONE;
      else currentSimulationState2 = SimulationState.DONE;
    }
  }
}

/**
 * Performs neighbor swap animation (for Bubble Sort and Insertion Sort)
 * Animates cards swapping with their immediate neighbors
 * @param deckNum The deck number (1 for top, 2 for bottom)
 */
void performNeighborSwap(int deckNum) {
  ArrayList<Integer> swapIndices = (deckNum == 1) ? swapIndicesTop : swapIndices2;
  Card[] cardDeck = (deckNum == 1) ? cardDeck1 : cardDeck2;
  int currentStep = (deckNum == 1) ? currentStepTop : currentStep2;
  int frameCounter = (deckNum == 1) ? frameCounterTop : frameCounter2;
  
  if (deckNum == 1) frameCounterTop++;
  else frameCounter2++;
  
  if (currentStep < swapIndices.size()) {
    if (frameCounter <= 100/animationSpeed) {
      moveCards(cardDeck, swapIndices.get(currentStep), swapIndices.get(currentStep)+1);
      if (frameCounter == 100/animationSpeed) {
        Card temp = cardDeck[swapIndices.get(currentStep)];
        cardDeck[swapIndices.get(currentStep)] = cardDeck[swapIndices.get(currentStep)+1];
        cardDeck[swapIndices.get(currentStep)+1] = temp;
      }
    }
    else {
      if (deckNum == 1) {
        frameCounterTop = 0;
        currentStepTop++;
      } else {
        frameCounter2 = 0;
        currentStep2++;
      }
    }
  } else {
    // Mark all cards as sorted at once when done
    for (int i = 0; i < cardCount; i++) {
      if (cardDeck[i] != null) {
        cardDeck[i].setState(false, false, true);
      }
    }
    // Ensure all cards are drawn as sorted before setting DONE
    for (int i = 0; i < cardCount; i++) {
      if (cardDeck[i] != null) {
        cardDeck[i].drawCard();
      }
    }
    if (deckNum == 1) currentSimulationStateTop = SimulationState.DONE;
    else currentSimulationState2 = SimulationState.DONE;
  }
}

/**
 * Performs long-distance swap animation (for Selection Sort)
 * Animates cards swapping across arbitrary distances
 * @param deckNum The deck number (1 for top, 2 for bottom)
 */
void performLongDistanceSwap(int deckNum) {
  ArrayList<Integer> swapIndices = (deckNum == 1) ? swapIndicesTop : swapIndices2;
  ArrayList<Integer> targetIndices = (deckNum == 1) ? targetIndicesTop : targetIndices2;
  ArrayList<Integer> animationFrames = (deckNum == 1) ? animationFramesTop : animationFrames2;
  Card[] cardDeck = (deckNum == 1) ? cardDeck1 : cardDeck2;
  int currentStep = (deckNum == 1) ? currentStepTop : currentStep2;
  int frameCounter = (deckNum == 1) ? frameCounterTop : frameCounter2;
  
  if (deckNum == 1) frameCounterTop++;
  else frameCounter2++;
  
  if (currentStep < swapIndices.size()) {
    if (frameCounter <= animationFrames.get(currentStep)) {
      moveCards(cardDeck, targetIndices.get(currentStep), swapIndices.get(currentStep));
      if (frameCounter == animationFrames.get(currentStep)) {
        Card temp = cardDeck[targetIndices.get(currentStep)];
        cardDeck[targetIndices.get(currentStep)] = cardDeck[swapIndices.get(currentStep)];
        cardDeck[swapIndices.get(currentStep)] = temp;
      }
    }
    else {
      if (deckNum == 1) {
        frameCounterTop = 0;
        currentStepTop++;
      } else {
        frameCounter2 = 0;
        currentStep2++;
      }
    }
  } else {
    // Mark all cards as sorted at once when done
    for (int i = 0; i < cardCount; i++) {
      if (cardDeck[i] != null) {
        cardDeck[i].setState(false, false, true);
      }
    }
    // Ensure all cards are drawn as sorted before setting DONE
    for (int i = 0; i < cardCount; i++) {
      if (cardDeck[i] != null) {
        cardDeck[i].drawCard();
      }
    }
    if (deckNum == 1) currentSimulationStateTop = SimulationState.DONE;
    else currentSimulationState2 = SimulationState.DONE;
  }
}

/**
 * Moves two cards towards each other's positions
 * Creates smooth animation for card swapping
 * @param cards The array of cards
 * @param pos1 First card position
 * @param pos2 Second card position
 */
void moveCards(Card[] cards, int pos1, int pos2) {
  float targetX = cards[pos2].x + (pos2-pos1)*100;
  if (abs(cards[pos1].x - targetX) > 1) {
    float dx = (targetX - cards[pos1].x) * 0.1;
    cards[pos1].x += dx;
    cards[pos2].x -= dx;
  }
} 