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

boolean game; // Game state: False means game is not in progress
boolean win; // Did player win or lose?

final boolean debug = false;

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

  // Controls
  control = ControlIO.getInstance(this); // Initialize controlIO
  //stick = control.getMatchedDevice("xbox"); //Find device from config file
  stick = control.getMatchedDevice("xboxwireless");

  loadGame();
}

void draw() {
  if (enemies.size() <= 0) { // Winning condition
    game = false;
    win = true;
  }
  if (players.get(0).hp <= 0) { // Losing condition
    game = false;
    win = false;
  }
  if (game) {
    handleInput();

    try {
      box2d.step(); // Update Box2D
    } 
    catch (AssertionError e) {
      println(e.getMessage()); // The joys of using physics libraries!
    }

    update();
    display();
  } else {
    rectMode(CENTER);
    fill(80);
    stroke(#FAE119);
    rect(width/2, height/2, width/2, height/2);
    fill(#FAE119);
    textAlign(CENTER);
    textSize(44);
    if (win) {
      text("You win!", width/2, height/2);
      textSize(24);
      text("Press Start to play again.", width/2, height/2 + 50);
    } else {
      text("GAME OVER", width/2, height/2);
      textSize(24);
      text("Press Start to try again.", width/2, height/2 + 50);
    }
  }

  if (!game && stick.getButton("START").pressed()) {
    loadGame();
  }
}

// ----- GAME LOADING METHOD -------------------
void loadGame() {
  game = true; // Set game state
  bg = loadImage("bg.png");
  bgPos = new Vec2(0, 0);

  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -30);

  // Add a listener to listen for collisions
  box2d.world.setContactListener(new CustomListener());

  // Create ArrayLists
  players = new ArrayList<Player>();
  tiles = new ArrayList<Boundary>();
  enemies = new ArrayList<Enemy>();

  // Start location of player
  Player p = new Player(width/2, height/4*3, 60, 140);
  players.add(p);

  // Create boundaries
  floor = new Boundary(4947/2, height-32, 4947, 64);

  populateMap(1);
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
      if (!e.dead) {
        if (!(b.x+b.w/2 < ePos.x-e.w/2 || b.x-b.w/2 > ePos.x+e.w/2
          || b.y-b.w/2 > ePos.y+e.w/2 || b.y+b.w/2 < ePos.y-e.w/2))  
        {
          e.hp--; //Decrement enemy HP
          // Apply force against enemy
          e.body.applyForce(new Vec2(b.direction*40000, 0), e.body.getWorldCenter());

          // Remove bullet from arraylist
          players.get(0).bullets.remove(i);
        }
      }
    }
  }
  // Remove dead enemies
  for (int i = 0; i < enemies.size (); i++) {
    Enemy e = enemies.get(i);
    if (!e.dead) {
      e.update();
    }
    if (e.dyingAnimationFinished) {
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
  // Wrap-around images
  image(bg, bgPos.x-bg.width, bgPos.y);
  image(bg, bgPos.x+bg.width, bgPos.y);

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
    if (dist(tiles.get(i).x, 0, players.get(0).getXpos(), 0) < 600)
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

