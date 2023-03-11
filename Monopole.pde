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
  
  
  void getGradientVector( float observer_pos_x,
                          float observer_pos_y,
                          float[] pgvec )
  {
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;
    
    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    
    float r_sq_inverse = 1.0 / (r*r); // Dangerous... Check if r /= 0.
    float pgvec_r;
    
    if ( r <= src_radiusA ) {
      pgvec_r = factor_0_a * r;
    } else if ( r <= src_radiusB1 ) {
      pgvec_r = factor_a_b1 * (r-2*src_a_cubed*r_sq_inverse);
    } else { // src_radiusB1 < r      
      pgvec_r = factor_b1 * r_sq_inverse;
    }

    pgvec[0] = pgvec_r * relative_pos_x / r;
    pgvec[1] = pgvec_r * relative_pos_y / r;
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
    fill( 230, 240, 256 );
    circle( src_pos_x, src_pos_y, 2*src_radiusB1 );
    fill( 255, 255, 240 );
    circle( src_pos_x, src_pos_y, 2*src_radiusA );
  }
}
