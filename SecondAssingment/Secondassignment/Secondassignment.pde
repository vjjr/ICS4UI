// defines the number of balls per row and an array of RGB colour values
int ballsPerRow;
int distanceBetweenBall;
int ballDiameter = 50;
int width = 800;
int height = 800;
int[][] ballData; // the data parsed from the file (colour, margin from top)
int[][] rowCoordinates; // store the coordinate of the first ball in each row, to draw the lines later
boolean clicked = false;
int selectedRow = 0;
int selectedColumn = 0;

void setup() {
  // loads the data.txt file
  String[] data = loadStrings("data.txt");
  
  // defines the first row of data.txt as the given number of balls per row
  ballsPerRow = int(data[0]);
  distanceBetweenBall = width/(ballsPerRow+1); // defines distance between each ball, add one to make the balls centered on the screen

  ballData = new int[5][4]; // allocate memory for data parsed from file
  rowCoordinates = new int[5][2]; // allocate memory for ball coordinates tqo be used later to draw lines
  
  // parses through the file
  for ( int i = 0; i < data.length - 1; i++ ) {
    String[] coloursString = split(data[i+1], ' '); // splits the row by tab, ignoring the first row which is ballsPerRow
    for ( int j = 0; j < 4; j++ ) { // for each value (r, g, b, marginTop), add it to ballData
      ballData[i][j] = int(coloursString[j]);
    }
  }

  size(800, 800);

  // this loop calculates all of the positions of balls
  int marginTop = 0; // keeps track of the current margin from the top
  for ( int i = 0; i < ballData.length; i++ ) { // this loop calculates the coordinates of all of the balls
    marginTop += ballData[i][3] + ballDiameter/2; // calculates new margin top
    rowCoordinates[i][0] = distanceBetweenBall;
    rowCoordinates[i][1] = marginTop;
  }
}

void draw() {
  background(0); // black background

  // this loop draws all of the lines between the balls. this has to come first, since the balls have to be on top of the lines
  stroke(255); // white lines
  for ( int i = 0; i < rowCoordinates.length; i++ ) { // for each row of balls
    if (i != rowCoordinates.length - 1) { // if it isn't the last row,
      for ( int j = 0; j < ballsPerRow; j++ ) {
        for ( int k = 0; k < ballsPerRow; k++ ) {
          line(
            rowCoordinates[i][0] + distanceBetweenBall*j,
            rowCoordinates[i][1],
            rowCoordinates[i+1][0] + distanceBetweenBall*k,
            rowCoordinates[i+1][1]
          );
        }
      }
    }
  }

  // this loop draws all of the balls
  noStroke(); // borderless balls
  for ( int i = 0; i < rowCoordinates.length; i++ ) { // for each row of balls
    fill( ballData[i][0], ballData[i][1], ballData[i][2] ); // sets fill colour to the balls' colour from the data
    for ( int j = 0; j < ballsPerRow; j++ ){ // for each ball in that row
      circle( 
        rowCoordinates[i][0] + distanceBetweenBall*j, 
        rowCoordinates[i][1],
        ballDiameter 
      ); // draw a ball
    }
  }
}

void mousePressed() {
  for (int i = 0; i < rowCoordinates.length; i++) {
    for (int j = 0; j < ballsPerRow; j++) {
      if (
        dist(
          rowCoordinates[i][0] + distanceBetweenBall*j, 
          rowCoordinates[i][1], 
          mouseX, 
          mouseY
        ) < (ballDiameter / 2)
      ) {
        clicked = true;
        selectedRow = i;
        selectedColumn = j;
      }
    }
  }
}

void mouseReleased() {
  clicked = false;
}

void mouseDragged() {
  if (clicked) {
    for (int i = 0; i < rowCoordinates[selectedRow].length; i++) {
      rowCoordinates[selectedRow][0] = mouseX - distanceBetweenBall*selectedColumn;
      rowCoordinates[selectedRow][1] = mouseY;
    }
  }
}
