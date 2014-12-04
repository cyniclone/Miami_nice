/* REFERENCES
 For jumping/contact listening: 
 http://youtu.be/rGJQe0vtIo0
 */

//GLOBAL VARIABLE
boolean canJump;

class Player extends Box {
  ArrayList<Bullet> bullets;
  PImage img, spritesheet;
  PImage[] sprites;
  int facing; // 1: facing right; -1: facing left
  boolean shooting;
  boolean running;
  int shootTimer;
  int state; // Current state of animation
  // 0: standing, 1: shooting, 2: running, 3:run+shoot
  // Standing:0 , shooting:1-2, running:3-12, run+shoot: 13-14

  final float MOVESPEED = 25;
  final int JUMPFORCE = 50000;
  float vx; // Left/Right velocity 

  // Constructor  
  Player(float x, float y, float w, float h) {
    bullets = new ArrayList<Bullet>();
    this.w = w;
    this.h = h;
    vx = 0;

    makeBody(x, y); // Calls superclass method from Box
    body.setFixedRotation(true); //Keeps player from spinning

    canJump = false;
    makeFootSensor();

    // Load sprite and initialize spritesheet array
    facing = 1; // Character starts facing right
    state = 0;
    spritesheet = loadImage("spritesheet.png");
    sprites = new PImage[15];

    int spriteW = spritesheet.width/5;
    int spriteH = spritesheet.height/5;

    // Populate spritesheet array
    for (int i = 0; i < sprites.length; i++) {
      int _x = i%5*spriteW;
      int _y = i/5*spriteH;
      sprites[i] = spritesheet.get(_x, _y, spriteW, spriteH);
    }
    img = sprites[0]; // First animation frame
  }

  // ----- UPDATE -------------------------
  void update() {
    if (vx != 0) {
      state = 2;
    } else {
      state = 0;
    }

    body.setLinearVelocity (new Vec2 (vx, body.getLinearVelocity().y));

    // Update bullets
    for (int i = 0; i < bullets.size (); i++) {
      bullets.get(i).update();
      if (bullets.get(i).count > BULLET_LIFE) {
        bullets.remove(i); //Remove "dead" bullets
      }
    }
  }

  // ----- DISPLAY ------------------------
  void display() {
    //Display bullets first
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).display(); 
    }
    
    Vec2 pos = box2d.getBodyPixelCoord(body); //Get body position+angle

    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    //scale(1.3);
    if (debug) {
      noFill();
      stroke(255, 0, 0);
      rectMode(CENTER);
      rect(0, 0, w, h);
    }

    if (shooting) { //Shooting animation takes precedence over others
      shootTimer++;
      if (shootTimer <= 2) {
        img = running ? sprites[13] : sprites[1];
      } else {
        img = running ? sprites[14] : sprites[2];
      }
      if (shootTimer > 5) {
        shooting = false;
      }
    } else {
      switch (state) {
      case 0:
        img = sprites[0]; 
        break;
      case 2:
        int n = frameCount/3 % 10;
        img = sprites[3+n];
        println(3+n);
        break;
      }
    }
    if (facing == -1) 
      scale(-1, 1); //Flip the image if facing left
    scale(1.5);
    image(img, -55, -66);
    popMatrix();
  }

  void jump() {
    if (debug)
      println("jumping");
    Vec2 pos = body.getWorldCenter();
    body.applyForce(new Vec2(0, JUMPFORCE), pos);
  }

  void shoot() {
    shootTimer = 0;
    shooting = true;

    // Make new bullet and add it to the arraylist
    Vec2 pos = box2d.getBodyPixelCoord(body);
    Bullet b = new Bullet(pos.x, pos.y, facing);
    if (bullets.size() < 100) {
      bullets.add(b);
    }
  }

  // Creates the sensor that determines if player can jump
  void makeFootSensor() {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(20);
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

