/**
 * Canvas Class
 * Core drawing surface that handles all drawing operations, shape management,
 * and tool interactions in the paint application.
 */
class Canvas {
  PGraphics canvas;          // The actual drawing surface
  boolean isFirstDraw;       // Tracks if this is the first draw call
  
  // Tool properties
  int strokeSize;           // Current stroke/line thickness
  boolean isEraserActive;   // Whether eraser tool is active
  int eraserStrokeSize;     // Size of eraser tool
  Colors colors;            // Color management object
  
  // Shape management
  String currentShape;      // Current selected shape type
  Shape currentShapeInstance;  // Shape currently being drawn
  boolean isDrawing;        // Whether user is currently drawing
  PVector startPoint;       // Starting point for shape drawing
  Shape selectedShape;      // Currently selected shape for editing
  String currentTool;       // Current selected tool (Pen/Eraser/Shape)
  
  // Shape editing
  int vertexIndex;         // Index of vertex being edited
  boolean isDragging;      // Whether user is dragging a vertex
  
  // Drawing management
  ArrayList<Shape> finalizedShapes = new ArrayList<Shape>();  // List of completed shapes
  PVector lastPoint;       // Last point for continuous drawing
  boolean isDrawingPen;    // Whether pen tool is actively drawing

  // initialize canvas settings
  Canvas(int width, int height) {
    canvas = createGraphics(width, height, JAVA2D);
    canvas.smooth();
    strokeSize = 3;
    eraserStrokeSize = 20;
    isEraserActive = false;
    colors = new Colors();
    currentShape = "Rectangle";
    currentTool = "Pen";  // Initialize with Pen tool
    isDrawing = false;
    selectedShape = null;
    clear();
  }
  
  // runs each frame to update canvas
  void draw() {
    canvas.beginDraw();
    
    // Only clear on initialization or explicit clear
    if (isFirstDraw) {
      canvas.background(255);
      isFirstDraw = false;
    }

    // draw all saved shapes
    for (Shape s : finalizedShapes) {
      s.draw(canvas);
    }

    // draw current shape in progress
    if (currentShapeInstance != null) {
      currentShapeInstance.draw(canvas);
    }

    // draw selected shape and its handles
    if (selectedShape != null) {
      selectedShape.draw(canvas);
      drawVertices(selectedShape);
    }

    // draw while mouse is pressed
    if (mousePressed && mouseY > 0) {
      if (currentTool.equals("Eraser")) {
        // Remove shapes that intersect with eraser
        for (int i = finalizedShapes.size() - 1; i >= 0; i--) {
          Shape s = finalizedShapes.get(i);
          if (s.contains(mouseX, mouseY)) {
            finalizedShapes.remove(i);
          }
        }
        // Erase pixels
        canvas.noStroke();
        canvas.fill(255);
        canvas.ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
      }
      
      if (currentTool.equals("Pen")) {
        if (!isDrawingPen) {
          lastPoint = new PVector(mouseX, mouseY);
          isDrawingPen = true;
        }
        canvas.stroke(colors.getPenColor());
        canvas.strokeWeight(strokeSize);
        canvas.line(lastPoint.x, lastPoint.y, mouseX, mouseY);
        lastPoint.set(mouseX, mouseY);
      }
      
      if (currentTool.equals("Shape")) {
        if (!isDrawing) {
          startPoint = new PVector(mouseX, mouseY);
          isDrawing = true;
        }

        if (currentShapeInstance == null) {
          // Always start shape at initial click point
          currentShapeInstance = new Shape(startPoint.x, startPoint.y, colors.getPenColor(), strokeSize, colors.getPenColor(), currentShape);
        }

        if (currentShape.equals("Rectangle")) {
          // For rectangles, calculate the top-left and dimensions based on drag direction
          float left = min(startPoint.x, mouseX);
          float top = min(startPoint.y, mouseY);
          currentShapeInstance.coords.x = left;
          currentShapeInstance.coords.y = top;
          currentShapeInstance.width = abs(mouseX - startPoint.x);
          currentShapeInstance.height = abs(mouseY - startPoint.y);
        } else if (currentShape.equals("Triangle")) {
          // For triangles, create an isosceles triangle that follows the mouse
          float dx = mouseX - startPoint.x;
          float dy = mouseY - startPoint.y;
          float distance = sqrt(dx*dx + dy*dy);
          float angle = atan2(dy, dx);
          
          // Base point (coord2) follows the mouse directly
          currentShapeInstance.coord2.x = mouseX;
          currentShapeInstance.coord2.y = mouseY;
          
          // Third point (coord3) creates an isosceles triangle
          float triangleAngle = PI/3; // 60 degrees for equilateral
          currentShapeInstance.coord3.x = startPoint.x + distance * cos(angle + triangleAngle);
          currentShapeInstance.coord3.y = startPoint.y + distance * sin(angle + triangleAngle);
        } else {
          // For other shapes (circle), use normal vertex adjustment
          currentShapeInstance.adjustVertex(0, mouseX, mouseY);
        }
        drawShapePreview(currentShapeInstance);
      }
    } else {
      if (currentShapeInstance != null && isDrawing) {
        finalizedShapes.add(currentShapeInstance);
        isDrawing = false;
        currentShapeInstance = null;
      }
      if (isDrawingPen) {
        isDrawingPen = false;
      }
    }

    canvas.endDraw();
    image(canvas, 0, 0);

    if (currentTool.equals("Eraser")) {
      drawEraserPreview();
    }
    
    if (currentTool.equals("Pen")) {
      pushStyle();
      stroke(100);
      strokeWeight(1);
      fill(colors.getPenColor());
      ellipse(mouseX, mouseY, strokeSize, strokeSize);
      popStyle();
    }
    
    if (currentTool.equals("Shape") && currentShapeInstance != null) {
      drawShapePreview(currentShapeInstance);
    }
  }

