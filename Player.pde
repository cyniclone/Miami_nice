/* REFERENCES
 For jumping/contact listening: 
 http://youtu.be/rGJQe0vtIo0
 */

//GLOBAL VARIABLE
boolean canJump;

class Player extends Box {
  PImage img;

  final float MOVESPEED = 16;
  float vx; // Left/Right velocity 

  // Constructor  
  Player(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;

    vx = 0;

    makeBody(x, y); // Calls superclass method from Box
    body.setFixedRotation(true); //Keeps player from spinning

    canJump = false;
    makeFootSensor();

    img = loadImage("img.png");
  }

  void update() {
    body.setLinearVelocity (
    new Vec2 (vx, body.getLinearVelocity().y));
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body); //Get body position+angle


    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    /*if (debug) {
     stroke(255, 0, 0);
     rectMode(CENTER);
     rect(0, 0, w, h);
     }*/
    image(img, -w/2, -h/2);
    popMatrix();
  }

  void jump() {
    if (debug)
      println("jumping");
    Vec2 pos = body.getWorldCenter();
    body.applyForce(new Vec2(0, 25000), pos);
  }

  void shoot() {
    println("bang");
  }

  // Creates the sensor that determines if player can jump
  void makeFootSensor() {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(4);
    float box2dH = box2d.scalarPixelsToWorld(4);
    sd.setAsBox(box2dW, box2dH, 
    new Vec2(0, box2d.scalarPixelsToWorld(-h/2)), 0);

    // Creates a foot sensor for jumping  
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.isSensor = true;
    fd.setUserData("foot");

    body.createFixture(fd);
  }

  float getXpos() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.x;
  }
}

