/* REFERENCES
 For jumping/contact listening: 
   http://youtu.be/rGJQe0vtIo0
*/ 

class Player extends Box {
  // Determines whether player can jump or not
  int numFootContacts;
  
  // Constructor  
  Player(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    
    numFootContacts = 0;
    
    makeBody(x, y); // Calls superclass method from Box
    makeFootSensor();
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body); //Get body position+angle
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
  
  void makeFootSensor() {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(10/2);
    float box2dH = box2d.scalarPixelsToWorld(10/2);
    sd.setAsBox(box2dW, box2dH);
    
    // Creates a foot sensor for jumping  
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.setUserData("foot");
    
    body.createFixture(fd);
  }
}

