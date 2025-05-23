/**
 * Shape Class
 * Represents and manages drawable shapes in the paint application.
 * Supports multiple shape types (Circle, Rectangle, Triangle) with
 * customizable properties and interactive editing capabilities.
 */
class Shape {
  // Core properties
  PVector coords;          // Primary coordinates (usually top-left or center)
  PVector coord2;          // Secondary coordinates (for triangle)
  PVector coord3;          // Tertiary coordinates (for triangle)
  color rgb;              // Fill color
  float borderWidth;      // Stroke width
  color borderColor;      // Stroke color
  
  // Shape-specific properties
  float radius;           // For circles
  float width, height;    // For rectangles
  String type;            // Shape type identifier

  /**
   * Constructor for creating a new shape
   * @param x Initial x coordinate
   * @param y Initial y coordinate
   * @param colour Fill color
   * @param bw Border width
   * @param bc Border color
   * @param type Shape type ("Circle", "Rectangle", or "Triangle")
   */
  Shape(float x, float y, color colour, float bw, color bc, String type) {
    this.coords = new PVector(x, y);
    this.rgb = colour;
    this.borderWidth = bw;
    this.borderColor = bc;
    this.type = type;
    
    // Initialize shape-specific properties
    if (type.equals("Circle")) {
      this.radius = 0;  // Will be set by adjustVertex
    } else if (type.equals("Rectangle")) {
      this.width = 0;   // Will be set by adjustVertex
      this.height = 0;
    } else if (type.equals("Triangle")) {
      // Initialize all vertices to start point, will be adjusted later
      this.coord2 = coords.copy();
      this.coord3 = coords.copy();
    }
  }

  void setRadius(float r) {
    this.radius = r;
  }

  void setRectangleDimensions(float w, float h) {
    this.width = w;
    this.height = h;
  }

  void setTriangleCoordinates(float x2, float y2, float x3, float y3) {
    this.coord2 = new PVector(x2, y2);
    this.coord3 = new PVector(x3, y3);
  }

  void draw(PGraphics pg) {
    PGraphics target = (pg != null) ? pg : g;
    target.pushStyle();
    target.smooth(8);  // Increased anti-aliasing
    target.hint(ENABLE_STROKE_PURE);  // Enable better stroke rendering
    target.strokeJoin(ROUND);  // Smooth corners
    target.strokeCap(ROUND);   // Smooth line endings
    target.stroke(borderColor);
    target.strokeWeight(borderWidth);
    target.fill(rgb);

    if (type.equals("Circle")) {
      target.ellipseMode(CENTER);
      target.ellipse(coords.x, coords.y, radius * 2, radius * 2);
    } 
    if (type.equals("Rectangle")) {
      target.rectMode(CORNERS);  // Changed to CORNERS mode for more precise control
      // Calculate actual corners based on width and height
      float x2 = coords.x + width;
      float y2 = coords.y + height;
      // Draw the rectangle using refined coordinates
      target.rect(coords.x, coords.y, x2, y2);
    } 
    if (type.equals("Triangle")) {
      target.beginShape();
      target.vertex(coords.x, coords.y);
      target.vertex(coord2.x, coord2.y);
      target.vertex(coord3.x, coord3.y);
      target.endShape(CLOSE);
    }

    target.popStyle();
  }

  boolean contains(float x, float y) {
    PVector mouse = new PVector(x, y);
    float buffer = 10;  // Distance for hit detection
    
    if (type.equals("Circle")) {
      float dist = PVector.dist(coords, mouse);
      // Check if point is near the circumference or center
      return dist <= radius + buffer || dist <= buffer;
    } 
    else if (type.equals("Rectangle")) {
      // Check if point is near any edge or corner
      float left = coords.x;
      float right = coords.x + width;
      float top = coords.y;
      float bottom = coords.y + height;
      
      boolean nearHorizEdge = (x >= left - buffer && x <= right + buffer) &&(abs(y - top) <= buffer || abs(y - bottom) <= buffer);
      boolean nearVertEdge = (y >= top - buffer && y <= bottom + buffer) && (abs(x - left) <= buffer || abs(x - right) <= buffer);
      
      return nearHorizEdge || nearVertEdge;
    } 
    else if (type.equals("Triangle")) {
      // Check if point is near any vertex or edge
      boolean nearVertex = PVector.dist(coords, mouse) < buffer ||   PVector.dist(coord2, mouse) < buffer ||  PVector.dist(coord3, mouse) < buffer;
                         
      // Check if point is near any edge using point-to-line distance
      float d1 = pointToLineDistance(mouse, coords, coord2);
      float d2 = pointToLineDistance(mouse, coord2, coord3);
      float d3 = pointToLineDistance(mouse, coord3, coords);
      
      return nearVertex || d1 <= buffer || d2 <= buffer || d3 <= buffer;
    }
    return false;
  }
  
