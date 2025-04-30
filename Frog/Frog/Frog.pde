//ENVIRONMENT
float xCliff = 500;
float yGround = 250;
float yPool = 610;
float g = 9.81;
float dt = 0.1;

//FROG'S STARTING MOTION
PVector pos = new PVector( 0, yGround );
PVector v = new PVector( 0, 0 );
PVector accRiding = new PVector( 2.1, 0 );
PVector accFalling = new PVector( 0, g );    //CHANGED TO USE GRAVITY
PVector deltaPos, deltaV;

//THE ANIMATION CAN BE IN 3 MODES
String mode = "riding";   //or "falling" or "splashing"

//FROG IMAGE
PImage frog;
int frogSize = 80;

//WATER & SPLASH VARIABLES
int numDrops = 300;
PVector[] dropPositions, dropVelocities;
boolean hitWater = false;
color waterColor = color(0, 50, 150);


void setup() {
  size(1000, 700);
  noStroke();

  frog = loadImage( "frog.png" );
  frog.resize( frogSize, frogSize );
 
  dropPositions = new PVector[ numDrops ];
  dropVelocities = new PVector[ numDrops ];
}


void draw() {
  background( 70, 240, 255 );

  //DRAW STUFF
  drawGround();
  drawFrog();
  drawPool();
 
  //UPDATE FROG POSITION USING ITS CURRENT VELOCITY
  deltaPos = PVector.mult(v, dt);
  pos.add( deltaPos );


  //UPDATE FROG VELOCITY USING ITS CURRENT ACCELERATION
  if ( mode.equals("riding") ) {
    deltaV = PVector.mult(accRiding, dt);
    v.add( deltaV );
  }
 
  else if ( mode.equals("falling") ) {
    deltaV = PVector.mult(accFalling, dt);  
    v.add( deltaV );
  }
 
  else if ( mode.equals("splashing") ) {
    v.set(3, 6); //Frog sinks slowly, no longer accelerating
   
    drawDrops();

    //UPDATE THE DROPS' POSITIONS AND VELOCITIES
    for (int i = 0; i < numDrops; i++ ) {
      dropVelocities[i].y += g * dt;  //ADDED GRAVITY TO DROPS
      dropPositions[i].add(PVector.mult(dropVelocities[i], dt));
    }
  }


  //SWITCH FROM RIDING TO FALLING, OR FROM FALLING TO SPLASHING WHEN THE MOMENT IS RIGHT
  if ( pos.x > xCliff && pos.y < yPool ) {
    mode = "falling";
  }
 
  else if ( pos.x > xCliff && pos.y >= yPool  ) {
    mode = "splashing";

    //AS SOON AS THE FROG HITS THE WATER, RANDOMIZE THE DROPS' STARTING POSITIONS & VELOCITIES
    if ( !hitWater ) {
      for (int i = 0; i< numDrops; i++) {
        float randomX = random( pos.x-10, pos.x+10 );
        float randomAngle = random(PI/12, PI-PI/4);
        float randomSpeed = random(20, 50);
       
        dropPositions[i] = new PVector( randomX, yPool );
        dropVelocities[i] = new PVector( randomSpeed*cos(randomAngle), -randomSpeed*sin(randomAngle)  );
      }

      hitWater = true; //SO THAT WE ONLY RUN THE ABOVE ONCE
    }
  }
}


void drawGround() {
  fill(200, 100, 80);
  rect(0, yGround, xCliff, height);
}


void drawFrog() {
  image( frog, pos.x, pos.y - frogSize + 12 );
}


void drawPool() {
  fill( waterColor );
  rect( xCliff, yPool, width, height );
}


void drawDrops() {
  fill( waterColor );
 
  for (int i = 0; i < numDrops; i++ ) {
    circle( dropPositions[i].x, dropPositions[i].y, random(3, 8) );
  }
}
