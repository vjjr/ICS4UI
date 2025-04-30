float angle = 0;  //angle controller
int centerX, centerY; //coords for screen
float colorOffset = 0; //contorller for colors

void setup() {
  size(800, 800); 
  centerX=width/2; //horizontal center
  centerY=height/2; //vertical center
  noFill(); // outlined shapes
  strokeWeight(2);  
}

void draw() {
  background(0); //black background
  
  //12 rotating arms
  for (int i=0;i<12;i++) {
    //get the raduis for the pulses
    float radius=100+150*sin(frameCount*0.02);
    
    //rgb color cycling using trig
    float r=127+127*sin(colorOffset);
    float g=127+127*sin(colorOffset+TWO_PI/3);
    float b=127+127*sin(colorOffset+TWO_PI/1.5);
    
    //getting the orbiting position
    float x=centerX+cos(angle+i)*radius;
    float y=centerY+sin(angle+i)*radius;
    
    //rotating line
    stroke(r,g,b);
    line(centerX,centerY,x,y);
    
    //draw pulsaing circles
    for (int j=0;j<5;j++) {
      float size=40+j*60+50*sin(frameCount*0.03);
      ellipse(x,y,size,size);
    }
  }
  
  //central vortex
  stroke(255);
  for (float a=0;a<TWO_PI*6;a+=0.05) {
    float spiralRad=20+a*8;
    float spiralX=centerX+cos(angle+a)*spiralRad;
    float spiralY=centerY+sin(angle+a)*spiralRad;
    point(spiralX, spiralY);
  }
  
 
  angle+=0.015;
  colorOffset+=0.02;
}
