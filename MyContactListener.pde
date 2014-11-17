/* Referenced Shiffman's CollisionsAndControlInterface.pde from examples*/

import org.jbox2d.callbacks.ContactImpulse;
import org.jbox2d.callbacks.ContactListener;
import org.jbox2d.collision.Manifold;
import org.jbox2d.dynamics.contacts.Contact;

class CustomListener implements ContactListener {
  CustomListener() {
  }  

  // Called when a new collision occurs
  void beginContact (Contact cp) {
    // Get both fixtures
    Fixture f1 = cp.getFixtureA();
    Fixture f2 = cp.getFixtureB();
    // Get both bodies
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();

    if (f1.getUserData() == "foot" && o2.getClass() == Boundary.class) {
      println("foot contact");
      canJump = true;
    }
  }

  void endContact(Contact cp) {
    // Get both fixtures
    Fixture f1 = cp.getFixtureA();
    Fixture f2 = cp.getFixtureB();
    // Get both bodies
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();

    if (f1.getUserData() == "foot" && o2.getClass() == Boundary.class) {
      println("foot contact end");
      canJump = false;
    }
  }
  void preSolve(Contact contact, Manifold oldManifold) {
  }
  void postSolve(Contact contact, ContactImpulse impulse) {
  }
}

