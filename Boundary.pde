/* Adapted from Shiffman's The Nature of Code
 <http://www.shiffman.net/teaching/nature>

  ASSET FROM
  http://opengameart.org/content/boxes-and-crates-svg-and-pngs
  Author: SpriteAttack
*/

class Boundary {
  PImage img;

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;

  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_, float y_) {
    this(x_, y_, 32, 32);
  }

  Boundary(float x_, float y_, float w_, float h_) {
    img = loadImage("crate" + (int) random(1,5) + ".png");
    
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    b = box2d.createBody(bd);

    // Attached the shape to the body using a Fixture
    b.createFixture(sd, 1);
    b.setUserData(this);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
//    fill(0);
//    stroke(0);
//    rectMode(CENTER);
//    rect(x, y, w, h);
    pushMatrix();
    //scale(1/3);
    imageMode(CENTER);
    image(img, x, y, w, h);
    popMatrix();
  }
}

