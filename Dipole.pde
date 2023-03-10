//
// Dipole moment class
// 
//   Data and methods of a dipole moment that generates
//   a dipole-type visualization guide (VisGuid) field .
// 

class Dipole {
  float src_pos_x;           // position of the dipole in the window coords.
  float src_pos_y;         
  float src_radiusA;         // The base radius "r_a" of the dipole. 
  float src_radiusB0;
  float src_radiusB1;
  float src_chargeQa;        // Total charge in the sphere of radius r_a.  
  float src_radiusCutOff;    // Distant (weak) dipole field is forced to be zero.
  float src_momentPx;        // Dipole moment vector with x and y components.
  float src_momentPy;      
  float src_momentPxUnitVec; // Same as vector src_momentP but normalized to 1.
  float src_momentPyUnitVec;
  
  
  float factor_0_a;          // These factors will be used many times in the 
  float factor_a_b0_1st;     // computaion of the visGuide field for every camera
  float factor_a_b0_2nd;     // agent, for every time step. It's wise to calcuate 
  float factor_b0_b1;        // these factors just once to save time.
  float factor_b1;

  Dipole( float pos_x,
          float pos_y, 
          float radiusA, 
          float chargeQa,
          float momentPx,
          float momentPy ) 
  {
    src_pos_x = pos_x;              
    src_pos_y = pos_y;              
    src_radiusA = radiusA;
    src_radiusB0 = radiusA * pow(2.0, 1.0/3.0);
    src_radiusB1 = radiusA * sqrt(2.0);
    src_chargeQa = chargeQa;
    src_radiusCutOff = radiusA*15;
    
    float p_amplitude = pow(2.0, 1.5) * chargeQa;
      // This is not a rigorous relation.
      // 
      // A "dipole" is actually consists of the inner
      // (double-layered) monopole and the outer dipole
      // The strength of the inner dipole is controled by
      // the parameter chargeQa, while the strength of the
      // outer dipole is specified by the moment vector 
      // (momentPx, momentPy). To realize a smooth passing
      // of the agent camera between the interface of the
      // inner and outer layers, we assume the this relationship.
    
    float momentVecAmp = dist( 0, 0, momentPx, momentPy );
    src_momentPxUnitVec = momentPx / momentVecAmp;
    src_momentPyUnitVec = momentPy / momentVecAmp;
    src_momentPx = p_amplitude * src_momentPxUnitVec;
    src_momentPy = p_amplitude * src_momentPyUnitVec;
    
    float src_a_cubed = pow(radiusA, 3);
    float fourPi = 4*PI;

    factor_0_a      = src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b0_1st = src_chargeQa / (fourPi*src_a_cubed);
    factor_a_b0_2nd = 2*src_a_cubed;
    factor_b0_b1    = 1.0 / fourPi;
    factor_b1       = 1.0 / fourPi;
  }
  
  
  void getVisGuideVector( float   observer_pos_x,
                          float   observer_pos_y,
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
    } else if ( r <= src_radiusCutOff ) {    
      float factor = factor_b1 * r_sq_inverse; 
      pgvec[0] = -factor * ( src_momentPx - two_p_dot_r * relative_pos_x * r_sq_inverse );
      pgvec[1] = -factor * ( src_momentPy - two_p_dot_r * relative_pos_y * r_sq_inverse );
    } else {
      pgvec[0] = 0;
      pgvec[1] = 0;
    }    
  }  
  
  
  float getFrictionCoeff( float observer_pos_x,
                          float observer_pos_y )
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
      // introduced to help the agent come along the direction 
      // of the moment's vector (momentPx, momentPy).
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
                                             observer_pos_y );                         
    
    force[0] = observer_chargeQ * pgvec[0] 
               - friction_coeff * observer_vel_x; 
    force[1] = observer_chargeQ * pgvec[1] 
               - friction_coeff * observer_vel_y; 
  }


    
  void show() 
  {
    stroke( 0 );
    fill( 230, 240, 255 );
    ellipse( src_pos_x, src_pos_y, 2*src_radiusB1, 2*src_radiusB1 );
    fill( 255, 240, 230 );
    ellipse( src_pos_x, src_pos_y, 2*src_radiusB1, 2*src_radiusB1 );
    fill( 255, 255, 240 );
    ellipse( src_pos_x, src_pos_y, 2*src_radiusA, 2*src_radiusA );

    // We draw a arrow-symbol to indicate the direction of the moment.
    float arrow_length = src_radiusB0;
    float arrow_vx = arrow_length*src_momentPxUnitVec;
    float arrow_vy = arrow_length*src_momentPyUnitVec;
    
    strokeWeight(2);
    draw_arrow( src_pos_x, src_pos_y, 
                arrow_vx, arrow_vy );
    strokeWeight(1);
  }

  

  void draw_arrow( float x, float y, float vect_x, float vect_y )
  {
    //             1 (x1,y1)
    //            /|\
    //           / | \ 
    // (x3,y3)  3  2  4  (x4,y4)
    //             |
    //             o (x,y)   
    //             |
    //             | 
    //             | 
    //             0 (x0,y0)
    //  
    float vect_length = sqrt( vect_x*vect_x + vect_y*vect_y );
    if ( vect_length < 1.e-10 ) return;
    
    float x0 = x - 0.5*vect_x;
    float y0 = y - 0.5*vect_y;
    float x1 = x0 + vect_x;
    float y1 = y0 + vect_y;
    float x2 = x0 + (3.0/4.0)*vect_x;
    float y2 = y0 + (3.0/4.0)*vect_y;
    float unit_v01x = vect_x / vect_length;
    float unit_v01y = vect_y / vect_length;
    float unit_v34x =  unit_v01y;
    float unit_v34y = -unit_v01x;
    float x4 = x2 + unit_v34x*vect_length*0.2;
    float y4 = y2 + unit_v34y*vect_length*0.2;
    float x3 = x2 - unit_v34x*vect_length*0.2;
    float y3 = y2 - unit_v34y*vect_length*0.2;
    line( x0, y0, x1, y1 );
    line( x3, y3, x1, y1 );
    line( x4, y4, x1, y1 );
  }

  
}
