
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
    //float pgv_x, pgv_y, force_x, force_y;
    //final float FACTOR_INERTIA = -0.1; // camera is negatively charged.
    //final float FACTOR_FRICTION = 1.e-3;
    
    //pgv_x = pheromone.getGradientVectorX( pos_x, pos_y );
    //pgv_y = pheromone.getGradientVectorY( pos_x, pos_y );

    //force_x = FACTOR_INERTIA * pgv_x - FACTOR_FRICTION * vel_x;
    //force_y = FACTOR_INERTIA * pgv_y - FACTOR_FRICTION * vel_y;
    
    float[] force = new float[2];
    
    for ( int i=0; i<2; i++ ) {
      pheromone.getForceX( -1.0,
                           pos_x,
                           pos_y,
                           vel_x,
                           vel_y,
                           force );
    }
        
    pos_x += vel_x*dt;  // shift the ball position in x.
    pos_y += vel_y*dt;  // ... in y.
    
    vel_x += force[0]*dt;
    vel_y += force[1]*dt;
  }
  

  //void moveAlongFieldLine() {
  //  float pgv_x, pgv_y;
  //  float stride_x, stride_y;
    
  //  pgv_x = pheromone.getGradientVectorX( pos_x, pos_y );
  //  pgv_y = pheromone.getGradientVectorY( pos_x, pos_y );

  //  float amp_pgv = dist( 0, 0, pgv_x, pgv_y );
  //  float stride_length = -1.e-1; // negative direction.
    
  //  if ( amp_pgv > 1.e-3 ) {    
  //    stride_x = pgv_x / amp_pgv * stride_length;
  //    stride_y = pgv_y / amp_pgv * stride_length;
      
  //  } else {
  //    stride_x = 0;
  //    stride_y = 0;
  //  }
    
  //  pos_x += stride_x;
  //  pos_y += stride_y;
  //}  
}
