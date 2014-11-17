import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ArrayList<Player> players;

Box2DProcessing box2d;

Boundary floor;

void setup() {
  size(400, 300);
  smooth();
  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);  
  box2d.createWorld();


  // Add a listener to listen for collisions
  box2d.world.setContactListener(new CustomListener());

  // Create ArrayLists
  players = new ArrayList<Player>();

  // Start location of player
  Player p = new Player(width/4*1, height-50, 16, 32);
  players.add(p);

  // Create boundaries
  floor = new Boundary(width/2, height-5, width, 10);
}

void draw() {
  background(255);
  if (mousePressed) {
    if (canJump) {
      for (Player p : players) {
        p.jump();
      }
    }
  }
  // We must always step through time
  box2d.step();    

  floor.display();

  // Display players
  for (Player p : players) {
    p.display();
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

