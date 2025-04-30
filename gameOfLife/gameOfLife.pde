// Instructions for keyboard shortcuts
// Space: Start/Stop simulation
// R: Random pattern
// X: Reset board
// C: Checkerboard pattern


int xSquareCount=50;
int ySquareCount=50;
int fps=10;
boolean shouldShowGrid=true;
color deadColor=color(100,100,100); // Gray background
color liveColor=color(255,215,0);   // Gold cells
color headerColor=color(70,130,180); // Steel blue header
String gameTitle="Vijay's Game of Life";
int headerHeight=60;

boolean[][] cellsNow=new boolean[ySquareCount][xSquareCount];
boolean[][] cellsNext=new boolean[ySquareCount][xSquareCount];
float squareSize;
boolean isRunning=false;

void setup() {
    size(1000,1000);
    strokeWeight(0.5);
    frameRate(fps);
    squareSize=min(width,height-headerHeight)/min(xSquareCount,ySquareCount);
    noLoop();
}

void mousePressed() {
    int col=floor(mouseX/squareSize);
    int row=floor((mouseY-headerHeight)/squareSize);
    
    if(col>=0&&col<xSquareCount&&row>=0&&row<ySquareCount) {
        cellsNow[row][col]=!cellsNow[row][col];
        cellsNext[row][col]=cellsNow[row][col];
        redraw();
    }
}

void placePattern(int[][] pattern) {
    int centerRow = ySquareCount / 2;
    int centerCol = xSquareCount / 2;
    
    for(int row=0; row<ySquareCount; row++) {
        for(int col=0; col<xSquareCount; col++) {
            cellsNow[row][col] = false;
            cellsNext[row][col] = false;
        }
    }
    
    for(int[] cell : pattern) {
        int row = centerRow + cell[0];
        int col = centerCol + cell[1];
        if(row >= 0 && row < ySquareCount && col >= 0 && col < xSquareCount) {
            cellsNow[row][col] = true;
            cellsNext[row][col] = true;
        }
    }
    redraw();
}

void keyPressed() {
    if(key==' ') {
        isRunning=!isRunning;
        if(isRunning) {
            loop();
        } else {
            noLoop();
        }

    } else if(key=='r' || key=='R') { 
        for(int row=0; row<ySquareCount; row++) {
            for(int col=0; col<xSquareCount; col++) {
                cellsNow[row][col] = random(1) < 0.25;
                cellsNext[row][col] = cellsNow[row][col];
            }
        }
        redraw();
    } else if(key=='x' || key=='X') { 
        for(int row=0; row<ySquareCount; row++) {
            for(int col=0; col<xSquareCount; col++) {
                cellsNow[row][col] = false;
                cellsNext[row][col] = false;
            }
        }
        redraw();
    } else if(key=='c' || key=='C') { 
        for(int row=0; row<ySquareCount; row++) {
            for(int col=0; col<xSquareCount; col++) {
                cellsNow[row][col] = (row + col) % 2 == 0;
                cellsNext[row][col] = cellsNow[row][col];
            }
        }
        redraw();
    }
}


void drawHeader() {
    fill(headerColor);
    noStroke();
    rect(0, 0, width, headerHeight);
    
    fill(255); // White text
    textAlign(CENTER, CENTER);
    textSize(32);
    text(gameTitle, width/2, headerHeight/2);
}

void drawCells() {
    if(!shouldShowGrid) {
        noStroke();
    }

    fill(liveColor);

    for(int row=0;row<ySquareCount;row++) {
        for(int column=0;column<xSquareCount;column++) {
            if(cellsNow[row][column]) {
                stroke(deadColor);
                square(column*squareSize,row*squareSize+headerHeight,squareSize);
            } else if(shouldShowGrid) {
                stroke(liveColor);
                fill(deadColor);
                square(column*squareSize,row*squareSize+headerHeight,squareSize);
                fill(liveColor);
            }
        }
    }
}

int countLiveNeighbours(int row,int col) {
    int[][] neighbours={{-1,-1},{-1,0},{-1,1}, {0,-1},{0,1}, {1,-1},{1,0},{1,1}};
    int liveNeighbourCount=0;

    for(int[] neighbour:neighbours) {
        int newRow=row+neighbour[0];
        int newCol=col+neighbour[1];
        boolean isOutOfBounds=newRow<0||newCol<0||newRow>=ySquareCount||newCol>=xSquareCount;

        if(!isOutOfBounds&&cellsNow[newRow][newCol]) {
            liveNeighbourCount++;
        }
    }

    return liveNeighbourCount;
}

void updateCells() {
    for(int row=0;row<ySquareCount;row++) {
        for(int column=0;column<xSquareCount;column++) {
            int liveNeighbourCount=countLiveNeighbours(row,column);

            if(cellsNow[row][column]) {
                if(liveNeighbourCount<2||liveNeighbourCount>3) {
                    cellsNext[row][column]=false;
                } else {
                    cellsNext[row][column]=true;
                }
            } else {
                if(liveNeighbourCount==3) {
                    cellsNext[row][column]=true;
                } else {
                    cellsNext[row][column]=false;
                }
            }
        }
    }

    for(int row=0;row<ySquareCount;row++) {
        for(int column=0;column<xSquareCount;column++) {
            cellsNow[row][column]=cellsNext[row][column];
        }
    }
}

void draw() {
    background(deadColor);
    drawHeader();
    drawCells();
    if(isRunning) {
        updateCells();
    }
}
