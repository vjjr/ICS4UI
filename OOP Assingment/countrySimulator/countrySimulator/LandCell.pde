class LandCell {
  // Stores land cell attributes including coordinates, land use type and resource level
  int row;
  int col;
  int landUseType;
  int resourceLevel;
  
  // Constants representing all possible land use types in the simulation
  int EMPTY_LAND = 0;
  int RESIDENTIAL_LOW = 1;
  int RESIDENTIAL_MID = 2;
  int RESIDENTIAL_HIGH = 3;
  int COMMERCIAL = 4;
  int INDUSTRIAL = 5;
  int FARM = 6;
  int FOREST = 7;
  int SCHOOL = 8;
  int HOSPITAL = 9;
  int GOVERNMENT = 10;
  int PARK = 11;
  int WATER = 12;
  int AIRPORT = 13;
  int TECH_HUB = 14;
  
  // Constructor: initializes cell with specified coordinates and default values
  LandCell(int row, int col) {
    this.row = row;
    this.col = col;
    this.landUseType = this.EMPTY_LAND;
    this.resourceLevel = 100;
  }
  
  // Provides names for each land use type constant
  String getLandUseName() {
    if (landUseType == EMPTY_LAND) 
    {
      return "Undeveloped Land";
    }
    else if (landUseType == RESIDENTIAL_LOW) 
    {
      return "Low-Density Housing";
    }
    else if (landUseType == RESIDENTIAL_MID) 
    {
      return "Medium-Density Housing";
    }
    else if (landUseType == RESIDENTIAL_HIGH) 
    {
      return "High-Density Housing";
    }
    else if (landUseType == COMMERCIAL) 
    {
      return "Commercial Zone";
    }
    else if (landUseType == INDUSTRIAL) 
    {
      return "Industrial Zone";
    }
    else if (landUseType == FARM) 
    {
      return "Agricultural Land";
    }
    else if (landUseType == FOREST) 
    {
      return "Forest";
    }
    else if (landUseType == SCHOOL) 
    {
      return "Education Institution";
    }
    else if (landUseType == HOSPITAL) 
    {
      return "Healthcare Facility";
    }
    else if (landUseType == GOVERNMENT) 
    {
      return "Government Building";
    }
    else if (landUseType == PARK) 
    {
      return "Park/Recreation";
    }
    else if (landUseType == WATER) 
    {
      return "Water Body";
    }
    else if (landUseType == AIRPORT) 
    {
      return "Airport";
    }
    else if (landUseType == TECH_HUB) 
    {
      return "Technology Hub";
    }
    else 
    {
      return "Unknown";
    }
  }
}