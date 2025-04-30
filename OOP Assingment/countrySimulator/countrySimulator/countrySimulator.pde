/* Country Simulator 
   My OOP Assignment - Vijay Vijayaraja */

// This is the  main file - the heart of the simulation where everything comes together

// These variables will be accessible throughout the program
Country country;
UserInterface ui;

// feel free to experiment with these settings
String countryType = "developed";    // Try "developed", "developing", or "underdeveloped"
String governmentType = "democracy";  // Try "democracy", "socialist", "failed-state", "monarchy", or "autocracy"
int gridSize = 20;                    // This controls the map size - I wouldn't mess with this unless you want chaos

// How fast should  simulation run? 
int framerate = 5;                    // Higher = smoother but faster simulation
int tickSpeed = 2;                    // How many simulation updates per second

void settings() {
  size(1500, 1000);  
}

void setup() {
  frameRate(framerate);
  textAlign(CENTER, CENTER);
  
  // Create  country with the settings we chose above
  country = new Country(countryType, governmentType, gridSize);
  
  // Set up the interface so we can actually see what's happening
  ui = new UserInterface(country);
  
  // Using a fixed random seed means  get the same starting conditions each time
  randomSeed(42);
}

void draw() {
  // Only want to update the simulation a few times per second
  // Otherwise things would change too quickly to see what's happening
  if (frameCount % (framerate / tickSpeed) == 0 && !country.isPaused) {
    country.simulateNextCycle();
  }
  
  // Update the screen with the latest simulation state
  ui.draw();
}

// Basic controls
void keyPressed() {
  // Hit the spacebar to pause/unpause if things get too crazy
  if (key == ' ') {
    country.isPaused = !country.isPaused;
  }
}
