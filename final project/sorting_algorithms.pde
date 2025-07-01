/*
 * Sorting Algorithms Implementation
 * This file contains the implementation of various sorting algorithms
 * and their visualization preparation
 * Features:
 * - Bubble Sort
 * - Selection Sort
 * - Insertion Sort
 * - Operation counting for performance analysis
 */

/**
 * Prepares the sorting steps for visualization
 * Records all operations and their indices for animation
 * @param deckNum Which deck to prepare (1 for top, 2 for bottom)
 */
void prepareSortingSteps(int deckNum) {
  // Select appropriate algorithm and data structures based on deck number
  String currentAlgorithm = (deckNum == 1) ? currentAlgorithm1 : currentAlgorithm2;
  ArrayList<Integer> swapIndices = (deckNum == 1) ? swapIndicesTop : swapIndices2;
  ArrayList<Integer> targetIndices = (deckNum == 1) ? targetIndicesTop : targetIndices2;
  ArrayList<Integer> animationFrames = (deckNum == 1) ? animationFramesTop : animationFrames2;
  int[] numbers = cardNumbers.clone();
  int operationCount = 0;
  
  // Clear previous steps
  swapIndices.clear();
  if (currentAlgorithm.equals("Selection Sort")) {
    targetIndices.clear();
    animationFrames.clear();
  }
  
  // Bubble Sort Implementation
  if (currentAlgorithm.equals("Bubble Sort")) {
    for (int i = 0; i < numbers.length - 1; i++) {
      for (int j = 0; j < numbers.length - i - 1; j++) {
        operationCount++; // Count comparison
        if (numbers[j] > numbers[j + 1]) {
          operationCount++; // Count swap
          swapIndices.add(j);
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
        }
      }
    }
  }
  // Selection Sort Implementation
  else if (currentAlgorithm.equals("Selection Sort")) {
    for (int i = 0; i < numbers.length - 1; i++) {
      int minIdx = i;
      for (int j = i + 1; j < numbers.length; j++) {
        operationCount++; // Count comparison
        if (numbers[j] < numbers[minIdx]) {
          minIdx = j;
        }
      }
      if (minIdx != i) {
        operationCount++; // Count swap
        swapIndices.add(i);
        targetIndices.add(minIdx);
        animationFrames.add(50);
        int temp = numbers[i];
        numbers[i] = numbers[minIdx];
        numbers[minIdx] = temp;
      }
    }
  }
  // Insertion Sort Implementation
  else if (currentAlgorithm.equals("Insertion Sort")) {
    for (int i = 1; i < numbers.length; i++) {
      int key = numbers[i];
      int j = i - 1;
      while (j >= 0) {
        operationCount++; // Count comparison
        if (numbers[j] > key) {
          operationCount++; // Count shift
          swapIndices.add(j);
          numbers[j + 1] = numbers[j];
          j--;
        } else {
          break;
        }
      }
      numbers[j + 1] = key;
    }
  }
  
  // Update operation count for the appropriate deck
  if (deckNum == 1) {
    operationCountTop = operationCount;
  } else {
    operationCount2 = operationCount;
  }
}

/**
 * Prepares sorting steps specifically for the top deck
 * This is a convenience method that calls prepareSortingSteps(1)
 */
void prepareSortingStepsTop() {
  prepareSortingSteps(1);
} 