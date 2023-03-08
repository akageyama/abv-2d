
class Agent {
  PVector pos;
  PVector vel;  
  color   col;    // color.

  Agent( float xInit,  float yInit, 
         float vxInit, float vyInit, 
         int red, int green, int blue ) {
    pos = new PVector(xInit, yInit);
    vel = new PVector(vxInit, vyInit);
    col = color( red, green, blue );
  }

  void show() {
    stroke( 0 );
    fill( col );
    ellipse( pos.x, pos.y, 10, 10 );  // place a circle
  }

  void move(float dt) {
    // PVector field;
    
    //field = pheromone.getField( 
    
    pos.x += vel.x*dt;  // shift the ball position in x.
    pos.y += vel.y*dt;  // ... in y.
    
    if ( pos.x >= width ) {// The ball hits the right wall. 
      pos.x = width;
      vel.x = -vel.x; // Reverse the direction.
    }
    if ( pos.x<= 0 ) {  // Hit the left wall.
      pos.x = 0;
      vel.x = -vel.x;
    }
    if ( pos.y >= height ) {// Hit the floor. 
      pos.y = height;
      vel.y = -vel.y; // Reverse the direction.
    }
    if ( pos.y <= 0 ) {  // Hit the ceiling.
      pos.y = 0;
      vel.y = -vel.y;
    }
  }
}
