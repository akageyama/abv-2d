
class Agent {
  float x; // Agent's position x
  float y; //              and y
  float vx, vy; // Agent's velocity, x and y components.
  color col;    // color.

  Agent( float xInit,  float yInit, 
         float vxInit, float vyInit, 
         int red, int green, int blue ) {
    x = xInit;
    y = yInit;
    vx = vxInit;
    vy = vyInit;
    col = color( red, green, blue );
  }
  
  void show() {
    stroke( 0 );
    fill( col );
    ellipse( x, y, 10, 10 );  // place a circle
  }

  void move(float dt) {
    x += vx*dt;  // shift the ball position in x.
    y += vy*dt;  // ... in y.
    if ( x >= width ) {// The ball hits the right wall. 
      x = width;
      vx = -vx; // Reverse the direction.
    }
    if ( x<= 0 ) {  // Hit the left wall.
      x = 0;
      vx = -vx;
    }
    if ( y >= height ) {// Hit the floor. 
      y = height;
      vy = -vy; // Reverse the direction.
    }
    if ( y <= 0 ) {  // Hit the ceiling.
      y = 0;
      vy = -vy;
    }
  }
}
