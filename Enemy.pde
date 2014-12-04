final float ENEMY_W = 100;
final float ENEMY_H = 120;

class Enemy extends Box {
  PImage img, spritesheet;
  PImage[] sprites;

  float x, y;


  Enemy (float x, float y, float w, float h) {
    this.w = ENEMY_W;
    this.h = ENEMY_H;

    makeBody(x, y); // Calls superclass method from Box
    body.setFixedRotation(true); //Keeps player from spinning
  }

  void update() {
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);    

    pushMatrix();
    translate(pos.x, pos.y);
    fill(#590479);
    stroke(0);
    rectMode(CENTER);
    rect(0, 0, w, h);
    popMatrix();
  }
}

