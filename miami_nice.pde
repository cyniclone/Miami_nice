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

  // We must always step through time!
  box2d.step();    

  floor.display();


  // Display players
  for (Player p : players) {
    p.display();
  }
}

void mousePressed() {
  for (Player p : players) {
   // Apply upward force 
  }  
}

