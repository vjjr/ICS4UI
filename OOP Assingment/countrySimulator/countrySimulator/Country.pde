class Country {
  // Stores fundamental country attributes including type, year, and grid dimensions
  String countryType;
  int currentYear;
  int gridWidth;
  
  // Contains references to major simulation systems: government, economy, population and land management
  Government government;
  Economy economy;
  Population population;
  LandUseManager landManager;
  
  // 2D array representing the country's land grid with each cell tracking usage and resources
  LandCell[][] cells;
  
  
  // Simulation state flags for economic cycle and pause status
  boolean economicCycle; // This alternates between production and consumption phases
  boolean isPaused; // Controls whether the simulation is running or paused
  
  // Development metrics tracking education, healthcare, infrastructure, stability and innovation
  float educationLevel;
  float healthcareQuality;
  float infrastructureQuality;
  float socialStability;
  float innovationRate;
  
  // A simpler constructor if you just want to specify the country type
  Country(String countryType) {
    this(countryType, "democracy", 30); // Defaults to a democratic 30x30 country
  }
  
  // The full constructor with all the options
  Country(String countryType, String governmentType, int gridWidth) {
    this.countryType = countryType;
    this.gridWidth = gridWidth;
    this.currentYear = 2025;
    
    // Creates all systems that make up the country
    this.government = new Government(governmentType);
    this.economy = new Economy(this);
    this.population = new Population(this);
    this.landManager = new LandUseManager(this);
    
    // Sets up the grid of land cells
    cells = new LandCell[gridWidth][gridWidth];
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridWidth; j++) {
        cells[i][j] = new LandCell(i, j);
        cells[i][j].landUseType = cells[i][j].EMPTY_LAND;
      }
    }
    
    // Initial simulation settings
    economicCycle = true;
    isPaused = false;
    
    // Configures everything based on country type
    initializeCountryParams();
    
    // Generates geography and initial development
    initializeCountry();
    
    // Calculates starting social stability
    socialStability = calculateSocialStability();
  }
  
  // Set up country parameters based on development level
  void initializeCountryParams() {
    if (countryType.equals("developed")) 
    {
      economy.economicStability = 50000;
      innovationRate = 0.8;
      educationLevel = 40;
      healthcareQuality = 35;
      infrastructureQuality = 75;
    } 
    else if (countryType.equals("developing")) 
    {
      economy.economicStability = 10000;
      innovationRate = 0.5;
      educationLevel = 25;
      healthcareQuality = 20;
      infrastructureQuality = 40;
    } 
    else if (countryType.equals("underdeveloped")) 
    {
      economy.economicStability = 2000;
      innovationRate = 0.2;
      educationLevel = 10;
      healthcareQuality = 8;
      infrastructureQuality = 15;
    } 
    else 
    {
      println("Hey, that's not a valid country type!");
      exit();
    }

    // Start with a baseline stability score
    socialStability = 50;
    
    if (government.type.equals("democracy")) 
    {
      socialStability += 20 * government.publicApproval;
    } 
    else if (government.type.equals("autocracy")) 
    {
      socialStability += 10 * (1 - government.corruptionLevel) - 5;
    } 
    else if (government.type.equals("monarchy")) 
    {
      socialStability += 15 * (1 - government.corruptionLevel);
    } 
    else if (government.type.equals("socialist")) 
    {
      socialStability += 10 * (1 - government.corruptionLevel) + 5;
    } 
    else if (government.type.equals("failed-state")) 
    {
      socialStability -= 30;
    }
  }
  
  // Calculate how stable society is based on various factors
  float calculateSocialStability() {
    float stability = 50;
    if (government.type.equals("democracy")) 
    {
      stability += 20 * government.publicApproval;
    } 
    else if (government.type.equals("autocracy")) 
    {
      stability += 10 * (1 - government.corruptionLevel) - 5;
    } 
    else if (government.type.equals("monarchy")) 
    {
      stability += 15 * (1 - government.corruptionLevel);
    } 
    else if (government.type.equals("socialist")) 
    {
      stability += 10 * (1 - government.corruptionLevel) + 5;
    } 
    else if (government.type.equals("failed-state")) 
    {
      stability -= 30;
    }
    stability += (economy.currentGDP / 10000) * 5;
    stability += (educationLevel + healthcareQuality + infrastructureQuality) / 10;
    int schoolCount = 0;
    int hospitalCount = 0;
    // Count how many schools and hospitals we have
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridWidth; j++) {
        if (cells[i][j].landUseType == cells[i][j].SCHOOL) {
          schoolCount++;
        }
        if (cells[i][j].landUseType == cells[i][j].HOSPITAL) {
          hospitalCount++;
        }
      }
    }
    stability += (schoolCount * 1.5);
    stability += (hospitalCount * 2.0);
    return constrain(stability, 0, 100);
  }
  
  // Create the country's initial geography and development
  void initializeCountry() {
    // Start with a blank slate - all empty land with full resources
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridWidth; j++) {
        cells[i][j].resourceLevel = 100;
        cells[i][j].landUseType = cells[i][j].EMPTY_LAND;
      }
    }
    
    // Add some lakes and rivers
    createWaterBodies();
    
    // Sprinkle in some forests
    createForests();
    
    // Farms
    createFarms();
    
    // Build some cities 
    createCities();
    
    // Add infrastructure based on the development level
    addInfrastructure();
  }
  
  // Create some lakes and rivers for the landscape
  void createWaterBodies() {
    int numWaterBodies = int(random(1, 4));
    for (int w = 0; w < numWaterBodies; w++) {
      int waterX = int(random(gridWidth));
      int waterY = int(random(gridWidth));
      int waterSize = int(random(3, 8));
      
      // Make the water body with some randomness for natural looking shapes
      for (int wx = -waterSize/2; wx < waterSize/2; wx++) {
        for (int wy = -waterSize/2; wy < waterSize/2; wy++) {
          int nx = waterX + wx;
          int ny = waterY + wy;
          
          // Make sure its still on the map
          if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth) {
            // Real lakes aren't perfect circles - add some randomness
            if (random(100) < 70) {
              cells[nx][ny].landUseType = cells[nx][ny].WATER;
              cells[nx][ny].resourceLevel = 0; // Can't farm underwater!
            }
          }
        }
      }
      
      // Sometimes add a river flowing from the lake
      if (waterSize > 5 && random(100) < 70) {
        createRiver(waterX, waterY);
      }
    }
  }
  
  // Create a winding river starting from a water body
  void createRiver(int startX, int startY) {
    int riverLength = int(random(5, gridWidth));
    int direction = int(random(4)); // 0=North, 1=East, 2=South, 3=West
    int rx = startX;
    int ry = startY;
    
    for (int r = 0; r < riverLength; r++) {
      // Move in the main direction
      if (direction == 0) {
        ry -= 1;
      } else if (direction == 1) {
        rx += 1;
      } else if (direction == 2) {
        ry += 1;
      } else {
        rx -= 1;
      }
      
      // Make the river meander a bit - real rivers aren't straight
      if (random(100) < 30) {
        if (random(100) < 50) {
          if (random(-1, 1) > 0) {
            rx += 1;
          } else {
            rx += -1;
          }
        } else {
          if (random(-1, 1) > 0) {
            ry += 1;
          } else {
            ry += -1;
          }
        }
      }
      
      // Check if its still on the map
      if (rx >= 0 && rx < gridWidth && ry >= 0 && ry < gridWidth) {
        cells[rx][ry].landUseType = cells[rx][ry].WATER;
        cells[rx][ry].resourceLevel = 0;
      } else {
        break; // If river flowed off the map
      }
    }
  }
  
  // Add some forests to the landscape
  void createForests() {
    int numForests = int(random(3, 8));
    for (int f = 0; f < numForests; f++) {
      int forestX = int(random(gridWidth));
      int forestY = int(random(gridWidth));
      int forestSize = int(random(3, 6));
      
      // Create a natural-looking clump of forest
      for (int fx = -forestSize/2; fx < forestSize/2; fx++) {
        for (int fy = -forestSize/2; fy < forestSize/2; fy++) {
          int nx = forestX + fx;
          int ny = forestY + fy;
          
          // Check boundaries and make sure it's not on water
          if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth && 
              cells[nx][ny].landUseType != cells[nx][ny].WATER) {
            // Give forests natural-looking edges
            if (random(100) < 70) {
              cells[nx][ny].landUseType = cells[nx][ny].FOREST;
            }
          }
        }
      }
    }
  }
  
  // Create agricultural areas to feed the population
  void createFarms() {
    int farmCount = 0;
    if (countryType.equals("developed")) {
      farmCount = int(random(5, 10)); // Developed countries have fewer, more efficient farms
    } else if (countryType.equals("developing")) {
      farmCount = int(random(10, 20)); // Developing countries have more farms
    } else if (countryType.equals("underdeveloped")) {
      farmCount = int(random(15, 25)); // Underdeveloped countries rely heavily on agriculture
    }
    
    for (int f = 0; f < farmCount; f++) {
      int fx = int(random(gridWidth));
      int fy = int(random(gridWidth));
      
      if (cells[fx][fy].landUseType == cells[fx][fy].EMPTY_LAND) {
        cells[fx][fy].landUseType = cells[fx][fy].FARM;
        
        // Farms tend to cluster together in agricultural regions
        if (random(100) < 60) {
          for (int d = 0; d < 8; d++) {
            int nx = fx + landManager.directions[d][0];
            int ny = fy + landManager.directions[d][1];
            if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth && 
               cells[nx][ny].landUseType == cells[nx][ny].EMPTY_LAND && random(100) < 70) {
              cells[nx][ny].landUseType = cells[nx][ny].FARM;
            }
          }
        }
      }
    }
  }
  
  // Now create some cities for people to live in
  void createCities() {
    // Set initial population based on country type
    if (countryType.equals("developed")) {
      population.count = 250000 + random(500000);  // 250k-750k
    } else if (countryType.equals("developing")) {
      population.count = 150000 + random(350000);  // 150k-500k
    } else if (countryType.equals("underdeveloped")) {
      population.count = 50000 + random(200000);   // 50k-250k
    }
    
    // Keep track if already added at least one school and one hospital
    boolean addedAnySchool = false;
    boolean addedAnyHospital = false;
    
    // Set number of schools and hospitals based on development level
    int targetSchoolCount = 0;
    int targetHospitalCount = 0;
    
    if (countryType.equals("developed")) {
      targetSchoolCount = 2 + int(random(2));    // 2-3 schools 
      targetHospitalCount = 1 + int(random(2));  // 1-2 hospitals
    } else if (countryType.equals("developing")) {
      targetSchoolCount = 1 + int(random(1));    // 1-2 schools 
      targetHospitalCount = 1;                   // Just 1 hospital
    } else { // underdeveloped
      targetSchoolCount = 1;                     // Just 1 school
      targetHospitalCount = 1;                   // Just 1 hospital
    }
    
    int schoolsAdded = 0;
    int hospitalsAdded = 0;
    
    for (int c = 0; c < 5; c++) {
      boolean validLocation = false;
      int cx = 0;
      int cy = 0;
      
      // Find a spot for a city that makes sense
      int attempts = 0;
      while (!validLocation && attempts < 50) {
        cx = int(random(gridWidth));
        cy = int(random(gridWidth));
        
        // Can't build a city on water and need some space
        if (cells[cx][cy].landUseType != cells[cx][cy].WATER) {
          boolean hasSpace = true;
          
          // Check surrounding area
          for (int dx = -1; dx <= 1; dx++) {
            for (int dy = -1; dy <= 1; dy++) {
              int nx = cx + dx;
              int ny = cy + dy;
              if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth) {
                if (cells[nx][ny].landUseType != cells[nx][ny].EMPTY_LAND && cells[nx][ny].landUseType != cells[nx][ny].FOREST && cells[nx][ny].landUseType != cells[nx][ny].FARM) {
                  hasSpace = false;
                }
              }
            }
          }
          
          validLocation = hasSpace;
        }
        attempts++;
      }
      
      if (validLocation) {
        // City center gets a government building
        cells[cx][cy].landUseType = cells[cx][cy].GOVERNMENT;
        
        // Put some commercial areas around the government
        for (int d = 0; d < 8; d++) {
          int nx = cx + landManager.directions[d][0];
          int ny = cy + landManager.directions[d][1];
          if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth && cells[nx][ny].landUseType != cells[nx][ny].WATER) {
            cells[nx][ny].landUseType = cells[nx][ny].COMMERCIAL;
          }
        }
        
        // Bigger populations = bigger cities
        int citySize = int(3 + (population.count / 100000) * 0.2);
        
        // Add homes around the commercial center
        for (int dx = -citySize; dx <= citySize; dx++) {
          for (int dy = -citySize; dy <= citySize; dy++) {
            if (abs(dx) > 1 || abs(dy) > 1) { // Skip the commercial center
              int nx = cx + dx;
              int ny = cy + dy;
              if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth && cells[nx][ny].landUseType == cells[nx][ny].EMPTY_LAND) {
                
                // Different housing types based on country wealth
                if (countryType.equals("developed")) {
                  if (random(100) < 30) {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_HIGH; // Apartments
                  } else if (random(100) < 60) {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_MID; // Townhouses
                  } else {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_LOW; // Houses
                  }
                }
                // Developing countries have mostly low/mid density
                else if (countryType.equals("developing")) {
                  if (random(100) < 10) {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_HIGH;
                  } else if (random(100) < 40) {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_MID;
                  } else {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_LOW;
                  }
                } 
                // Underdeveloped countries are mostly low density homes
                else {
                  if (random(100) < 80) {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_LOW;
                  } else {
                    cells[nx][ny].landUseType = cells[nx][ny].RESIDENTIAL_MID;
                  }
                }
              }
            }
          }
        }
        
        // Add education and healthcare based on country development level
        boolean addedSchool = false;
        boolean addedHospital = false;
        
        // First city always gets at least one school and hospital
        boolean firstCityPriority = (c == 0);
        
        // Different probabilities based on development level and how many we've already added
        float schoolProbability = 0;
        float hospitalProbability = 0;
        
        if (firstCityPriority) {
          // First city always gets these (100% chance)
          schoolProbability = 100;
          hospitalProbability = 100;
        } else {
          // Probabilities for subsequent cities depend on country type
          if (countryType.equals("developed")) {
            schoolProbability = 80 - (schoolsAdded * 15);  // Starts at 80%, decreases as we add more
            hospitalProbability = 70 - (hospitalsAdded * 20); // Starts at 70%, decreases as we add more
          } else if (countryType.equals("developing")) {
            schoolProbability = 60 - (schoolsAdded * 30);  // Starts at 60%, decreases faster
            hospitalProbability = 50 - (hospitalsAdded * 35); // Starts at 50%, decreases faster
          } else { // underdeveloped
            schoolProbability = 40 - (schoolsAdded * 40);  // Just 40% chance after first city
            hospitalProbability = 30 - (hospitalsAdded * 40); // Only 30% chance after first city
          }
        }
        
        // Always add at least one school and hospital in total
        boolean mustAddSchool = (c == 4 && !addedAnySchool);
        boolean mustAddHospital = (c == 4 && !addedAnyHospital);
        
        // Look for spots to add schools and hospitals
        for (int dx = -4; dx <= 4 && (!addedSchool || !addedHospital); dx++) {
          for (int dy = -4; dy <= 4 && (!addedSchool || !addedHospital); dy++) {
            int nx = cx + dx;
            int ny = cy + dy;
            
            if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth && 
               cells[nx][ny].landUseType == cells[nx][ny].EMPTY_LAND) {
              
              // Add school if probability check passes or if forced to
              if (!addedSchool && (random(100) < schoolProbability || mustAddSchool) && schoolsAdded < targetSchoolCount) {
                cells[nx][ny].landUseType = cells[nx][ny].SCHOOL;
                addedSchool = true;
                addedAnySchool = true;
                schoolsAdded++;
              } 
              // Add hospital if probability check passes or if  forced to
              else if (!addedHospital && (random(100) < hospitalProbability || mustAddHospital) && hospitalsAdded < targetHospitalCount) {
                cells[nx][ny].landUseType = cells[nx][ny].HOSPITAL;
                addedHospital = true;
                addedAnyHospital = true;
                hospitalsAdded++;
              }
            }
          }
        }
        
        // Gotta have some factories too 
        int industryCount;
        if (countryType.equals("developed")) {
          industryCount = 5; 
        } else if (countryType.equals("developing")) {
          industryCount = 7; 
        } else {
          industryCount = 6; 
        }
        
        // Create industrial cluster with higher priority
        for (int i = 0; i < industryCount; i++) {
          int nx = cx + int(random(-6, 6)); // Wider range for placement
          int ny = cy + int(random(-6, 6));
          
          if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth && 
             cells[nx][ny].landUseType == cells[nx][ny].EMPTY_LAND) {
            cells[nx][ny].landUseType = cells[nx][ny].INDUSTRIAL;
            
            // Add chance for adjacent industrial zones to create industrial clusters
            if (random(100) < 60) { // 60% chance to create adjacent industrial
              for (int d = 0; d < 3; d++) { // Try up to 3 adjacent cells
                int adjDir = int(random(8));
                int adjX = nx + landManager.directions[adjDir][0];
                int adjY = ny + landManager.directions[adjDir][1];
                
                if (adjX >= 0 && adjX < gridWidth && adjY >= 0 && adjY < gridWidth && 
                   cells[adjX][adjY].landUseType == cells[adjX][adjY].EMPTY_LAND) {
                  cells[adjX][adjY].landUseType = cells[adjX][adjY].INDUSTRIAL;
                  break; // Only add one adjacent industrial zone
                }
              }
            }
          }
        }
        
        // Add a nice park
        int px = cx + int(random(-3, 3));
        int py = cy + int(random(-3, 3));
        
        if (px >= 0 && px < gridWidth && py >= 0 && py < gridWidth && 
           cells[px][py].landUseType == cells[px][py].EMPTY_LAND) {
          cells[px][py].landUseType = cells[px][py].PARK;
        }
      }
    }
    
    // still don't have at least one school and hospital, force-add them
    if (!addedAnySchool || !addedAnyHospital) {
      for (int i = 0; i < gridWidth && (!addedAnySchool || !addedAnyHospital); i++) {
        for (int j = 0; j < gridWidth && (!addedAnySchool || !addedAnyHospital); j++) {
          if (cells[i][j].landUseType == cells[i][j].EMPTY_LAND || cells[i][j].landUseType == cells[i][j].PARK) {
            if (!addedAnySchool) {
              cells[i][j].landUseType = cells[i][j].SCHOOL;
              addedAnySchool = true;
            } else if (!addedAnyHospital) {
              cells[i][j].landUseType = cells[i][j].HOSPITAL;
              addedAnyHospital = true;
            }
          }
        }
      }
    }
  }
  
  // Add some transportation and other infrastructure
  void addInfrastructure() {
    // Rich countries need airports!
    if (countryType.equals("developed") || (countryType.equals("developing") && random(100) < 50)) {
      boolean airportPlaced = false;
      int attempts = 0;
      
      while (!airportPlaced && attempts < 100) {
        int ax = int(random(gridWidth));
        int ay = int(random(gridWidth));
        
        if (cells[ax][ay].landUseType == cells[ax][ay].EMPTY_LAND) {
          cells[ax][ay].landUseType = cells[ax][ay].AIRPORT;
          airportPlaced = true;
          
          // Airports attract commercial development
          for (int d = 0; d < 8; d++) {
            int nx = ax + landManager.directions[d][0];
            int ny = ay + landManager.directions[d][1];
            if (nx >= 0 && nx < gridWidth && ny >= 0 && ny < gridWidth && 
               cells[nx][ny].landUseType == cells[nx][ny].EMPTY_LAND && random(100) < 70) {
              cells[nx][ny].landUseType = cells[nx][ny].COMMERCIAL;
            }
          }
        }
        attempts++;
      }
      
      if (!airportPlaced) {
        // Couldn't find a good spot, just put it anywhere
        for (int i = 0; i < gridWidth && !airportPlaced; i++) {
          for (int j = 0; j < gridWidth && !airportPlaced; j++) {
            if (cells[i][j].landUseType == cells[i][j].EMPTY_LAND) {
              cells[i][j].landUseType = cells[i][j].AIRPORT;
              airportPlaced = true;
            }
          }
        }
      }
    }
  }
  
  // Run one cycle of the simulation
  void simulateNextCycle() {
    // Don't do anything if paused
    if (isPaused) {
      return;
    }
    
    // Increment the year
    currentYear++;
    
    // Consumption and resource depletion phase
    if (economicCycle) {
      // Move time forward
      currentYear++;
      
      // Update  systems
      population.update();
      economy.update();
      
      // Update  social metrics based on how things are going
      float developmentRate = (economy.cumulativeGDPGrowth * government.policyEfficiency) / 100;
      
      // Count how many schools and hospitals
      int schoolCount = 0;
      int hospitalCount = 0;
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridWidth; j++) {
          if (cells[i][j].landUseType == cells[i][j].SCHOOL) schoolCount++;
          if (cells[i][j].landUseType == cells[i][j].HOSPITAL) hospitalCount++;
        }
      }
      
      // Education and healthcare quality are highly dependent on actual facilities
      if (schoolCount == 0) {
        // Without schools, education can only reach a limited level based on economic development
        educationLevel = min(40, educationLevel + (developmentRate * 0.2 * (1 - government.corruptionLevel)));
      } else {
        // With schools, education can improve more substantially
        educationLevel = min(100, educationLevel + developmentRate * (1 - government.corruptionLevel) + (schoolCount * 0.2));
      }
      
      if (hospitalCount == 0) {
        // Without hospitals, healthcare can only reach a limited level
        healthcareQuality = min(35, healthcareQuality + (developmentRate * 0.15 * (1 - government.corruptionLevel/2)));
      } else {
        // With hospitals, healthcare can improve significantly
        healthcareQuality = min(100, healthcareQuality + developmentRate * (1 - government.corruptionLevel/2) + (hospitalCount * 0.2));
      }
      
      infrastructureQuality = min(100, infrastructureQuality + developmentRate * government.policyEfficiency);
      
      // Recalculate stability
      socialStability = calculateSocialStability();
      
      // Use up resources based on land use
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridWidth; j++) {
          int consumption = landManager.getResourceConsumption(cells[i][j].landUseType);
          cells[i][j].resourceLevel = max(0, cells[i][j].resourceLevel - consumption);
        }
      }
      
      economicCycle = false;
    } 
    // Development and resource regeneration phase
    else { 
      // Higher chance of development in rich countries
      float developmentProbability = min(40, 5 + (economy.currentGDP / 10000) + (population.count / 1000000));
      
      // Look for land to develop
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridWidth; j++) {
          // Can't develop water
          if (cells[i][j].landUseType == cells[i][j].WATER) {
            continue;
          }
          
          // Empty land can be developed into anything
          if (cells[i][j].landUseType == cells[i][j].EMPTY_LAND) {
            if (random(100) < developmentProbability) {
              // What should we build here?
              int newLandUse = landManager.determineBestLandUse(i, j);
              if (newLandUse != cells[i][j].EMPTY_LAND) {
                cells[i][j].landUseType = newLandUse;
              }
            }
          }
          
          // Forests can only be converted to parks
          if (cells[i][j].landUseType == cells[i][j].FOREST) {
            if (random(100) < developmentProbability) {
              // Check if this forest should become a park
              int newLandUse = landManager.determineBestLandUse(i, j);
              if (newLandUse == cells[i][j].PARK) {
                cells[i][j].landUseType = cells[i][j].PARK;
              }
            }
          }
          
          updateLandUse(i, j);
        }
      }
      
      // Let nature recover a bit
      for (int i = 0; i < gridWidth; i++) {
        for (int j = 0; j < gridWidth; j++) {
          // Water doesn't regenerate resources
          if (cells[i][j].landUseType == cells[i][j].WATER) {
            continue;
          }
          
          // Different regeneration rates based on land use
          float regenerationRate = 0;
          
          if (cells[i][j].landUseType == cells[i][j].FOREST) {
            regenerationRate = 3; // Forests are great for the environment
          } else if (cells[i][j].landUseType == cells[i][j].PARK) {
            regenerationRate = 2; // Parks are pretty good
          } else if (cells[i][j].landUseType == cells[i][j].FARM) {
            regenerationRate = 1.5; // Farms can be sustainable
          } else if (cells[i][j].landUseType == cells[i][j].EMPTY_LAND) {
            regenerationRate = 1; // Nature slowly heals
          } else {
            // Cities, factories, etc. don't help much
            regenerationRate = 0.1;
          }
          
          // Forests nearby help everything regenerate
          int[] neighbors = landManager.countNeighborLandUse(i, j);
          regenerationRate += neighbors[cells[i][j].FOREST] * 0.3;
          
          // Apply regeneration
          cells[i][j].resourceLevel = min(100, cells[i][j].resourceLevel + int(regenerationRate));
        }
      }
      
      economicCycle = true;
    }
  }
  

  // Update and potentially upgrade buildings
