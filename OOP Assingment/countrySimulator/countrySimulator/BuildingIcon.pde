class BuildingIcon {
  // Special font required to display emoji characters
  PFont emojiFont;
  
  // Requires access to land type constants
  LandCell landCellRef;
  
  // Initializes the emoji display system
  BuildingIcon() {

    emojiFont = createFont("Arial Unicode MS", 32, true);
    if (emojiFont == null) {
      
      emojiFont = createFont("Segoe UI Emoji", 32, true);
    }
    
    if (emojiFont == null) {
      // Last chance - basic Arial should at least work, even if emojis look bad
      emojiFont = createFont("Arial", 32, true);
    }
    
    // Creates a reference cell to access land type constants
    landCellRef = new LandCell(0, 0);
  }
  
  // Main method called by other classes
  void draw(int landUseType, float x, float y, float size) {
    drawIcon(landUseType, x, y, size);
  }

  // Handles selecting and drawing the appropriate emoji
  void drawIcon(int landUseType, float x, float y, float size) {
    // Make sure we're using our emoji-compatible font
    if (emojiFont != null) {
      textFont(emojiFont);
    }
    textAlign(CENTER, CENTER);
    textSize(size * 0.8); // Make the emoji a bit smaller than the cell for better spacing
    
    String icon = "";
    if (landUseType == landCellRef.EMPTY_LAND) 
    {
      icon = "⬜"; // Just empty land waiting to be developed
    } 
    else if (landUseType == landCellRef.RESIDENTIAL_LOW) 
    {
      icon = "🏠"; // Single family homes
    } 
    else if (landUseType == landCellRef.RESIDENTIAL_MID) 
    {
      icon = "🏘️"; // Townhouses and duplexes
    } 
    else if (landUseType == landCellRef.RESIDENTIAL_HIGH) 
    {
      icon = "🏢"; // High-rise apartments
    } 
    else if (landUseType == landCellRef.COMMERCIAL) 
    {
      icon = "🏬"; // Shopping and businesses
    } 
    else if (landUseType == landCellRef.INDUSTRIAL) 
    {
      icon = "🏭"; // Factories and manufacturing
    } 
    else if (landUseType == landCellRef.PARK) 
    {
      icon = "🌳"; // Green spaces for recreation
    } 
    else if (landUseType == landCellRef.WATER) 
    {
      icon = "💧"; // Lakes, rivers, and oceans
    } 
    else if (landUseType == landCellRef.FARM) 
    {
      icon = "🌾"; // Agricultural land
    } 
    else if (landUseType == landCellRef.GOVERNMENT) 
    {
      icon = "🏛️"; // Government buildings and institutions
    } 
    else if (landUseType == landCellRef.SCHOOL) 
    {
      icon = "🏫"; // Educational facilities
    } 
    else if (landUseType == landCellRef.HOSPITAL) 
    {
      icon = "🏥"; // Healthcare facilities
    } 
    else if (landUseType == landCellRef.FOREST) 
    {
      icon = "🌲"; // Natural forest areas
    } 
    else if (landUseType == landCellRef.AIRPORT) 
    {
      icon = "✈️"; // Airport
    } 
    else if (landUseType == landCellRef.TECH_HUB) 
    {
      icon = "💻"; // Technology and innovation centers upgrade of shopping and business
    } 
    else 
    {
      icon = "❓"; // Something went wrong if this is shown
    }
    
    text(icon, x + size/2, y + size/2);
  }
}
