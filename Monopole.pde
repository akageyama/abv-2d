//
// Monopole moment class
// 
//   Data and methods of a dipole moment that generates
//   a monopole-type visualization guide (VisGuid) field .
// 


class Monopole {
  float src_pos_x;           // position of the dipole in the window coords.
  float src_pos_y;
  float src_radiusA;         // The base radius "r_a" of the dipole. 
  float src_radiusB0;
  float src_radiusB1;
  float src_chargeQa;        // Total charge in the sphere of radius r_a.
  float src_a_cubed;         // a^3
  float src_radiusCutOff;    // Distant (weak) dipole field is forced to be zero.
  
  float factor_0_a, factor_a_b1, factor_b1;
                             // These factors will be used many times in the 
                             // computaion of the visGuide field for every camera
                             // agent, for every time step. It's wise to calcuate 
                             // these factors just once to save time.

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
    src_radiusCutOff = radiusA*15;

    float fourPi = 4*PI;
    float alpha = pow(2.0, 1.5) - 2.0;

    factor_0_a  = src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b1 = src_chargeQa / (fourPi*src_a_cubed);
    factor_b1   = src_chargeQa * alpha / fourPi;
  }
  
  
  void getVisGuideVector( float   observer_pos_x,
                          float   observer_pos_y,
                          float[] pgvec )
  {
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;
    
    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    
    float r_sq_inverse = 1.0 / (r*r); // Dangerous... Check if r /= 0.
    float pgvec_r;
        
    if ( r <= src_radiusA ) {
      pgvec_r = -factor_0_a * r;
    } else if ( r <= src_radiusB1 ) {
      pgvec_r = factor_a_b1 * (r-2*src_a_cubed*r_sq_inverse);
    } else if ( r <= src_radiusCutOff ) {      
      pgvec_r = factor_b1 * r_sq_inverse;
    }
    else {
      pgvec_r = 0;
    }

    pgvec[0] = pgvec_r * relative_pos_x / r;
    pgvec[1] = pgvec_r * relative_pos_y / r;
  }  
  
  

float getFrictionCoeff( float observer_pos_x,
                        float observer_pos_y, )
  {
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;

    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    float directive_friction_radius = src_radiusCutOff/4;
    float BASE_FRICTION = 1.e-3;
    float friction_coeff;
    
    friction_coeff = 0;   // Basic air resistance for agent motion.

    if ( r <= directive_friction_radius ) {
      // When an agent is close to the src position, it feels
      // larger resistance. This additional resistance is 
      // introduced to reduce the high speed "falling" of agent.
      float nearness = ( directive_friction_radius - r ) 
                       / directive_friction_radius;      
      friction_coeff = 100 * BASE_FRICTION * nearness;
      
    }
    
    return friction_coeff;
  }  
  
  
  void getForce( float   observer_chargeQ,
                 float   observer_pos_x,
                 float   observer_pos_y,
                 float   observer_vel_x,
                 float   observer_vel_y,
                 float[] force) 
  {
    float[] pgvec = new float[2];
    
    getVisGuideVector( observer_pos_x,
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
