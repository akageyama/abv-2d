class Monopole {
  float src_pos_x;
  float src_pos_y;
  float src_radiusA;
  float src_radiusB1;
  float src_chargeQa;
  float src_a_cubed; // = src_radiusA^3
  
  float factor_0_a, factor_a_b1, factor_b1;

  Monopole( float pos_x,
            float pos_y, 
            float radiusA, 
            float radiusB1, 
            float chargeQ ) {
    src_pos_x = pos_x;              
    src_pos_y = pos_y;              
    src_radiusA = radiusA;
    src_radiusB1 = radiusB1;
    src_chargeQa = chargeQ;
    src_a_cubed = pow(src_radiusA,3);
    
    float fourPi = 4*PI;
    float alpha = pow(2.0, 1.5) - 2.0;

    println(" alpha = ", alpha);
    
    factor_0_a = -src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b1 = src_chargeQa / (fourPi*src_a_cubed);
    factor_b1 = src_chargeQa * alpha / fourPi;
  }
  
  
  float gradientVectorR( float r ) {
    float r_sq_inverse;
    float pgvr; // pheromone gradient vector, its radial component.
    
    r_sq_inverse = 1.0 / r*r; // Dangerous... Check if r /= 0.
    
    if ( r <= src_radiusA ) {
      pgvr = factor_0_a * r;
    } else if ( r <= src_radiusB1 ) {
      pgvr = factor_a_b1 * (r-2*src_a_cubed*r_sq_inverse);
    } else { // src_radiusB1 < r      
      pgvr = factor_b1 * r_sq_inverse;
    }
    return pgvr;          
  }
  
  float getGradientVectorX( float observer_pos_x,
                            float observer_pos_y ) {
    float r = dist( src_pos_x,      src_pos_y,
                    observer_pos_x, observer_pos_y );

    float cosTheta = ( observer_pos_x - src_pos_x ) / r;
    
    float e1r = gradientVectorR( r );
    
    return e1r * cosTheta;                                         
  }
  
  float getGradientVectorY( float observer_pos_x,
                            float observer_pos_y ) {
    float r = dist( src_pos_x,      src_pos_y,
                    observer_pos_x, observer_pos_y );

    float sinTheta = ( observer_pos_y - src_pos_y ) / r;
    
    float e1r = gradientVectorR( r );
    
    return e1r * sinTheta;                                         
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
    circle( src_pos_x, src_pos_y, src_radiusB1 );
    fill( 255, 255, 240 );
    circle( src_pos_x, src_pos_y, src_radiusA );
  }
}


class Pheromone {
  
  final int MAX_numMonopoles = 10;
  int numMonopoles = 0 ;
  Monopole[] monopoles;
  

  Pheromone() {
    monopoles = new Monopole[MAX_numMonopoles];
  }

  
  void show() {
    for ( int i=0; i<numMonopoles; i++ ) {
      monopoles[i].show();
    }
  }
  
  void placeMonopole( float src_pos_x, 
                      float src_pos_y,
                      float radius_a,
                      float radius_b ) {
    monopoles[numMonopoles] = new Monopole( src_pos_x, 
                                             src_pos_y, 
                                             radius_a,
                                             radius_b,
                                             1.0 );
    numMonopoles += 1;
  }


  float getGradientVectorX( float observer_pos_x, 
                            float observer_pos_y) {
    float pgv_x = 0.0; // pheromone gradient vector
    
    for (int i=0; i<numMonopoles; i++) {
      float _pgv_x = monopoles[i].getGradientVectorX( observer_pos_x,
                                                      observer_pos_y );
      pgv_x += _pgv_x;
    }
    return pgv_x;
  }


  float getGradientVectorY( float observer_pos_x, 
                            float observer_pos_y) {
    float pgv_y = 0.0; // pheromone gradient vector
    
    for (int i=0; i<numMonopoles; i++) {
      float _pgv_y = monopoles[i].getGradientVectorY( observer_pos_x,
                                                      observer_pos_y );
      pgv_y += _pgv_y;
    }
    return pgv_y;
  }  
}
