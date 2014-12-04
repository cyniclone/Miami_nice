final float ENEMY_W = 36;
final float ENEMY_H = 48;

class Enemy extends Box {
  PImage img, spritesheet; //Skeleton will be 36x48
  PImage[] sprites;

  float x, y;


  Enemy (float x, float y, float w, float h) {
    this.w = ENEMY_W;
    this.h = ENEMY_H;

    makeBody(x, y); // Calls superclass method from Box
    body.setFixedRotation(true); //Keeps player from spinning

    // Load sprite and initialize spritesheet array
    spritesheet = loadImage("skeleton.png");
    sprites = new PImage[11];

    int spriteW = spritesheet.width/5;
    int spriteH = spritesheet.height/4;

    // Populate spritesheet array
    for (int i = 0; i < sprites.length; i++) {
      int _x = i%5*spriteW;
      int _y = i/4*spriteH;
      sprites[i] = spritesheet.get(_x, _y, spriteW, spriteH);
    }
    img = sprites[0]; // First animation frame
  }

  void update() {
  }

  void display() {
    //Determine image to display 
    img = sprites[frameCount/3 % sprites.length];

    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    image(img, 0, 0, w, h);
    popMatrix();
  }
}

