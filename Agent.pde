
class Agent {
  float pos_x, pos_y;
  float vel_x, vel_y;  
  color col;    // color.
  final float MASS = 0.01;
  final float SPEED_LIMIT = 1;
  float chargeQ = -1.0;

  Agent( float xInit,  float yInit, 
         float vxInit, float vyInit, 
         int red, int green, int blue ) {
    pos_x = xInit;
    pos_y = yInit;
    vel_x = vxInit;
    vel_y = vyInit;
    col = color( red, green, blue );
  }

  void show() {
    stroke( 0 );
    fill( col );
    ellipse( pos_x, pos_y, 10, 10 );  // place a circle
  }


  void move(float dt) {
    
    float[] force = new float[2];
    
    for ( int i=0; i<2; i++ ) {
      visGuide.getForce( chargeQ,
                         pos_x,
                         pos_y,
                         vel_x,
                         vel_y,
                         force );
    }
        
    pos_x += vel_x*dt;  // shift the ball position in x.
    pos_y += vel_y*dt;  // ... in y.
    
    vel_x += force[0]/MASS*dt;
    vel_y += force[1]/MASS*dt;
    
    float vel_amp = dist( 0, 0, vel_x, vel_y );   
    if ( vel_amp >= SPEED_LIMIT ) {
      vel_x = SPEED_LIMIT * vel_x / vel_amp;
      vel_y = SPEED_LIMIT * vel_y / vel_amp;
    }
  }
  
}