  // shows eraser cursor on screen
  void drawEraserPreview() {
    pushStyle();
    stroke(100);
    strokeWeight(1);
    noFill();
    ellipse(mouseX, mouseY, eraserStrokeSize, eraserStrokeSize);
    popStyle();
  }

  // shows shape preview on screen
  void drawShapePreview(Shape shape) {
    pushStyle();
    smooth(8);  // Match the anti-aliasing level
    hint(ENABLE_STROKE_PURE);
    strokeCap(ROUND);
    strokeJoin(ROUND);
    stroke(shape.borderColor);
    strokeWeight(shape.borderWidth);
    noFill();
    shape.draw(null);  // Use the Shape class's draw method
    popStyle();
  }

  // draws shape vertices for editing
  void drawVertices(Shape shape) {
    pushStyle();
    stroke(100);
    strokeWeight(1);
    
    int hoveredVertex = shape.getVertexIndex(mouseX, mouseY);
    float normalSize = 8;
    float hoverSize = 12;
    
    if (shape.type.equals("Circle")) {
      // Draw center control point
      fill(hoveredVertex == 1 ? color(0, 200, 0) : color(0, 255, 0));
      ellipse(shape.coords.x, shape.coords.y, hoveredVertex == 1 ? hoverSize : normalSize, hoveredVertex == 1 ? hoverSize : normalSize);
              
      // Draw radius control point
      fill(hoveredVertex == 0 ? color(0, 200, 0) : color(0, 255, 0));
      ellipse(shape.coords.x + shape.radius, shape.coords.y, hoveredVertex == 0 ? hoverSize : normalSize, hoveredVertex == 0 ? hoverSize : normalSize);
    } 
    else if (shape.type.equals("Rectangle")) {
      // Draw origin control point
      fill(hoveredVertex == 1 ? color(0, 200, 0) : color(0, 255, 0));
      ellipse(shape.coords.x, shape.coords.y,hoveredVertex == 1 ? hoverSize : normalSize,  hoveredVertex == 1 ? hoverSize : normalSize);
              
      // Draw resize control point
      fill(hoveredVertex == 0 ? color(0, 200, 0) : color(0, 255, 0));
      ellipse(shape.coords.x + shape.width, shape.coords.y + shape.height, hoveredVertex == 0 ? hoverSize : normalSize,hoveredVertex == 0 ? hoverSize : normalSize);
    } 
    else if (shape.type.equals("Triangle")) {
      // Draw all three vertices
      for (int i = 0; i < 3; i++) {
        fill(hoveredVertex == i ? color(0, 200, 0) : color(0, 255, 0));
        PVector vertex = (i == 0) ? shape.coords : (i == 1) ? shape.coord2 : shape.coord3;
        ellipse(vertex.x, vertex.y, hoveredVertex == i ? hoverSize : normalSize,hoveredVertex == i ? hoverSize : normalSize);
      }
    }
    popStyle();
  }

  // handles mouse down for editing
  void mousePressed(float x, float y) {
    vertexIndex = -1;
    isDragging = false;

    if (selectedShape != null) {
      vertexIndex = selectedShape.getVertexIndex(x, y);
      if (vertexIndex != -1) {
        isDragging = true;
        return;
      }
    }

    if (currentShapeInstance != null && currentShapeInstance.contains(x, y)) {
      selectedShape = currentShapeInstance;
    }
  }

  // handles dragging vertices
  void mouseDragged(float x, float y) {
    if (isDragging && selectedShape != null) {
      selectedShape.adjustVertex(vertexIndex, x, y);
    }
  }

  // resets drag state
  void mouseReleased() {
    isDragging = false;
    vertexIndex = -1;
  }

  // updates current shape type
  void setShape(String shape) {
    currentShape = shape;
  }

  // updates stroke size globally
  void setStrokeSize(int size) {
    strokeSize = size;
    if (selectedShape != null) {
      selectedShape.borderWidth = size;
    }
  }

  // updates eraser size
  void setEraserSize(int size) {
    eraserStrokeSize = size;
  }

  // updates color of selected shape
  void setColor(color col) {
    if (selectedShape != null) {
      selectedShape.rgb = col;
    }
  }

  // clears canvas and shape list
  void clear() {
    finalizedShapes.clear();
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
    isFirstDraw = true;  // Reset first draw flag when clearing
  }

  // saves canvas as png file
  void save(String filename) {
    File dir = new File(sketchPath("") + "/screenshots");
    if (!dir.exists()) {
      dir.mkdir();
    }

    String filepath = "screenshots/" + (filename != null ? filename : "drawing") + ".png";
    canvas.save(filepath);
    println("Canvas saved as: " + filepath);
  }

  // updates current tool
  void setCurrentTool(String tool) {
    currentTool = tool;
  }

  // gets color manager
  Colors getColors() {
    return colors;
  }

  // turns eraser mode on/off
  void setEraserActive(boolean active) {
    isEraserActive = active;
  }
}
