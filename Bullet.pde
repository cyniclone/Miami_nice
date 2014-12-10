final int BULLET_LIFE = 150; //When bullet count exceeds this#, remove it


class Bullet {
  PImage water;
  float w, h;
  float x, y;
  final int SPEED = 30;
  float vx;
  int direction; //-1 left, 1 right
  int count;

  // Constructor
  Bullet (float x, float y, int direction) {
    water = loadImage("water.png");
    w = 16;
    h = 8;
    this.x = x;
    this.y = y;
    this.direction = direction;
    vx = SPEED * direction;
    count = 0;
  }
  
  void update() {
    count++;
    x += vx;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    imageMode(CENTER);
    if (vx < 0) {
      scale(-1, 1);
    }
    image(water, 0, 0);
    popMatrix();
  }
}

