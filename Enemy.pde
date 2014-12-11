/*
  ASSET FROM:
 http://opengameart.org/content/skeleton-and-ghost-spritesheets-ars-notoria
 AUTHOR: Balmer
 */

final float ENEMY_SCALAR = 3;
final float ENEMY_W = 36 * ENEMY_SCALAR;
final float ENEMY_H = 48 * ENEMY_SCALAR;

class Enemy extends Box {
  PImage img, spritesheet; //Skeleton will be 36x48
  PImage[] sprites;
  final int MAX_HP = 15;
  int hp;
  boolean dead;
  boolean dyingAnimationFinished;
  int dyingFrames;

  int showFrame = 0;

  Vec2 pos;

  float x, y;

  Enemy (float x, float y, float w, float h) {
    dead = false;
    dyingAnimationFinished = false;
    dyingFrames = 0;
    hp = MAX_HP;

    this.w = ENEMY_W;
    this.h = ENEMY_H;

    makeBody(x, y); // Calls superclass method from Box
    body.setFixedRotation(true); //Keeps player from spinning
    pos = box2d.getBodyPixelCoord(body);

    // Load sprite and initialize spritesheet array
    spritesheet = loadImage("skeleton.png");
    sprites = new PImage[20];

    int spriteW = spritesheet.width/5;
    int spriteH = spritesheet.height/4;


    // Populate spritesheet array
    for (int i = 0; i < sprites.length; i++) {
      int _x = i%5*spriteW;
      int _y = i/5*spriteH;
      
      println("i: " + i + " x: "+ _x +" y: "+ _y);
      sprites[i] = spritesheet.get(_x, _y, spriteW, spriteH);
    }
    img = sprites[0]; // First animation frame
  }

  void update() {
    if (hp <= 0) {
      dead = true;
      box2d.destroyBody(body);
    }
  }

  void display() {
    //Determine image to display 
    //    img = sprites[frameCount/3 % sprites.length];
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);

    if (dead) {
      img = sprites[19];

      dyingFrames++;
      dyingAnimationFinished = (dyingFrames > 59) ? true : false;
    } else {
      img = sprites[frameCount/3 % 11];

      pos = box2d.getBodyPixelCoord(body);

      //Display lifebar
      //Draw the container bar
      stroke(0);
      fill(50);
      rectMode(CORNER);
      rect(-w/2, -100, w, 15);
      //Draw enemy's health as rectangle
      noStroke();
      fill(255, 50, 50);
      rect(-w/2, -100, map(hp, 0, MAX_HP, 0, w), 15);
    }
    image(img, 0, 0, w, h+2);
    popMatrix();
  }
}

