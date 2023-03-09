class Monopole {
  float src_pos_x;
  float src_pos_y;
  float src_radiusA;
  float src_radiusB;
  float src_chargeQ;

  Monopole( float pos_x,
            float pos_y, 
            float radiusA, 
            float radiusB, 
            float chargeQ ) {
    src_pos_x = pos_x;              
    src_pos_y = pos_y;              
    src_radiusA = radiusA;
    src_radiusB = radiusB;
    src_chargeQ = chargeQ;
  }
  
  float getGradientVectorX( float observer_pos_x,
                            float observer_pos_y ) {
    float relative_pos_x;
    float gv_x;
    
    relative_pos_x = observer_pos_x - src_pos_x;
    gv_x = relative_pos_x;
    
    return gv_x;
  }
  
  float getGradientVectorY( float observer_pos_x,
                            float observer_pos_y ) {
    float relative_pos_y;
    float gv_y;
    
    relative_pos_y = observer_pos_y - src_pos_y;
    gv_y = relative_pos_y;
    
    return gv_y;
  }
  

  void show() {
    stroke( 0 );
    fill( 230, 240, 256 );
    circle( src_pos_x, src_pos_y, src_radiusB );
    fill( 255, 255, 240 );
    circle( src_pos_x, src_pos_y, src_radiusA );
  }
}


class Pheromone {
  
  final int MAX_NUM_MONOPOLES = 10;
  int num_monopoles = 0 ;
  Monopole[] monopoles;
  

  Pheromone() {
    monopoles = new Monopole[MAX_NUM_MONOPOLES];
  }

  
  void show() {
    for ( int i=0; i<num_monopoles; i++ ) {
      monopoles[i].show();
    }
  }
  
  void placeMonopole( float src_pos_x, 
                      float src_pos_y,
                      float radius_a,
                      float radius_b ) {
    monopoles[num_monopoles] = new Monopole( src_pos_x, 
                                             src_pos_y, 
                                             radius_a,
                                             radius_b,
                                             1.0 );
    num_monopoles += 1;
  }


  float getGradientVectorX( float observer_pos_x, 
                            float observer_pos_y) {
    float pgv_x = 0.0; // pheromone gradient vector
    
    for (int i=0; i<num_monopoles; i++) {
      float _pgv_x = monopoles[i].getGradientVectorX( observer_pos_x,
                                                      observer_pos_y );
      pgv_x += _pgv_x;
    }
    return pgv_x;
  }


  float getGradientVectorY( float observer_pos_x, 
                            float observer_pos_y) {
    float pgv_y = 0.0; // pheromone gradient vector
    
    for (int i=0; i<num_monopoles; i++) {
      float _pgv_y = monopoles[i].getGradientVectorY( observer_pos_x,
                                                      observer_pos_y );
      pgv_y += _pgv_y;
    }
    return pgv_y;
  }  
}
