//
// LinearPole moment class
// 
//   Similarly to the Monopole, a linear pole
//   generates a radially symmetric field from
//   its source position. Contrary to Monopole,
//   the amplitude decays linearly as a function
//   of distance.
//  
//                    |
//                    |
//                    *
//                  * | *
//                *   |   *
//              *     |     *
//      - - - * - - - + - - - * - - - 
// 


class Linearpole {
  float src_pos_x;           // position of the dipole in the window coords.
  float src_pos_y;
  float src_radius;          // The base radius "r_a" of the dipole.
  float src_chargeQ;         // Total charge in the sphere of radius r_a.


  Linearpole( float pos_x,
              float pos_y, 
              float radius, 
              float chargeQ ) 
{
    src_pos_x = pos_x;              
    src_pos_y = pos_y;              
    src_radius = radius;
    src_chargeQ = chargeQ;
  }
  
  
  void getVisGuideVector( float   observer_pos_x,
                          float   observer_pos_y,
                          float[] pgvec )
  {
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;
    
    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    float pgvec_r;
    
    if ( r <= src_radius ) {
      pgvec_r = src_chargeQ * ( src_radius - r ) / src_radius;
    }
    else {
      pgvec_r = 0;
    }

    pgvec[0] = pgvec_r * relative_pos_x / r;
    pgvec[1] = pgvec_r * relative_pos_y / r;
  }  
  
  

float getFrictionCoeff( float observer_pos_x,
                        float observer_pos_y )
  {
    float relative_pos_x = observer_pos_x - src_pos_x;
    float relative_pos_y = observer_pos_y - src_pos_y;

    float r = dist( 0, 0, relative_pos_x, relative_pos_y );
    float BASE_FRICTION = 1.e-2;
    float friction_coeff;
    
    friction_coeff = BASE_FRICTION;   // Basic air resistance for agent motion.

    if ( r <= src_radius ) {
      float nearness = ( src_radius - r ) / src_radius;      
      friction_coeff = BASE_FRICTION * nearness;      
    }
    else {
      friction_coeff = 0.0;      
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

  
  void show() {
    stroke( 255 );
    fill( 255, 220, 220 );
    ellipse( src_pos_x, src_pos_y, 2*src_radius, 2*src_radius );
  }
}
