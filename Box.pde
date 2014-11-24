/* Modified from Daniel Shiffman's Box2D Processing Examples */

// A rectangular box
class Box {
  //  Instead of any of the usual variables, we will store a reference to a Box2D Body
  Body body;      
  float w, h;

  Box() {
    w = 16; 
    h = 16; 
    makeBody(width/2, height/2);
  }

  Box(float x, float y) {
    w = 16;
    h = 16;

    makeBody(x, y);
  }

  Box(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;

    makeBody(x, y);
  }

  void makeBody(float x, float y) {
    // Build Body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    sd.setAsBox(box2dW, box2dH);            // rectangle to be the distance from the
    // center to the edge (so half of what we
    // normally think of as width or height.) 
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1.0;
    fd.setUserData("box");
    fd.friction = 0.25;
    // fd.restitution = 0.1;

    // Attach Fixture to Body               
    body.createFixture(fd);
  }

  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    rotate(-a);              // translate and rotate the rectangle
    fill(175);
    stroke(0);
    rectMode(CENTER);
    rect(0, 0, w, h);
    popMatrix();
  }
}

