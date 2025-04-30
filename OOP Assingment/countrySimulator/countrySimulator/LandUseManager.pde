class LandUseManager {
  // Reference to the country
  Country country;
  
  // Direction vectors for neighbor checking
  int[][] directions = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1},{0, 1}, {1, -1},  {1, 0},  {1, 1}};
  
  // LandCell reference for constants
  LandCell landCellRef;
  
  // Initializes land use manager
  LandUseManager(Country country) {
    this.country = country;
    this.landCellRef = new LandCell(0, 0);
  }
  
  // Counts different land use types in neighborhood
  int[] countNeighborLandUse(int row, int column) {
    int[] counts = new int[16]; // Count of each land use type
    
    for (int i = 0; i < 8; i++) {
      int n = row + directions[i][0];
      int m = column + directions[i][1];
      
      if (n >= 0 && n < country.gridWidth && m >= 0 && m < country.gridWidth) {
        counts[country.cells[n][m].landUseType]++;
      }
    }
    
    return counts;
  }
  
  // Checks land use compatibility between two types
  float getLandUseCompatibility(int currentLandUse, int neighborLandUse) {
    if ((currentLandUse >= landCellRef.RESIDENTIAL_LOW && currentLandUse <= landCellRef.RESIDENTIAL_HIGH) && neighborLandUse == landCellRef.INDUSTRIAL) {
      return -0.5; // People don't want to live near factories
    } else if ((currentLandUse >= landCellRef.RESIDENTIAL_LOW && currentLandUse <= landCellRef.RESIDENTIAL_HIGH) && neighborLandUse == landCellRef.PARK) {
      return 0.7; // People love living near parks
    } else if ((currentLandUse >= landCellRef.RESIDENTIAL_LOW && currentLandUse <= landCellRef.RESIDENTIAL_HIGH) && neighborLandUse == landCellRef.SCHOOL) {
      return 0.4; // Schools are good to have nearby
    } else if ((currentLandUse >= landCellRef.RESIDENTIAL_LOW && currentLandUse <= landCellRef.RESIDENTIAL_HIGH) && neighborLandUse == landCellRef.HOSPITAL) {
      return 0.3; // Hospitals are convenient to have nearby
    } else if (currentLandUse == landCellRef.COMMERCIAL && (neighborLandUse >= landCellRef.RESIDENTIAL_LOW && neighborLandUse <= landCellRef.RESIDENTIAL_HIGH)) {
      return 0.3; // Shops like being near customers
    } else if (currentLandUse == landCellRef.TECH_HUB && neighborLandUse == landCellRef.SCHOOL) {
      return 0.6; // Tech companies love being near universities
    } else if ((currentLandUse >= landCellRef.RESIDENTIAL_LOW && currentLandUse <= landCellRef.RESIDENTIAL_HIGH) && neighborLandUse == landCellRef.AIRPORT) {
      return -0.3; // Nobody wants planes flying over their house
    } else if (currentLandUse == landCellRef.PARK && (neighborLandUse >= landCellRef.RESIDENTIAL_LOW && neighborLandUse <= landCellRef.RESIDENTIAL_HIGH)) {
      return 0.6; // Parks are better with people nearby to enjoy them
    } else if (currentLandUse == landCellRef.INDUSTRIAL && neighborLandUse == landCellRef.COMMERCIAL) {
      return 0.8; // Industry and commerce work very well together - increased compatibility
    } else if (currentLandUse == landCellRef.INDUSTRIAL && neighborLandUse == landCellRef.INDUSTRIAL) {
      return 0.7; // Industrial zones strongly cluster together - increased compatibility
    } else if (currentLandUse == landCellRef.COMMERCIAL && neighborLandUse == landCellRef.INDUSTRIAL) {
      return 0.6; // Businesses benefit greatly from supplying and servicing factories - increased compatibility
    } else if (currentLandUse == neighborLandUse) {
      return 0.2; // Similar land uses generally work okay together
    } else {
      return -0.1; // Most other combinations aren't ideal
    }
  }
  
  // Determines resource consumption based on land use
  int getResourceConsumption(int landUseType) 
  {
      if (landUseType == landCellRef.EMPTY_LAND) 
      {
          return 0; // Empty land doesn't use resources
      }
      else if (landUseType == landCellRef.RESIDENTIAL_LOW) 
      {
          return 5; // Single family homes use some resources
      }
      else if (landUseType == landCellRef.RESIDENTIAL_MID) 
      {
          return 10; // Townhouses use more resources
      }
      else if (landUseType == landCellRef.RESIDENTIAL_HIGH) 
      {
          return 15; // Apartment buildings are resource intensive
      }
      else if (landUseType == landCellRef.COMMERCIAL) 
      {
          return 12; // Shops and offices use quite a bit
      }
      else if (landUseType == landCellRef.INDUSTRIAL) 
      {
          return 25; // Factories are resource hogs
      }
      else if (landUseType == landCellRef.FARM) 
      {
          return 8; // Farms use moderate resources
      }
      else if (landUseType == landCellRef.FOREST) 
      {
          return -5; // Forests actually generate resources!
      }
      else if (landUseType == landCellRef.SCHOOL) 
      {
          return 8; // Schools use moderate resources
      }
      else if (landUseType == landCellRef.HOSPITAL) 
      {
          return 15; // Hospitals use lots of resources
      }
      else if (landUseType == landCellRef.GOVERNMENT) 
      {
          return 10; // Government buildings are somewhat resource intensive
      }
      else if (landUseType == landCellRef.PARK) 
      {
          return -2; // Parks generate a small amount of resources
      }
      else if (landUseType == landCellRef.WATER) 
      {
          return 0; // Water doesn't consume resources
      }
      else if (landUseType == landCellRef.AIRPORT) 
      {
          return 30; // Airports are extremely resource intensive
      }
      else if (landUseType == landCellRef.TECH_HUB) 
      {
          return 18; // Tech hubs use lots of energy and resources
      }
      else
      {
          return 5; // Default for unknown types
      }
  }
  
  // Determines land development potential - what should be built here?
  int determineBestLandUse(int row, int column) {
    // Count existing neighbors
    int[] neighborCounts = countNeighborLandUse(row, column);
    
    // Calculate different development scores based on neighbors and other factors
    float[] developmentScores = new float[15];
    
    // Current economic conditions affect development priorities
    float economicFactor = country.economy.currentGDP / 10000.0; // Scale GDP to usable range
    
    // Calculate population density factor
    float populationDensity = country.population.getPopulationDensity();
    
    // Housing need based on population
    float housingNeed = populationDensity * 0.8;
    
    // Baseline scores for different land uses adjusted for population and economic growth
    developmentScores[landCellRef.RESIDENTIAL_LOW] = 10 + housingNeed - (economicFactor * 0.1);
    developmentScores[landCellRef.RESIDENTIAL_MID] = 5 + (housingNeed * 0.8) + (economicFactor * 0.3);
    developmentScores[landCellRef.RESIDENTIAL_HIGH] = max(0, (housingNeed * 0.6) + (economicFactor * 0.5) - 5);
    
    // Shops and businesses grow with population and wealth
    developmentScores[landCellRef.COMMERCIAL] = (populationDensity * 0.4) + (economicFactor * 0.5);
    
    // Industry depends more on economic factors - further boosted to ensure more industrial zones
    developmentScores[landCellRef.INDUSTRIAL] = max(18, (economicFactor * 3.0)); // Significantly boosted base score to encourage more industrial zones
    
    // Farms become less important as economy grows
    developmentScores[landCellRef.FARM] = 15 + (populationDensity * 0.2) - (economicFactor * 0.3);
    
    // Richer countries care more about the environment
    developmentScores[landCellRef.FOREST] = 5 + (economicFactor * 0.05);
    
    // Special case: forests gradually become parks as cities grow
    if (country.cells[row][column].landUseType == landCellRef.FOREST) {
      // Several factors affect how likely forests become parks:
      // 1. Time passing (forests gradually become parks)
      // 2. Nearby housing (forests near homes become parks faster)
      // 3. Country development (rich countries make more parks)
      // 4. Government type (some value parks more than others)
      
      // More years = more parks
      float yearsFactor = (country.currentYear - 2020) * 0.5;
      
      // Is there housing nearby?
      boolean nearResidential = (neighborCounts[landCellRef.RESIDENTIAL_LOW] + neighborCounts[landCellRef.RESIDENTIAL_MID] + neighborCounts[landCellRef.RESIDENTIAL_HIGH]) > 0;
      float residentialFactor;
      if (nearResidential) {
        residentialFactor = 10.0;
      } else {
        residentialFactor = 2.0;
      }
      
      // How developed is the country?
      float developmentFactor = 1.0;
      if (country.countryType.equals("developed")) {
        developmentFactor = 1.5; // Rich countries love parks
      } else if (country.countryType.equals("developing")) {
        developmentFactor = 1.0; // Medium priority
      } else {
        developmentFactor = 0.5; // Poor countries have other priorities
      }
      
      // Different government types value parks differently
      float governmentFactor = 1.0;
      if (country.government.type.equals("democracy")) {
        governmentFactor = 1.2; // Democracies respond to public desire for parks
      } else if (country.government.type.equals("autocracy")) {
        governmentFactor = 0.9; // Autocracies care less about public spaces
      } else if (country.government.type.equals("socialist")) {
        governmentFactor = 1.1; // Socialists value public amenities
      } else if (country.government.type.equals("failed-state")) {
        governmentFactor = 1.0; // Even failed states can have parks
      }
      
      // Calculate the final park conversion score
      float parkConversionScore = (yearsFactor * residentialFactor * developmentFactor * governmentFactor) + 
      (populationDensity * 0.5); // Denser populations need more parks
      
      // Boost the park score based on our calculation
      developmentScores[landCellRef.PARK] += parkConversionScore * 3.0;
      
      // Make forests more likely to become parks than anything else
      for (int landType = 1; landType < 15; landType++) {
        if (landType != landCellRef.PARK && landType != landCellRef.FOREST) {
          developmentScores[landType] *= 0.5; // Cut other scores in half
        }
      }
    }
    
    // Count existing schools and hospitals in the country
    int schoolCount = 0;
    int hospitalCount = 0;
    for (int i = 0; i < country.gridWidth; i++) {
      for (int j = 0; j < country.gridWidth; j++) {
        if (country.cells[i][j].landUseType == landCellRef.SCHOOL) {
          schoolCount++;
        }
        if (country.cells[i][j].landUseType == landCellRef.HOSPITAL) {
          hospitalCount++;
        }
      }
    }
    
    // Education scales with both population, education level and economic growth
    // Different development patterns based on country type and economic stage
    float schoolDevFactor = 0;
    if (country.countryType.equals("developed")) {
      // Developed countries build more schools at all economic levels
      schoolDevFactor = 1.2;  
    } else if (country.countryType.equals("developing")) {
      // Developing countries scale up more with economic growth
      schoolDevFactor = 0.8 + (economicFactor / 40);
    } else { // underdeveloped
      // Underdeveloped countries need more economic growth before building schools
      schoolDevFactor = 0.5 + (economicFactor / 40);
    }
    
    // Give higher priority when no schools exist or not enough for population
    if (schoolCount == 0) {
      developmentScores[landCellRef.SCHOOL] = 25 + (populationDensity * 0.6);
    } else {
      // More schools as economy and population grow
      float schoolNeed = min(1.0, (populationDensity / 5000) * schoolDevFactor); 
      float econFactor = min(1.0, economicFactor / 25); 
      
      // Base school development probability with less diminishing returns
      developmentScores[landCellRef.SCHOOL] = (country.educationLevel * 0.1) + (populationDensity * 0.3) +max(0, 15 - (schoolCount * 2.0)) +(schoolNeed * 9) + (econFactor * 8);
      
      // Add school population capacity check - one school serves X people
      float populationPerSchool = country.population.count / max(1, schoolCount);
      float idealPopulationPerSchool = 60000;  // One school per 60k people is ideal 
      
      // Only encourage more schools if population per school is too high
      if (populationPerSchool > idealPopulationPerSchool) {
        float needFactor = min(5.0, populationPerSchool / idealPopulationPerSchool);
        developmentScores[landCellRef.SCHOOL] += needFactor * 3.0;
      } else {
        // If we have enough schools for the population, reduce score but not as dramatically
        developmentScores[landCellRef.SCHOOL] *= 0.6;
      }
      
      // Extra boost for growing economies
      if (country.economy.cumulativeGDPGrowth > 5) {
        developmentScores[landCellRef.SCHOOL] += country.economy.cumulativeGDPGrowth * 0.35;
      }
    }
    
    // Healthcare scales with population, healthcare quality and economic growth
    // Different development patterns based on country type and economic stage
    float hospitalDevFactor = 0;
    if (country.countryType.equals("developed")) {
      // Developed countries build more hospitals at all economic levels
      hospitalDevFactor = 1.0;
    } else if (country.countryType.equals("developing")) {
      // Developing countries scale up more with economic growth
      hospitalDevFactor = 0.7 + (economicFactor / 60);
    } else { // underdeveloped
      // Underdeveloped countries need more economic growth before building hospitals
      hospitalDevFactor = 0.2 + (economicFactor / 100); 
    }
    
    // Give higher priority when no hospitals exist or not enough for population
    if (hospitalCount == 0) {
      // Base priority varies by country type
      float basePriority;
      if (country.countryType.equals("underdeveloped")) {
        basePriority = 15;
      } else {
        basePriority = 22;
      }
      developmentScores[landCellRef.HOSPITAL] = basePriority + (populationDensity * 0.5);
    } else {
      // More hospitals as economy and population grow
      float hospitalNeed = min(1.0, (populationDensity / 6000) * hospitalDevFactor);
      float econFactor = min(1.0, economicFactor / 35);
      
      // Base hospital development probability with less diminishing returns
      developmentScores[landCellRef.HOSPITAL] = (country.healthcareQuality * 0.1) + (populationDensity * 0.3) +max(0, 12 - (hospitalCount * 2.0)) +(hospitalNeed * 10) + (econFactor * 8);
      
      // Add hospital population capacity check - one hospital serves X people
      float populationPerHospital = country.population.count / max(1, hospitalCount);
      float idealPopulationPerHospital;
      if (country.countryType.equals("underdeveloped")) {
        idealPopulationPerHospital = 150000;
      } else {
        idealPopulationPerHospital = 80000;
      } // Higher threshold for underdeveloped
      
      // Only encourage more hospitals if population per hospital is too high
      if (populationPerHospital > idealPopulationPerHospital) {
        float needFactor = min(5.0, populationPerHospital / idealPopulationPerHospital);
        developmentScores[landCellRef.HOSPITAL] += needFactor * 2.5;
      } else {
        // If we have enough hospitals for the population, reduce score
        developmentScores[landCellRef.HOSPITAL] *= 0.7;
      }
      
      // Significant boost for developed countries with strong economies
      if (country.countryType.equals("developed") && country.economy.currentGDP > 40000) {
        developmentScores[landCellRef.HOSPITAL] += 5;
      }
      
      // Extra boost for growing economies, but less for underdeveloped
      if (country.economy.cumulativeGDPGrowth > 8) {
        float growthBoost;
        if (country.countryType.equals("underdeveloped")) {
          growthBoost = 0.2;
        } else {
          growthBoost = 0.4;
        }
        developmentScores[landCellRef.HOSPITAL] += country.economy.cumulativeGDPGrowth * growthBoost;
      }
    }
    
    // Government buildings scale with population
    developmentScores[landCellRef.GOVERNMENT] = 5 + (country.socialStability * 0.05) + (populationDensity * 0.1);
    
    // Parks become more important as cities get denser - increased base score and population factor
    developmentScores[landCellRef.PARK] = 8 + (populationDensity * 0.4);
    
    // Advanced infrastructure requires higher development
    developmentScores[landCellRef.AIRPORT] = max(0, (economicFactor - 3) + (populationDensity * 0.05));
    
    // Tech hubs need high education and economic factors
    developmentScores[landCellRef.TECH_HUB] = max(0, ((economicFactor - 2) * country.innovationRate * 2) + (country.educationLevel * 0.1));
    
    // Adjust scores based on development level and adjacency rules
    
    // Only one airport per small country
    int airportCount = 0;
    for (int i = 0; i < country.gridWidth; i++) {
      for (int j = 0; j < country.gridWidth; j++) {
        if (country.cells[i][j].landUseType == landCellRef.AIRPORT) {
          airportCount++;
        }
      }
    }
    
    // Limit infrastructure based on country development
    if (airportCount >= 1 + int(economicFactor / 2)) {
      developmentScores[landCellRef.AIRPORT] = 0;
    }
    
    // Adjust scores based on neighbor compatibility
    for (int landType = 0; landType < 15; landType++) {
      for (int neighborType = 0; neighborType < 15; neighborType++) {
        if (neighborCounts[neighborType] > 0) {
          developmentScores[landType] += neighborCounts[neighborType] * getLandUseCompatibility(landType, neighborType);
        }
      }
    }
    
    // Apply government policy factors based on government type and development level
    if (country.government.type.equals("democracy")) {
      // Democracy - More balanced development
      developmentScores[landCellRef.RESIDENTIAL_LOW] *= 1.1;
      developmentScores[landCellRef.SCHOOL] *= 1.2;
      developmentScores[landCellRef.HOSPITAL] *= 1.2;
      developmentScores[landCellRef.PARK] *= 1.3; // Increased park development in democracies
      developmentScores[landCellRef.INDUSTRIAL] *= 2.0; // Significantly increased boost to industrial development in democracies
      
      // Additional modifiers based on development level
      if (country.countryType.equals("developed")) {
        developmentScores[landCellRef.TECH_HUB] *= 1.4;
        developmentScores[landCellRef.RESIDENTIAL_HIGH] *= 1.2;
        developmentScores[landCellRef.PARK] *= 1.2; // Even more parks in developed democracies
      } else if (country.countryType.equals("developing")) {
        developmentScores[landCellRef.RESIDENTIAL_MID] *= 1.3;
        developmentScores[landCellRef.COMMERCIAL] *= 1.2;
        developmentScores[landCellRef.INDUSTRIAL] *= 1.2; // More industry in developing democracies
      } else { // underdeveloped
        developmentScores[landCellRef.RESIDENTIAL_LOW] *= 1.4;
        developmentScores[landCellRef.FARM] *= 1.3;
        developmentScores[landCellRef.INDUSTRIAL] *= 1.1; // Some industry in underdeveloped democracies
      }
    } else if (country.government.type.equals("autocracy")) {
      // Autocracy - More industrial/commercial focus, less residential quality of life
      developmentScores[landCellRef.INDUSTRIAL] *= 2.5; // Further increased industrial development in autocracies
      developmentScores[landCellRef.COMMERCIAL] *= 1.2;
      developmentScores[landCellRef.GOVERNMENT] *= 1.5;
      developmentScores[landCellRef.PARK] *= 1.1; // Boosting parks for all government types
      
      // Additional modifiers based on development level
      if (country.countryType.equals("developed")) {
        developmentScores[landCellRef.TECH_HUB] *= 1.5;
        developmentScores[landCellRef.RESIDENTIAL_HIGH] *= 1.3;
        developmentScores[landCellRef.AIRPORT] *= 1.4;
      } else if (country.countryType.equals("developing")) {
        developmentScores[landCellRef.INDUSTRIAL] *= 1.3; // Even more industry in developing autocracies
        developmentScores[landCellRef.GOVERNMENT] *= 1.2;
        developmentScores[landCellRef.RESIDENTIAL_MID] *= 0.9; // Less mid-level housing
      } else { // underdeveloped
        developmentScores[landCellRef.INDUSTRIAL] *= 1.5; // Heavy focus on industry in underdeveloped autocracies
        developmentScores[landCellRef.RESIDENTIAL_LOW] *= 1.2;
        developmentScores[landCellRef.SCHOOL] *= 0.8; // Less education focus
      }
    } else if (country.government.type.equals("socialist")) {
      // Socialist - More equal housing, education, healthcare
      developmentScores[landCellRef.RESIDENTIAL_MID] *= 1.3;
      developmentScores[landCellRef.RESIDENTIAL_HIGH] *= 0.7;
      developmentScores[landCellRef.SCHOOL] *= 1.3;
      developmentScores[landCellRef.HOSPITAL] *= 1.3;
      developmentScores[landCellRef.GOVERNMENT] *= 1.2;
      developmentScores[landCellRef.INDUSTRIAL] *= 2.2; // Significantly increased boost to industrial development in socialist governments
      developmentScores[landCellRef.PARK] *= 1.2; // Added boost to parks in socialist governments
      
      // Additional modifiers based on development level
      if (country.countryType.equals("developed")) {
        developmentScores[landCellRef.RESIDENTIAL_MID] *= 1.2; // Even more mid-level housing
        developmentScores[landCellRef.HOSPITAL] *= 1.2; // More healthcare
        developmentScores[landCellRef.PARK] *= 1.3; // More parks
      } else if (country.countryType.equals("developing")) {
        developmentScores[landCellRef.INDUSTRIAL] *= 1.3; // More industry in developing socialist countries
        developmentScores[landCellRef.SCHOOL] *= 1.2; // More education
        developmentScores[landCellRef.FARM] *= 1.2; // More agriculture
      } else { // underdeveloped
        developmentScores[landCellRef.FARM] *= 1.5; // Heavy focus on agriculture
        developmentScores[landCellRef.INDUSTRIAL] *= 1.4; // Strong industrial focus
        developmentScores[landCellRef.RESIDENTIAL_LOW] *= 1.3; // More basic housing
      }
    } else if (country.government.type.equals("failed-state")) {
      // Failed State - Chaotic development
      developmentScores[landCellRef.RESIDENTIAL_LOW] *= 1.5;
      developmentScores[landCellRef.GOVERNMENT] *= 0.5;
      developmentScores[landCellRef.SCHOOL] *= 0.6;
      developmentScores[landCellRef.HOSPITAL] *= 0.6;
      developmentScores[landCellRef.INDUSTRIAL] *= 1.8; // Added boost to industrial development even in failed states
      developmentScores[landCellRef.PARK] *= 1.0; // Normalized park development in failed states
      
      // Additional modifiers based on development level
      if (country.countryType.equals("developed")) {
        // Even developed countries struggle under failed state conditions
        developmentScores[landCellRef.RESIDENTIAL_HIGH] *= 0.7; // Decline in high-end housing
        developmentScores[landCellRef.COMMERCIAL] *= 0.9; // Commercial decline
        developmentScores[landCellRef.INDUSTRIAL] *= 1.2; // Some industrial focus remains
      } else if (country.countryType.equals("developing")) {
        developmentScores[landCellRef.RESIDENTIAL_LOW] *= 1.3; // More low-end housing
        developmentScores[landCellRef.FARM] *= 1.1; // Some agricultural focus
        developmentScores[landCellRef.INDUSTRIAL] *= 1.3; // Unregulated industrial growth
      } else { // underdeveloped
        developmentScores[landCellRef.RESIDENTIAL_LOW] *= 1.6; // Heavy focus on basic housing
        developmentScores[landCellRef.FARM] *= 1.2; // Subsistence farming
        developmentScores[landCellRef.SCHOOL] *= 0.4; // Very little education development
      }
    } else if (country.government.type.equals("monarchy")) {
      // Monarchy - Mix of traditional and modern development
      developmentScores[landCellRef.GOVERNMENT] *= 1.4; // Strong government presence
      developmentScores[landCellRef.RESIDENTIAL_HIGH] *= 1.2; // More high-end housing
      developmentScores[landCellRef.RESIDENTIAL_LOW] *= 0.9; // Less low-end housing
      developmentScores[landCellRef.PARK] *= 1.2; // More parks and public spaces
      developmentScores[landCellRef.INDUSTRIAL] *= 1.4; // Strong industrial development
      
      // Additional modifiers based on development level
      if (country.countryType.equals("developed")) {
        developmentScores[landCellRef.TECH_HUB] *= 1.3; // Modern monarchies invest in technology
        developmentScores[landCellRef.COMMERCIAL] *= 1.3; // Strong commercial development
        developmentScores[landCellRef.AIRPORT] *= 1.3; // Better infrastructure
      } else if (country.countryType.equals("developing")) {
        developmentScores[landCellRef.RESIDENTIAL_MID] *= 1.2; // Growing middle class
        developmentScores[landCellRef.INDUSTRIAL] *= 1.3; // Industrial focus
        developmentScores[landCellRef.SCHOOL] *= 1.1; // Some education investment
      } else { // underdeveloped
        developmentScores[landCellRef.FARM] *= 1.3; // Agricultural focus
        developmentScores[landCellRef.GOVERNMENT] *= 1.3; // Strong government control
        developmentScores[landCellRef.INDUSTRIAL] *= 1.2; // Some industrial development
      }
    }
    
    // Find the highest scoring land use
    int bestLandUse = landCellRef.EMPTY_LAND;
    float highestScore = 0;
    for (int landType = 1; landType < 15; landType++) {
      if (developmentScores[landType] > highestScore) {
        highestScore = developmentScores[landType];
        bestLandUse = landType;
      }
    }
    
    // Make development more likely when economy or population is growing
    float developmentThreshold = max(1, 3 + random(5) - (country.population.count / 5000000) - (economicFactor / 10));
    
    // Threshold - don't develop if not enough demand
    if (highestScore < developmentThreshold) {
      return landCellRef.EMPTY_LAND;
    }
    
    return bestLandUse;
  }
}