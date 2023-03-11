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
          float chargeQa,
          float momentPxUnitVector,
          float momentPyUnitVector ) {
    src_pos_x = pos_x;              
    src_pos_y = pos_y;              
    src_radiusA = radiusA;
    src_radiusB0 = radiusA * pow(2.0, 1.0/3.0);
    src_radiusB1 = radiusA * sqrt(2.0);
    src_chargeQa = chargeQa;
    
//    float p_amplitude = pow(2.0, 1.5) * chargeQa;
    float p_amplitude =  chargeQa;
    
    src_momentPx = p_amplitude * momentPxUnitVector;
    src_momentPy = p_amplitude * momentPyUnitVector;
    
    float src_a_cubed = pow(radiusA, 3);
    float fourPi = 4*PI;

    factor_0_a   = src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b0_1st = src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b0_2nd = 2*src_a_cubed;
    factor_b0_b1 = 1.0 / fourPi;
    factor_b1    = 1.0 / fourPi;
  }
  
  
  void getGradientVector( float observer_pos_x,
                          float observer_pos_y,
                          float[] pgvec )
  {
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;
    
    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    float r_sq_inverse = 1.0 / (r*r);
    float r_cb_inverse = 1.0 / (r*r*r);
    float two_p_dot_r = 2 * ( src_momentPx * relative_pos_x
                            + src_momentPy * relative_pos_y );
    
    if ( r <= src_radiusA ) {
      pgvec[0] = -factor_0_a * relative_pos_x;
      pgvec[1] = -factor_0_a * relative_pos_y;
    } else if ( r <= src_radiusB0 ) {
      pgvec[0] = factor_a_b0_1st * relative_pos_x 
                                * ( 1.0 - factor_a_b0_2nd * r_cb_inverse );
      pgvec[1] = factor_a_b0_1st * relative_pos_y 
                                * ( 1.0 - factor_a_b0_2nd * r_cb_inverse );
    } else if ( r <= src_radiusB1 ) {
      float attenuation_factor = (r-src_radiusB0)/(src_radiusB1-src_radiusB0);
      float factor = factor_b0_b1 * attenuation_factor * r_sq_inverse; 
      pgvec[0] = -factor * ( src_momentPx - two_p_dot_r * relative_pos_x * r_sq_inverse );
      pgvec[1] = -factor * ( src_momentPy - two_p_dot_r * relative_pos_y * r_sq_inverse );
    } else { // src_radiusB1 < r      
      float factor = factor_b1 * r_sq_inverse; 
      pgvec[0] = -factor * ( src_momentPx - two_p_dot_r * relative_pos_x * r_sq_inverse );
      pgvec[1] = -factor * ( src_momentPy - two_p_dot_r * relative_pos_y * r_sq_inverse );
    }    
  }  
  
  
  float getFrictionCoeff( float observer_pos_x,
                          float observer_pos_y,
                          float observer_vel_x,
                          float observer_vel_y )
  {
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;
    float r_dot_v = relative_pos_x * observer_vel_x 
                  + relative_pos_y * observer_vel_y;

    float r = dist( 0, 0, relative_pos_x, relative_pos_y );                                          
    float directive_friction_radius = src_radiusA*3;
    float BASE_FRICTION = 1.e-3;
    float friction_coeff;
    
    if ( r_dot_v < 0  && r <= directive_friction_radius )
      friction_coeff = BASE_FRICTION * ( directive_friction_radius - r ) + BASE_FRICTION;
    else 
      friction_coeff = BASE_FRICTION;
    
    return friction_coeff;
  }
  
  
  void getForce( float observer_chargeQ,
                 float observer_pos_x,
                 float observer_pos_y,
                 float observer_vel_x,
                 float observer_vel_y,
                 float[] force) 
  {
    float[] pgvec = new float[2];
    
    getGradientVector( observer_pos_x,
                       observer_pos_y,
                       pgvec );

    float friction_coeff = getFrictionCoeff( observer_pos_x,
                                             observer_pos_y,
                                             observer_vel_x,
                                             observer_vel_y );                         
    
    force[0] = observer_chargeQ * pgvec[0] 
             - friction_coeff * observer_vel_x; 
    force[1] = observer_chargeQ * pgvec[1] 
             - friction_coeff * observer_vel_y; 
  }

  
    
  void show() {
    stroke( 0 );
    fill( 230, 240, 255 );
    ellipse( src_pos_x, src_pos_y, 2*src_radiusB1, 2*src_radiusB1 );
    fill( 255, 240, 230 );
    ellipse( src_pos_x, src_pos_y, 2*src_radiusB1, 2*src_radiusB1 );
    fill( 255, 255, 240 );
    ellipse( src_pos_x, src_pos_y, 2*src_radiusA, 2*src_radiusA );
  }
  
}
