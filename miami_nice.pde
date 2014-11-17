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

  Player p = new Player(width/4*1, height/4*3);
  players.add(p);
  
  floor = new Boundary(width/2, height-10, width, 10);
}

void draw() {
  background(255);

  // We must always step through time!
  box2d.step();    

  floor.display();


  // Display all the boxes
  for (Player p : players) {
    p.display();
  }
}

void mousePressed() {
  for (Player p : players) {
   // Apply upward force 
  }  
}

