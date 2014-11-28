class Bullet {
  Body body;      
  float w, h;

  // Constructor
  Bullet (float x, float y) {
    w = 16;
    h = 8;

    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);
    body.setBullet(true); //Box2D sets this a bullet

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 1;

    // Attach Fixture to Body               
    body.createFixture(fd);
  }
}

