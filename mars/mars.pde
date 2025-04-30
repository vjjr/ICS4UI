//Paste this starter code

//INITIAL VALUES. TRY CHANGING THESE
float G = 5.10;       // Gravitational constant
float M = 800000.0;   // Mass of the sun
float m = 1.0;       // Mass of the Mars
float dt = 0.1;  // Time increment per frame (must be small for the approximation of the orbit to be accurate)
//float initRadius = 150;

PVector posSun = new PVector(400,400);
PVector posMars = new PVector(100, 400);

PVector velMars = new PVector(0, 30);


void setup() {
  background(0);
  size(800,800);
}

void draw() {
  background(0);
  fill(255,255,0);
  circle(posSun.x, posSun.y, 200);
 
  fill(255,50,50);
  circle(posMars.x, posMars.y, 50);
  PVector radiusVector=PVector.sub(posMars,posSun);
  PVector unitVector =radiusVector.normalize(null);
  
  float gravForce= -(G*M*m)/radiusVector.magSq(); // Newtons law of gravitation
  PVector F=PVector.mult(unitVector,gravForce);
  PVector a= PVector.div(F,m);
  
  PVector deltaV=PVector.mult(a,dt);
  velMars.add(deltaV);
  
  // Update posMar
  PVector deltaP=PVector.mult(velMars,dt);
  posMars.add(deltaP);
  
}
