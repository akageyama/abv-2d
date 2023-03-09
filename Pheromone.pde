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
}

class Pheromone {
  
  final int MAX_NUM_MONOPOLES = 10;
  int num_monopoles = 0 ;
  Monopole[] monopoles;
  

  Pheromone() {
    monopoles = new Monopole[MAX_NUM_MONOPOLES];
  }
  
  void placeMonopole( float src_pos_x, float src_pos_y ) {
    monopoles[num_monopoles] = new Monopole( src_pos_x, src_pos_y, 3.0, 10.0, 1.0 );
    num_monopoles += 1;
  }


  float getGradientVectorX( float observer_pos_x, 
                            float observer_pos_y) {
    float pgv_x = 0.0; // pheromone gradient vector
    
    for (int i=0; i<num_monopoles; i++) {
      float _pgv_x = monopoles[i].getGradientVectorX( observer_pos_x,
                                                      observer_pos_y );
println( " in getGradientVector, monopoles[" + i + "].getGradientVectorX(pos) = ",   _pgv_x );
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
println( " in getGradientVector, monopoles[" + i + "].getGradientVectorY(pos) = ",   _pgv_y );
      pgv_y += _pgv_y;
    }
    return pgv_y;
  }  
}
