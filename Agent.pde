
class Agent {
  float pos_x, pos_y;
  float vel_x, vel_y;  
  color col;    // color.

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
    float pgv_x, pgv_y, force_x, force_y;
    final float FACTOR_INERTIA = -1; // camera is negatively charged.
    final float FACTOR_FRICTION = 1.e-3;
    
    pgv_x = pheromone.getGradientVectorX( pos_x, pos_y );
    pgv_y = pheromone.getGradientVectorY( pos_x, pos_y );

    // force_x = FACTOR_INERTIA * pgv_x - FACTOR_FRICTION * vel_x;
    // force_y = FACTOR_INERTIA * pgv_y - FACTOR_FRICTION * vel_y;
    
    float normalization_factor = 1.e-3 / dist( 0, 0, pgv_x, pgv_y );
    force_x = pgv_x * normalization_factor; 
    force_y = pgv_y * normalization_factor; 
    
    pos_x += vel_x*dt;  // shift the ball position in x.
    pos_y += vel_y*dt;  // ... in y.
    
    vel_x += force_x*dt;
    vel_y += force_y*dt;
    
    //if ( pos_x >= width ) {// The ball hits the right wall. 
    //  pos_x = width;
    //  vel_x = -vel_x; // Reverse the direction.
    //}
    //if ( pos_x<= 0 ) {  // Hit the left wall.
    //  pos_x = 0;
    //  vel_x = -vel_x;
    //}
    //if ( pos_y >= height ) {// Hit the floor. 
    //  pos_y = height;
    //  vel_y = -vel_y; // Reverse the direction.
    //}
    //if ( pos_y <= 0 ) {  // Hit the ceiling.
    //  pos_y = 0;
    //  vel_y = -vel_y;
    //}
  }
}