  // Helper function to calculate point-to-line distance
  private float pointToLineDistance(PVector p, PVector a, PVector b) {
    float numerator = abs((b.y - a.y) * p.x - (b.x - a.x) * p.y + b.x * a.y - b.y * a.x);
    float denominator = PVector.dist(a, b);
    return numerator / denominator;
  }

  int getVertexIndex(float x, float y) {
    PVector mouse = new PVector(x, y);
    float buffer = 10;
    
    if (type.equals("Circle")) {
      // Radius control point
      if (PVector.dist(new PVector(coords.x + radius, coords.y), mouse) < buffer) {
        return 0;
      }
      // Center point
      if (PVector.dist(coords, mouse) < buffer) {
        return 1;
      }
    } 
    else if (type.equals("Rectangle")) {
      // Corner resize handle
      if (PVector.dist(new PVector(coords.x + width, coords.y + height), mouse) < buffer) {
        return 0;
      }
      // Origin point for moving
      if (PVector.dist(coords, mouse) < buffer) {
        return 1;
      }
    } 
    else if (type.equals("Triangle")) {
      // Check vertices in reverse order (top layer first)
      if (PVector.dist(coord3, mouse) < buffer) return 2;
      if (PVector.dist(coord2, mouse) < buffer) return 1;
      if (PVector.dist(coords, mouse) < buffer) return 0;
    }
    return -1;
  }

  void adjustVertex(int index, float x, float y) {
    PVector mouse = new PVector(x, y);
    
    if (type.equals("Circle")) {
      if (index == 0) {
        // Use distance from center to mouse for radius, ensure minimum size
        radius = max(5, PVector.dist(coords, mouse));
      } else if (index == 1) {
        // Move the entire circle
        coords.x = x;
        coords.y = y;
      }
    } 
    else if (type.equals("Rectangle")) {
      if (index == 0) {
        // For resizing from corner
        PVector dragPoint = new PVector(x, y);
        PVector initialPoint = new PVector(coords.x, coords.y);
        
        // Calculate width and height based on drag direction
        width = abs(dragPoint.x - initialPoint.x);
        height = abs(dragPoint.y - initialPoint.y);
        
        // Enforce minimum size
        width = max(5, width);
        height = max(5, height);
        
        // Update position based on drag direction
        coords.x = min(dragPoint.x, initialPoint.x);
        coords.y = min(dragPoint.y, initialPoint.y);
      } else if (index == 1) {
        // Move the entire rectangle by its origin point
        coords.x = x;
        coords.y = y;
      }
    }
    else if (type.equals("Triangle")) {
      if (index == 0) {
        // Move the entire triangle while maintaining its shape
        float dx = x - coords.x;
        float dy = y - coords.y;
        coords.x = x;
        coords.y = y;
        coord2.add(dx, dy);
        coord3.add(dx, dy);
      }
      else if (index == 1) {
        // Move second vertex while keeping others fixed
        coord2.set(x, y);
        // Ensure minimum size
        float dist = PVector.dist(coords, coord2);
        if (dist < 5) {
          float angle = atan2(y - coords.y, x - coords.x);
          coord2.x = coords.x + 5 * cos(angle);
          coord2.y = coords.y + 5 * sin(angle);
        }
      }
      else if (index == 2) {
        // Move third vertex while keeping others fixed
        coord3.set(x, y);
        // Ensure minimum size
        float dist = PVector.dist(coords, coord3);
        if (dist < 5) {
          float angle = atan2(y - coords.y, x - coords.x);
          coord3.x = coords.x + 5 * cos(angle);
          coord3.y = coords.y + 5 * sin(angle);
        }
      }
    } 
    else if (type.equals("Triangle")) {
      if (index == 1) {
        coord2.set(x, y);
      }
      else if (index == 2) {
        coord3.set(x, y);
      }
      else if (index == 0) {
        // Move the entire triangle by adjusting all vertices
        float dx = x - coords.x;
        float dy = y - coords.y;
        coords.add(dx, dy);
        coord2.add(dx, dy);
        coord3.add(dx, dy);
      }
    }
  }
}
