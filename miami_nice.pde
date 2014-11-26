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

// Handles scrolling
boolean scrolling;
final float SCROLL_X = 1024 * .85; // The point at which the screen scrolls
float currentLoc;

Boundary floor, floor2;

// -----------------------------------------------
void setup() {
  size(1024, 768);
  smooth();

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
//  Player p = new Player(width/4*1, height-50, 32, 40);
  Player p = new Player(width/4, height-50, 92, 120);

  players.add(p);

  // Initialize scrolling variables
  scrolling = false;
  currentLoc = width;

  // Create boundaries
  floor = new Boundary(width/2, height-10, width, 20);
  floor2 = new Boundary(400, height-45, 500, 20);
}

void draw() {
  background(255);

  // Handle Input
  handleInput();

  // We must always step through time
  box2d.step();

  floor.display();
  floor2.display();

  // Update
  update();

  // Handle scrolling
  scroll();

  // Display
  display();
}

// ----- INPUT HANDLING ------------------------
void handleInput() {
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

  // Handle left/right movement
  for (Player p : players) {
    if (stick.getButton("LEFT").pressed()) {
      p.vx = -p.MOVESPEED;
    }
    if (stick.getButton("RIGHT").pressed()) {
      p.vx = p.MOVESPEED;
    }
    if (!stick.getButton("LEFT").pressed() &&
      !stick.getButton("RIGHT").pressed() ) {
      p.vx = 0;
    }
  }
}
// -----------------------------------------------

// ----- UPDATE, SCROLL AND DISPLAY METHODS -----
void update() {
  for (Player p : players) {
    p.update();
  }
}

void scroll() {
  for (Player p : players) {
    Vec2 pos = box2d.getBodyPixelCoord(p.body);
    if (pos.x + p.w/2 >= SCROLL_X) {
      scrolling = true;
      println("I'm scrolling");
    } else {
      scrolling = false;
    }
  }

  if (scrolling) {
    for (Player p : players) {
      p.vx = 0;
      Vec2 pos = box2d.getBodyPixelCoord(p.body);
    }
  }
  if (debug) {
    line (SCROLL_X, 0, SCROLL_X, height); //Indicate scrolling threshold
  }
}

void display() {
  for (Player p : players) {
    p.display();
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

