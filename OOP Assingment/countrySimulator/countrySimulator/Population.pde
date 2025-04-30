class Population {
  // Stores population statistics including count, growth rate and demographic breakdown
  float count;  // Population count in thousands
  float growthRate; // How fast the population grows each year
  
  // Demographics of our population
  float urbanRatio; // What percentage lives in cities
  float educatedRatio; // What percentage has higher education
  float employmentRate; // What percentage has jobs
  
  // Reference to the country where people live
  Country country;
  
  // Constructor: sets initial population values based on country type
  Population(Country country) {
    this.country = country;
    this.count = 100000; // Start with 100,000 people (will adjust based on country type)
    this.growthRate = 0.01; // 1% annual growth to start
    this.urbanRatio = 0.5; // Half our people live in cities
    this.educatedRatio = 0.3; // 30% have higher education
    this.employmentRate = 0.7; // 70% have jobs
  }
  
  // Annual population update: calculates growth modifiers and updates demographics
  void update() {
    // Figure out how fast pop is  growing based on country conditions
    float growthModifier = calculateGrowthModifier();
    
    // Grow  population
    count *= (1 + growthRate * growthModifier);
    
    // Update  demographic breakdowns
    updateDemographics();
  }
  
  // Computes population growth rate based on healthcare, education and stability factors
  // Corrected method definition
  float calculateGrowthModifier() {
    float healthFactor = 1.0 + (country.healthcareQuality / 200);
    float educationFactor = 1.0 - (country.educationLevel / 300);
    float stabilityFactor = 1.0 + (country.socialStability / 400);
    
    if (country.government.type.equals("democracy")) 
    {
      return healthFactor * educationFactor * stabilityFactor * 0.9;
    } 
    else if (country.government.type.equals("socialist")) 
    {
      return healthFactor * educationFactor * stabilityFactor * 1.1;
    } 
    else if (country.government.type.equals("failed-state")) 
    {
      return healthFactor * educationFactor * stabilityFactor * 0.7;
    } 
    else 
    {
      return healthFactor * educationFactor * stabilityFactor;
    }
  }
  
  // Updates urban ratio, education level and employment rate based on country development
  void updateDemographics() {
    float urbanizationChange = (country.economy.currentGDP / 50000) * 0.005;
    urbanRatio = min(0.95, urbanRatio + urbanizationChange);
    
    float educationChange = (country.educationLevel / 1000) * 0.01;
    educatedRatio = min(0.95, educatedRatio + educationChange);
    
    float employmentChange = (country.economy.cumulativeGDPGrowth / 100) * 0.01;
    if (country.socialStability < 50) {
      employmentChange -= (50 - country.socialStability) / 500;
    }
    
    employmentRate = constrain(employmentRate + employmentChange, 0.3, 0.95);
  }
  
  // Calculates population density
  float getPopulationDensity() {
    return count / (country.gridWidth * country.gridWidth);
  }
}
