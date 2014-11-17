class Player extends Box {
//  Player(float x, float y) {
//    super(x, y);  
//  }
  
  Player(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    
    makeBody(x, y);
  }
  
  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    rotate(-a);              // translate and rotate the rectangle
    fill(255, 0, 0);
    stroke(125);
    rectMode(CENTER);
    rect(0, 0, w, h);
    popMatrix();
  }
}