void updateLandUse(int i, int j) {
    // Upgrade residential areas as economy improves
    if (cells[i][j].landUseType == cells[i][j].RESIDENTIAL_LOW && economy.currentGDP > 15000 && random(100) < 5) {
      cells[i][j].landUseType = cells[i][j].RESIDENTIAL_MID;
    } else if (cells[i][j].landUseType == cells[i][j].RESIDENTIAL_MID && economy.currentGDP > 30000 && random(100) < 5) {
      cells[i][j].landUseType = cells[i][j].RESIDENTIAL_HIGH;
    }
    
    // Add tech hubs in developed areas - only in commercial zones with high education and GDP
    if (cells[i][j].landUseType == cells[i][j].COMMERCIAL && economy.currentGDP > 20000 && educationLevel > 60 && random(100) < 5) {
      if (random(100) < 40) {
        cells[i][j].landUseType = cells[i][j].TECH_HUB;
      }
    }
    else if (cells[i][j].landUseType == cells[i][j].COMMERCIAL && random(100) < 3) {
      int schoolCount = 0;
      int hospitalCount = 0;
      for (int x = 0; x < gridWidth; x++) {
        for (int y = 0; y < gridWidth; y++) {
          if (cells[x][y].landUseType == cells[x][y].SCHOOL) {
            schoolCount++;
          }
          if (cells[x][y].landUseType == cells[x][y].HOSPITAL) {
            hospitalCount++;
          }
        }
      }
      float populationPerSchool = population.count / max(1, schoolCount);
      float populationPerHospital = population.count / max(1, hospitalCount);
      
      if (countryType.equals("developed") && populationPerSchool > 60000 && random(100) < 60) {
        cells[i][j].landUseType = cells[i][j].SCHOOL;
      }
      else if (countryType.equals("developing") && populationPerSchool > 80000 && random(100) < 50) {
        cells[i][j].landUseType = cells[i][j].SCHOOL;
      }
      else if (countryType.equals("developed") && populationPerHospital > 70000 && random(100) < 50) {
        cells[i][j].landUseType = cells[i][j].HOSPITAL;
      }
      else if (countryType.equals("developing") && populationPerHospital > 100000 && random(100) < 40) {
        cells[i][j].landUseType = cells[i][j].HOSPITAL;
      }
    }
    else if (cells[i][j].landUseType == cells[i][j].INDUSTRIAL && economy.currentGDP > 25000 && random(100) < 4) {
      cells[i][j].resourceLevel = min(100, cells[i][j].resourceLevel + 10);
    }
    else if (cells[i][j].landUseType == cells[i][j].FARM && educationLevel > 50 && random(100) < 3) {
      cells[i][j].resourceLevel = min(100, cells[i][j].resourceLevel + 15);
    }
    else if ((cells[i][j].landUseType == cells[i][j].SCHOOL || cells[i][j].landUseType == cells[i][j].HOSPITAL) && economy.currentGDP > 20000 && random(100) < 3) {
      educationLevel += 0.05;
      healthcareQuality += 0.05;
    }
    else if ((cells[i][j].landUseType == cells[i][j].COMMERCIAL || cells[i][j].landUseType == cells[i][j].INDUSTRIAL) &&  educationLevel > 70 && innovationRate > 0.5 && random(100) < 2) {
      cells[i][j].landUseType = cells[i][j].TECH_HUB;
    }
}
  
}
