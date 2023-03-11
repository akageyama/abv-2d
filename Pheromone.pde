class Monopole {
  float src_pos_x;
  float src_pos_y;
  float src_radiusA;
  float src_radiusB0;
  float src_radiusB1;
  float src_chargeQa;
  float src_a_cubed; // = src_radiusA^3
  
  float factor_0_a, factor_a_b1, factor_b1;

  Monopole( float pos_x,
            float pos_y, 
            float radiusA, 
            float chargeQa ) {
    src_pos_x = pos_x;              
    src_pos_y = pos_y;              
    src_radiusA = radiusA;
    src_radiusB0 = radiusA * pow(2.0, 1.0/3.0);
    src_radiusB1 = radiusA * sqrt(2.0);
    src_chargeQa = chargeQa;
    src_a_cubed = pow(src_radiusA, 3);

    float fourPi = 4*PI;
    float alpha = pow(2.0, 1.5) - 2.0;

    factor_0_a = -src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b1 = src_chargeQa / (fourPi*src_a_cubed);
    factor_b1 = src_chargeQa * alpha / fourPi;
  }
  
  
  float gradientVectorR( float r ) {
    float r_sq_inverse;
    float pgvr; // pheromone gradient vector, its radial component.
    
    r_sq_inverse = 1.0 / (r*r); // Dangerous... Check if r /= 0.
    
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
  
  
  void show() {
    stroke( 0 );
    fill( 230, 240, 256 );
    circle( src_pos_x, src_pos_y, 2*src_radiusB1 );
    fill( 255, 255, 240 );
    circle( src_pos_x, src_pos_y, 2*src_radiusA );
  }
}



class Dipole {
  float src_pos_x;
  float src_pos_y;
  float src_radiusA;
  float src_radiusB0;
  float src_radiusB1;
  float src_chargeQa;
  float src_momentPx;
  float src_momentPy;
  
  float factor_0_a;
  float factor_a_b0_1st;
  float factor_a_b0_2nd;
  float factor_b0_b1;
  float factor_b1;

  Dipole( float pos_x,
          float pos_y, 
          float radiusA, 
          float chargeQ,
          float momentPxUnitVector,
          float momentPyUnitVector ) {
    src_pos_x = pos_x;              
    src_pos_y = pos_y;              
    src_radiusA = radiusA;
    src_radiusB0 = radiusA * pow(2.0, 1.0/3.0);
    src_radiusB1 = radiusA * sqrt(2.0);
    src_chargeQa = chargeQ;
    
    float p_amplitude = pow(2.0, 1.5) * chargeQ;
    
    src_momentPx = p_amplitude * momentPxUnitVector;
    src_momentPy = p_amplitude * momentPyUnitVector;
    
    float src_a_cubed = pow(radiusA, 3);
    float fourPi = 4*PI;

    factor_0_a   = -src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b0_1st = src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b0_2nd = 2*src_a_cubed;
    factor_b0_b1 = -1.0 / fourPi;
    factor_b1    = -1.0 / fourPi;
  }
  

  float getGradientVectorX( float observer_pos_x,
                            float observer_pos_y ) {
    
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;
    
    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    float r_sq_inverse = 1.0 / (r*r);
    float r_cb_inverse = 1.0 / (r*r*r);
    float two_p_dot_r = 2 * ( src_momentPx * relative_pos_x
                            + src_momentPy * relative_pos_y );

    float pgv_x;    
    
    if ( r <= src_radiusA ) {
      pgv_x = factor_0_a * relative_pos_x;
    } else if ( r <= src_radiusB0 ) {
      pgv_x = factor_a_b0_1st * relative_pos_x 
                              * ( 1.0 - factor_a_b0_2nd * r_cb_inverse );
    } else if ( r <= src_radiusB1 ) {
      float attenuation_factor = (r-src_radiusB0)/(src_radiusB1-src_radiusB0);
      float factor = factor_b0_b1 * attenuation_factor * r_sq_inverse; 
      pgv_x = factor * ( src_momentPx - two_p_dot_r * relative_pos_x * r_sq_inverse );
    } else { // src_radiusB1 < r      
      float factor = factor_b0_b1 * r_sq_inverse; 
      pgv_x = factor * ( src_momentPx - two_p_dot_r * relative_pos_x * r_sq_inverse );
    }    
    return pgv_x;                                         
  }
  

  float getGradientVectorY( float observer_pos_x,
                            float observer_pos_y ) {
    
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;
    
    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    float r_sq_inverse = 1.0 / (r*r);
    float r_cb_inverse = 1.0 / (r*r*r);
    float two_p_dot_r = 2 * ( src_momentPx * relative_pos_x
                            + src_momentPy * relative_pos_y );

    float pgv_y;    
    
    if ( r <= src_radiusA ) {
      pgv_y = factor_0_a * relative_pos_y;
    } else if ( r <= src_radiusB0 ) {
      pgv_y = factor_a_b0_1st * relative_pos_y 
                              * ( 1.0 - factor_a_b0_2nd * r_cb_inverse );
    } else if ( r <= src_radiusB1 ) {
      float attenuation_factor = (r-src_radiusB0)/(src_radiusB1-src_radiusB0);
      float factor = factor_b0_b1 * attenuation_factor * r_sq_inverse; 
      pgv_y = factor * ( src_momentPy - two_p_dot_r * relative_pos_y * r_sq_inverse );
    } else { // src_radiusB1 < r      
      float factor = factor_b0_b1 * r_sq_inverse; 
      pgv_y = factor * ( src_momentPy - two_p_dot_r * relative_pos_y * r_sq_inverse );
    }    
    return pgv_y;                                         
  }
  
  
  void show() {
    stroke( 0 );
    fill( 230, 240, 255 );
    circle( src_pos_x, src_pos_y, 2*src_radiusB1 );
    fill( 255, 240, 230 );
    circle( src_pos_x, src_pos_y, 2*src_radiusB1 );
    fill( 255, 255, 240 );
    circle( src_pos_x, src_pos_y, 2*src_radiusA );
  }
}


class Pheromone {
  
  final int MAX_NUM_MONOPOLES = 10;
  int numMonopoles = 0 ;
  Monopole[] monopoles;
  
  final int MAX_NUM_DIPOLES   = 10;
  int numDipoles = 0 ;
  Dipole[] dipoles;
  

  Pheromone() {
    monopoles = new Monopole[MAX_NUM_MONOPOLES];
    dipoles   = new Dipole[MAX_NUM_DIPOLES];
  }

  
  void show() {
    for ( int i=0; i<numMonopoles; i++ ) {
      monopoles[i].show();
    }
    for ( int i=0; i<numDipoles; i++ ) {
      dipoles[i].show();
    }
  }
  
  void placeMonopole( float src_pos_x, 
                      float src_pos_y,
                      float src_radius_a,
                      float src_chargeQa ) {
    monopoles[numMonopoles] = new Monopole( src_pos_x, 
                                            src_pos_y, 
                                            src_radius_a,
                                            src_chargeQa );
    numMonopoles += 1;
  }
  
            
  void placeDipole( float src_pos_x, 
                    float src_pos_y,                    
                    float src_radius_a,
                    float src_chargeQa,
                    float src_momentPxUnitVector,
                    float src_momentPyUnitVector) {
                      
    dipoles[numDipoles] = new Dipole( src_pos_x, 
                                      src_pos_y, 
                                      src_radius_a,
                                      src_chargeQa,
                                      src_momentPxUnitVector,
                                      src_momentPyUnitVector );
    numDipoles += 1;
  }


  float getGradientVectorX( float observer_pos_x, 
                            float observer_pos_y) {
    float pgv_x = 0.0; // pheromone gradient vector
    
    for (int i=0; i<numMonopoles; i++) {
      float _pgv_x = monopoles[i].getGradientVectorX( observer_pos_x,
                                                      observer_pos_y );
      pgv_x += _pgv_x;
    }
    
    for (int i=0; i<numDipoles; i++) {
      float _pgv_x = dipoles[i].getGradientVectorX( observer_pos_x,
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
    
    for (int i=0; i<numDipoles; i++) {
      float _pgv_y = dipoles[i].getGradientVectorY( observer_pos_x,
                                                    observer_pos_y );
      pgv_y += _pgv_y;
    }  
    
    return pgv_y;
  }  
}
