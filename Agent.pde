//
// Camera-agent class
// 
//   Data and methods a single camera agent.
//  

class Agent {
  float pos_x, pos_y;          // position in the window-coordinates.
  float vel_x, vel_y;          // velocity in the window-coordinates.
  color col;                   // RGB color of the agent.
  final float MASS = 0.01;     // Control of inertia (heviness) of the agent.
  final float SPEED_LIMIT = 1; // Agent cannot move faster than this speed.
  float chargeQ = -1.0;        // Agent is negatively "charged". Monopole is positive.

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
    stroke( 0 );  // black for circle's boarder.
    fill( col );  // fill the circle with this color.
    ellipse( pos_x, pos_y, 10, 10 );  // circle of diameter 10 pixels.
  }


  void move(float dt) 
  {    
    float[] force = new float[2];
    
    for ( int i=0; i<2; i++ ) { // 0 for force_x, 1 for force_y.
      visGuide.getForce( chargeQ,
                         pos_x, pos_y,
                         vel_x, vel_y,
                         force );
    }
        
    pos_x += vel_x*dt;    // d(pos_x)/dt = vel_x
    pos_y += vel_y*dt;    // d(pos_y)/dt = vel_y
    
    vel_x += force[0]/MASS*dt; // MASS*d(vel_x)/dt = force[0] 
    vel_y += force[1]/MASS*dt; // MASS*d(vel_y)/dt = force[1]
    
    float vel_amp = dist( 0, 0, vel_x, vel_y ); // = sqrt(vel_x^2 + vel_y^2) 
    if ( vel_amp >= SPEED_LIMIT ) {             
      vel_x = SPEED_LIMIT * vel_x / vel_amp;    // Prohibits the speed over
      vel_y = SPEED_LIMIT * vel_y / vel_amp;    // the limit value.
    }
  }
  
}
