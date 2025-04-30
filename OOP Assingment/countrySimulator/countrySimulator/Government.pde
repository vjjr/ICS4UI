class Government {
  // Tracks government attributes including type, corruption level, efficiency and public approval
  String type;
  float corruptionLevel;
  float policyEfficiency;
  float publicApproval;
  
  // Constructor: initializes government parameters based on specified type
  Government(String type) {
    this.type = type;
    
    // Sets initial values for government attributes
    initializeGovernmentParams();
  }
  
  // Initializes government parameters with type-specific starting values
  void initializeGovernmentParams() {
    if (type.equals("democracy")) 
    {
      corruptionLevel = 0.3;
      policyEfficiency = 0.7;
      publicApproval = 0.6;
    } 
    else if (type.equals("autocracy")) 
    {
      corruptionLevel = 0.7;
      policyEfficiency = 0.5;
      publicApproval = 0.3;
    } 
    else if (type.equals("monarchy")) 
    {
      corruptionLevel = 0.5;
      policyEfficiency = 0.6;
      publicApproval = 0.5;
    } 
    else if (type.equals("socialist")) 
    {
      corruptionLevel = 0.6;
      policyEfficiency = 0.5;
      publicApproval = 0.4;
    } 
    else if (type.equals("failed-state")) 
    {
      corruptionLevel = 0.9;
      policyEfficiency = 0.1;
      publicApproval = 0.1;
    } 
    else 
    {
      type = "democracy";
      corruptionLevel = 0.3;
      policyEfficiency = 0.7;
      publicApproval = 0.6;
      println("Invalid government type, defaulting to democracy");
    }
  }
  
  // Updates public approval rating based on social stability, economic growth and education level
  void updatePublicApproval(float socialStability, float economicGrowth, float educationLevel) {
    float approvalChange = (socialStability / 500) + (economicGrowth / 50) + (educationLevel / 1000);
    
    if (type.equals("democracy")) 
    {
      approvalChange *= 1.2;
    } 
    else if (type.equals("autocracy")) 
    {
      approvalChange *= 0.6;
    } 
    else if (type.equals("failed-state")) 
    {
      approvalChange *= 0.3;
    }
    
    publicApproval = constrain(publicApproval + approvalChange, 0, 1);
  }
}