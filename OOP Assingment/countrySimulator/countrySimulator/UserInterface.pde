class UserInterface {
  // Reference to the Country object being visualized
  Country country;
  
  // UI layout parameters including padding and cell dimensions
  float padding = 50;
  float cellSize;
  
  // Handles building icon rendering using emoji characters
  BuildingIcon buildingIcon;
  
  // Reference to LandCell for accessing land type constants
  LandCell landCellRef;
  
  // Constructor: sets up UI components and calculates layout parameters
  UserInterface(Country country) {
    this.country = country;
    
    // Determines cell size based on window dimensions and grid width
    cellSize = (height - 2 * padding - 100) / country.gridWidth;
    
    // Initializes building icon renderer
    buildingIcon = new BuildingIcon();
    
    // Creates reference LandCell for accessing type constants
    landCellRef = new LandCell(0, 0);
  }
  
  // Main drawing method: renders all UI components in proper order
  void draw() {
    background(0); 
    
    // Renders title and creator information
    drawTitles();
    
    // Displays numerical country statistics
    drawStatistics();
    
    // Shows land use distribution percentages
    drawLandUseStats();
    
    // Renders icon legend for land types
    drawLegend();
    
    // Draws the main country grid with land cells
    drawGrid();
  }
  
  // Draw the title and creator info
  void drawTitles() {
    fill(255); 
    textSize(48);  
    textAlign(CENTER, CENTER);
    text("Country Simulator", 500, 50);
    
    textSize(18); 
    textAlign(CENTER, TOP);
    text("Created by Vijay Vijayaraja", 500, 90);
    
    // Let the user know if we're paused
    if (country.isPaused) {
      fill(255, 50, 50); 
      textSize(20); 
      textAlign(CENTER, TOP);
      text("PAUSED - Press SPACE to resume", 500, 120);
    }
  }
  
  // Show all country statistics in a sidebar
  void drawStatistics() {
    fill(255);
    textSize(24); 
    textAlign(LEFT, TOP);
    text("Statistics", 930, 35);
    
    
    textSize(16); 
    float statY = 80;
    float statSpacing = 30; 
    
    text("Year:", 930, statY);
    text("Population:", 930, statY + statSpacing);
    text("GDP Per Capita:", 930, statY + statSpacing*2);
    text("GDP Growth:", 930, statY + statSpacing*3);
    text("Social Stability:", 930, statY + statSpacing*4);
    text("Education Level:", 930, statY + statSpacing*5);
    text("Healthcare Quality:", 930, statY + statSpacing*6);
    text("Infrastructure:", 930, statY + statSpacing*7);
    text("Government Type:", 930, statY + statSpacing*8);
    
    textSize(14); 
    text(str(country.currentYear), 1250, statY);
    text(nfc(int(country.population.count), 0), 1250, statY + statSpacing);
    text("$" + nfc(int(country.economy.currentGDP), 0), 1250, statY + statSpacing*2);
    text(str(roundAny(country.economy.cumulativeGDPGrowth, 2)) + "%", 1250, statY + statSpacing*3);
    text(str(int(country.socialStability)) + "/100", 1250, statY + statSpacing*4);
    text(str(int(country.educationLevel)) + "/100", 1250, statY + statSpacing*5);
    text(str(int(country.healthcareQuality)) + "/100", 1250, statY + statSpacing*6);
    text(str(int(country.infrastructureQuality)) + "/100", 1250, statY + statSpacing*7);
    text(country.government.type, 1250, statY + statSpacing*8);
  }
  
  // Show what percentage of land is used for different purposes
  void drawLandUseStats() {
    int[] landUseCounts = new int[16];
    for (int i = 0; i < country.gridWidth; i++) {
      for (int j = 0; j < country.gridWidth; j++) {
        landUseCounts[country.cells[i][j].landUseType]++;
      }
    }
    fill(255);
    textSize(18); 
    
    // Figure out where to put this section
    float landUseY = 80 + 30*9 + 20; // Start after statistics with some spacing
    text("Land Use Distribution:", 930, landUseY);
    
    int[] sortedTypes = new int[16];
    for (int i = 0; i < 16; i++) sortedTypes[i] = i;
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15-i; j++) {
        if (landUseCounts[sortedTypes[j]] < landUseCounts[sortedTypes[j+1]]) {
          int temp = sortedTypes[j];
          sortedTypes[j] = sortedTypes[j+1];
          sortedTypes[j+1] = temp;
        }
      }
    }
    textSize(14); 
    textAlign(LEFT, CENTER);
    
    float distributionSpacing = 30; 
    for (int i = 0; i < min(5, 16); i++) {
      if (landUseCounts[sortedTypes[i]] > 0) {
        int type = sortedTypes[i];
        float percentage = 100.0 * landUseCounts[type] / (country.gridWidth * country.gridWidth);
        float yPosition = landUseY + 30 + i*distributionSpacing;
        
        // Get the emoji for this land type
        String emoji = getEmojiForLandUseType(type);
        
        // Put it all together in a nice format
        String combinedText = emoji + " " + getLandUseName(type) + ": " + nf(percentage, 1, 1) + "%";
        
        fill(255);
        textAlign(LEFT, CENTER);
        text(combinedText, 930, yPosition); // Position text with more spacing
      }
    }
    textAlign(LEFT, TOP);
  }
  
  // Draw the main country grid
  void drawGrid() {
    stroke(50); // Subtle grid lines
    float y = padding + 100;
    
    for (int i = 0; i < country.gridWidth; i++) {
      for (int j = 0; j < country.gridWidth; j++) {
        float x = padding + j * cellSize;
        buildingIcon.draw(country.cells[i][j].landUseType, x, y, cellSize);
      }
      y += cellSize;
    }
  }
  
  // Draw a legend explaining what all the icons mean
  void drawLegend() {
    float legendX = 930;
    // Figure out where to put the legend
    float landUseY = 80 + 30*9 + 20; // Start position of land use distribution
    float distributionItems = min(5, 16); // Number of distribution items
    float legendY = landUseY + 30 + distributionItems*30 + 20; // Position after land use distribution
    
    float rowHeight = 35; // Spacing between legend items
    
    // Legend title
    fill(255); 
    textSize(16); 
    text("Legend:", legendX, legendY);
    
    textSize(11);
    textAlign(LEFT, CENTER);
    
    // Two-column legend to save space
    for (int i = 0; i < 8; i++) {
      float yPosition = legendY + rowHeight*(i+1);
      
      // Left column - only emoji in text
      fill(255); 
      String emoji = getEmojiForLandUseType(i);
      String combinedText = emoji + " " + getLandUseName(i);
      
      
      text(combinedText, legendX, yPosition);
      
      // Right column - only draw defined land types (0-14)
      if (i+8 < 15) {
        fill(255); // White text
        String emojiRight = getEmojiForLandUseType(i+8);
        String combinedTextRight = emojiRight + " " + getLandUseName(i+8);
        
        
        text(combinedTextRight, legendX + 240, yPosition);
      }
    }
    
    // Add controls section below the legend
    float controlsY = legendY + rowHeight * 9 + 10;
    
    fill(255);
    textSize(14); 
    text("Controls:", legendX, controlsY);
    
    textSize(12); 
    textAlign(LEFT, TOP);
    
    float controlItemY = controlsY + 25;
    text("SPACE - Pause/Resume simulation", legendX, controlItemY);

    // Reset text alignment for other elements
    textAlign(LEFT, TOP);
  }
  
  String getLandUseName(int landUseType) {
    // Create a temporary LandCell with the given land use type
    LandCell tempCell = new LandCell(0, 0);
    tempCell.landUseType = landUseType;
    return tempCell.getLandUseName();
  }
  
  // Get the right emoji for each land type
  String getEmojiForLandUseType(int landUseType) {
    if (landUseType == landCellRef.EMPTY_LAND) {
      return "⬜";
    }
    else if (landUseType == landCellRef.RESIDENTIAL_LOW) {
      return "🏠";
    }
    else if (landUseType == landCellRef.RESIDENTIAL_MID) {
      return "🏘️";
    }
    else if (landUseType == landCellRef.RESIDENTIAL_HIGH) {
      return "🏢";
    }
    else if (landUseType == landCellRef.COMMERCIAL) {
      return "🏬";
    }
    else if (landUseType == landCellRef.INDUSTRIAL) {
      return "🏭";
    }
    else if (landUseType == landCellRef.PARK) {
      return "🌳";
    }
    else if (landUseType == landCellRef.WATER) {
      return "💧";
    }
    else if (landUseType == landCellRef.FARM) {
      return "🌾";
    }
    else if (landUseType == landCellRef.GOVERNMENT) {
      return "🏛️";
    }
    else if (landUseType == landCellRef.SCHOOL) {
      return "🏫";
    }
    else if (landUseType == landCellRef.HOSPITAL) {
      return "🏥";
    }
    else if (landUseType == landCellRef.FOREST) {
      return "🌲";
    }
    else if (landUseType == landCellRef.AIRPORT) {
      return "✈️";
    }
    else if (landUseType == landCellRef.TECH_HUB) {
      return "💻";
    }
    else {
      return "⬜";
    }
  }
  
  // Helper function to round numbers to a specific decimal place
  float roundAny(float x, int d) {
    if (d == 0) {
      return round(x);
    } 
    float scale = pow(10, d);
    return round(x * scale) / scale;
  }
}