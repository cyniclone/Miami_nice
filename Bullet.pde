final int BULLET_LIFE = 600;

class Bullet { 
  float w, h;
  Body body;
  int count; // If this exceeds bullet life, bullet will be removed
  int direction;
  float vx;


  // Constructor
  Bullet (float x, float y, int direction) {
    w = 16;
    h = 8;
    count = 0;
    direction = this.direction;
    vx = 20 * direction;

    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);
    body.setBullet(true); //Box2D sets this a bullet
    body.setFixedRotation(true);

    // Define a polygon
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 1;
    fd.setUserData("bullet");

    // Attach Fixture to Body               
    body.createFixture(fd);
  }

  void update() {
    count++;

    // Move in direction
    body.setLinearVelocity (new Vec2 (vx, body.getLinearVelocity().y));
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);    

    pushMatrix();
    translate(pos.x, pos.y);
    fill(255, 255, 0);
    stroke(0);
    rectMode(CENTER);
    rect(0, 0, w, h);
    popMatrix();
  }
}

