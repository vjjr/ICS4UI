class Economy {
  // Tracks key economic metrics including GDP and growth rates
  float currentGDP;
  float gdpGrowthPerYear;
  float cumulativeGDPGrowth;
  float economicStability;
  
  // Reference to parent Country object for accessing simulation data
  Country country;
  
  // Reference to LandCell for accessing land type constants
  LandCell landCellRef;
  
  // Constructor: sets up initial economic parameters
  Economy(Country country) {
    this.country = country;
    this.gdpGrowthPerYear = 3.5;  // Start with 3.5% growth - not bad!
    this.cumulativeGDPGrowth = 0;
    
    // Create a reference cell so we can access the land type constants
    this.landCellRef = new LandCell(0, 0);
  }
  
  // Computes GDP using economic stability, education level and cumulative growth
  void calculateCurrentGDP() {
    currentGDP = economicStability * (1 + (country.currentYear - 2025)/100.0) * (1 + (country.educationLevel/200)) + cumulativeGDPGrowth;
  }
  
  // Annual economic update: calculates growth modifiers and innovation bonuses
  void update() {
    float growthModifier = 1.0 + (country.educationLevel/200) - (country.government.corruptionLevel/2) + (country.socialStability/200);
    float innovationBonus = 1 + country.innovationRate;
    // Tech hubs boost the economy
    int techHubCount = 0;
    for (int i = 0; i < country.gridWidth; i++) {
      for (int j = 0; j < country.gridWidth; j++) {
        if (country.cells[i][j].landUseType == landCellRef.TECH_HUB) {
          techHubCount++;
        }
      }
    }
    innovationBonus += techHubCount * 0.05;
    float thisYearGrowth = gdpGrowthPerYear * innovationBonus * growthModifier;
    cumulativeGDPGrowth += thisYearGrowth;
    calculateCurrentGDP();
    country.government.updatePublicApproval(country.socialStability, thisYearGrowth, country.educationLevel);
  }
  


}
