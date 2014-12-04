final int BULLET_LIFE = 600; //When bullet count exceeds this#, remove it

class Bullet {    
  float w, h;
  float x, y;
  final int SPEED = 30;
  float vx;
  int direction; //-1 left, 1 right
  int count;

  // Constructor
  Bullet (float x, float y, int direction) {
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
    rectMode(CENTER);
    fill(255, 255, 0);
    noStroke();
    rect(x, y, w, h);
  }
}

