/* Programming for Designers Fall 2014
 Miami Nice
 by Nicolas Aguirre and Brandon Wilson
 using box2d and game control plus libraries
 */
import org.gamecontrolplus.gui.*;  //Game Control
import org.gamecontrolplus.*;
import net.java.games.input.*;
import shiffman.box2d.*;           //Box2D
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ControlIO control;
ControlDevice stick;
Box2DProcessing box2d;

final boolean debug = true;

ArrayList<Player> players;
Player p;

PImage bg;
Vec2 bgPos;

Boundary floor;
ArrayList<Boundary> tiles;
ArrayList<Enemy> enemies;

// -----------------------------------------------
void setup() {
  size(1024, 768);
  smooth();

  bg = loadImage("bg.png");
  bgPos = new Vec2(0, 0);

  // Controls
  control = ControlIO.getInstance(this); // Initialize controlIO
//  stick = control.getMatchedDevice("xbox"); //Find device from config file
  stick = control.getMatchedDevice("xboxwireless");

    // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -35);

  // Add a listener to listen for collisions
  box2d.world.setContactListener(new CustomListener());

  // Create ArrayLists
  players = new ArrayList<Player>();
  tiles = new ArrayList<Boundary>();
  enemies = new ArrayList<Enemy>();

  // Start location of player
  Player p = new Player(width/2, height/4*3, 80, 140);
  players.add(p);

  // Create boundaries
  floor = new Boundary(4947/2, height-32, 4947, 64);

  populateMap(1);
}

void draw() {
  background(255);

  // Handle Input
  handleInput();

  // Update Box2D
  box2d.step();

  // Update game objects
  update();

  // Display
  display();
}

// ----- INPUT HANDLING ------------------------
void handleInput() {
  // Handle left/right movement
  for (Player p : players) {
    if (stick.getButton("LEFT").pressed()) {
      p.vx = -p.MOVESPEED;
      p.facing = -1;
      p.running = true;
    }
    if (stick.getButton("RIGHT").pressed()) {
      p.vx = p.MOVESPEED;
      p.facing = 1;
      p.running = true;
    }
    if (!stick.getButton("LEFT").pressed() &&
      !stick.getButton("RIGHT").pressed() ) {
      p.vx = 0;
      p.running = false;
    }
  }

  // Handle jumping (A button)
  if (stick.getButton("A").pressed()) {
    if (canJump) {
      for (Player p : players) {
        p.jump();
      }
    }
  }

  // Handle shooting (X button)
  if (stick.getButton("X").pressed()) {
    for (Player p : players) {
      p.shoot();
    }
  }
}
// -----------------------------------------------

// ----- UPDATE AND DISPLAY METHODS -----
void update() {
  for (Player p : players) {
    p.update();
  }

  // Collision Detection
  for (int j = 0; j < enemies.size (); j++) {
    for (int i = 0; i < players.get (0).bullets.size (); i++) {
      Bullet b = players.get(0).bullets.get(i);
      Enemy e = enemies.get(j);
      Vec2 ePos = box2d.getBodyPixelCoord(e.body);

      //      if (dist(b.x, b.y, ePos.x, ePos.y) < 20) {
      if (!(b.x+b.w/2 < ePos.x-e.w/2 || b.x-b.w/2 > ePos.x+e.w/2
        || b.y-b.w/2 > ePos.y+e.w/2 || b.y+b.w/2 < ePos.y-e.w/2))  
      {
        e.hp--;

        players.get(0).bullets.remove(i);
      }
    }
  }
  // Remove dead enemies
  for (int i = 0; i < enemies.size (); i++) {
    Enemy e = enemies.get(i);
    e.update();
    if (e.dead) {
      enemies.remove(i);
    }
  }
}
void display() {
  pushMatrix();
  // Camera follows player
  translate(-players.get(0).getXpos() + width/2, 0);

  //Display background
  imageMode(CORNER);
  image(bg, bgPos.x, bgPos.y);

  //Display player
  for (Player p : players) {
    p.display();
  }

  //Display enemies
  for (Enemy e : enemies) {
    e.display();
  }

  //Display obstacles
  for (int i = 0; i < tiles.size (); i++) {
    tiles.get(i).display();
  }

  //floor.display();

  popMatrix();

  // GUI and debug stuff
  if (debug) {
    Vec2 pos = box2d.getBodyPixelCoord(players.get(0).body);
    text("Pixel coords: (" + (int) pos.x + ", " + (int) pos.y + ")", 20, 20);
    pos = players.get(0).body.getWorldCenter();
    text("Box2D coords: (" + (int) pos.x + ", " + (int) pos.y + ")", 20, 32);
  }
}
// -----------------------------------------------
// ----- LEVEL AND MAP HANDLING ------------------
void populateMap(int mapNum) {
  PImage levelMap;
  levelMap = loadImage("map" + mapNum + ".png");

  for (int x = 0; x < levelMap.width; x++) {
    for (int y = 0; y < levelMap.height; y++) {
      if (levelMap.get(x, y) == color(0)) {
        Boundary b = new Boundary(x * 32, y * 32);
        tiles.add(b);
      } else if (levelMap.get(x, y) == color(255, 0, 0)) {
        Enemy e = new Enemy(x * 32, y * 32, ENEMY_W, ENEMY_H);
        enemies.add(e);
      }
    }
  }
}
// -----------------------------------------------
//Handle jumping
void beginContact (Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
}

