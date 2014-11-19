/* REFERENCES
 For jumping/contact listening: 
 http://youtu.be/rGJQe0vtIo0
 */

//GLOBAL VARIABLE
boolean canJump;

//Metal slug sprite: 35 x 42 pixels

class Player extends Box {

  // Constructor  
  Player(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;

    canJump = false;

    makeBody(x, y); // Calls superclass method from Box
    //Set user data to player
    body.setAngularVelocity(0);


    makeFootSensor();
  }
  void update() {
    // To keep player from spinning
    body.setAngularVelocity(0);
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

  // Creates the sensor that determines if player can jump
  void makeFootSensor() {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(10/2);
    float box2dH = box2d.scalarPixelsToWorld(10/2);
    sd.setAsBox(box2dW, box2dH, 
    new Vec2(0, box2d.scalarPixelsToWorld(-16)), 0);

    //sd.setAsBox(box2dW, box2dH); 

    // Creates a foot sensor for jumping  
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.isSensor = true;
    fd.setUserData("foot");

    body.createFixture(fd);
  }

  void jump() {
    println("jumping");
    Vec2 pos = body.getWorldCenter();
    body.applyForce(new Vec2(0, 600), pos);
  }
}
