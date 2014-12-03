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

Boundary floor, floor2;

// -----------------------------------------------
void setup() {
  size(1024, 768);
  smooth();

  bg = loadImage("bg.png");
  bgPos = new Vec2(0, 0);

  // Controls
  control = ControlIO.getInstance(this); // Initialize controlIO
  stick = control.getMatchedDevice("xbox"); //Find device from config file

    // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -25);

  // Add a listener to listen for collisions
  box2d.world.setContactListener(new CustomListener());

  // Create ArrayLists
  players = new ArrayList<Player>();

  // Start location of player
  Player p = new Player(width/2, height/4*3, 80, 120);
  players.add(p);

  // Create boundaries
  floor = new Boundary(width/2, height-10, width*4, 20);
  floor2 = new Boundary(400, height-45, 500, 20);
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
}

void display() {
  pushMatrix();
  // Camera follows player
  translate(-players.get(0).getXpos() + width/2, 0);

  //Display background
  image(bg, bgPos.x, bgPos.y);

  //Display player
  for (Player p : players) {
    p.display();
  }

  //Display obstacles
  floor.display();
  floor2.display();

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

//Handle jumping
void beginContact (Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
}

