//Game Control
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

//Box2D
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ControlIO control;
ControlDevice stick;

Box2DProcessing box2d;

ArrayList<Player> players;
Player p;

Boundary floor, floor2;

void setup() {
  size(400, 300);
  smooth();

  // Controls
  control = ControlIO.getInstance(this); // Initialize controlIO
  stick = control.getMatchedDevice("xbox"); //Find device from config file

    // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Add a listener to listen for collisions
  box2d.world.setContactListener(new CustomListener());

  // Create ArrayLists
  players = new ArrayList<Player>();

  // Start location of player
  Player p = new Player(width/4*1, height-50, 32, 40);
  players.add(p);

  // Create boundaries
  floor = new Boundary(width/2, height-5, width, 10);
  floor2 = new Boundary(200, height-50, width/2, 10);
}

void draw() {
  background(255);

  // Handle Input
  handleInput();

  // We must always step through time
  box2d.step();

  floor.display();
  floor2.display();

  // Display players
  for (Player p : players) {
    p.update();
    p.display();
  }
}

void handleInput() {
  // Handle jumping (A button)
  if (stick.getButton("A").pressed()) {
    if (canJump) {
      for (Player p : players) {
        p.jump();
      }
    }
  }
  
  // Handle left/right movement
  for (Player p: players) {
    if (stick.getButton("LEFT").pressed()) {
      p.vx = -8;
    }
    if (stick.getButton("RIGHT").pressed()) {
      p.vx = 8;
    }
    if (!stick.getButton("LEFT").pressed() &&
        !stick.getButton("RIGHT").pressed() ) {
          p.vx = 0;      
    }
    
    
    p.body.setLinearVelocity (
      new Vec2 (p.vx, p.body.getLinearVelocity().y)
    );
  }
  
  
}

//Handle jumping
void beginContact (Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
}

