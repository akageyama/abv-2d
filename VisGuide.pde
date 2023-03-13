//
// VisGuid class
// 
//   Visaulization Guid Field class.
// 

class VisGuide {
  
  int max_num_monopoles;
  int numMonopoles = 0 ;
  Monopole[] monopoles;
  
  int max_num_dipoles;
  int numDipoles = 0 ;
  Dipole[] dipoles;
  

  VisGuide(int max_num_monopoles_, int max_num_dipoles_) 
  {
    max_num_monopoles = max_num_monopoles_;
    monopoles = new Monopole[max_num_monopoles];

    max_num_dipoles = max_num_dipoles_;
    dipoles = new Dipole[max_num_dipoles];
  }

  
  void show() 
  {
    for ( int p=0; p<numMonopoles; p++ ) {
      monopoles[p].show();
    }
    for ( int p=0; p<numDipoles; p++ ) {
      dipoles[p].show();
    }
  }
  
  void placeMonopole( float src_pos_x, 
                      float src_pos_y,
                      float src_radius_a,
                      float src_chargeQa ) 
  {
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
                    float src_momentPyUnitVector) 
  {
                      
    dipoles[numDipoles] = new Dipole( src_pos_x, 
                                      src_pos_y, 
                                      src_radius_a,
                                      src_chargeQa,
                                      src_momentPxUnitVector,
                                      src_momentPyUnitVector );
    numDipoles += 1;
  }



  void getForce( float   observer_chargeQ,
                 float   observer_pos_x, 
                 float   observer_pos_y,
                 float   observer_vel_x,
                 float   observer_vel_y,
                 float[] force) 
  {
    force[0] = 0;
    force[1] = 0;
    
    float[] work = new float[2]; // 0 for x and 1 for y components
    
    for ( int p=0; p<numMonopoles; p++ ) {
      for ( int i=0; i<2; i++ ) { // x and y components
        monopoles[p].getForce( observer_chargeQ,
                               observer_pos_x,
                               observer_pos_y,
                               observer_vel_x,
                               observer_vel_y,
                               work );        
        force[i] += work[i];
      }
    }
    
    for ( int p=0; p<numDipoles; p++ ) {
      for ( int i=0; i<2; i++ ) {
        dipoles[p].getForce( observer_chargeQ,
                             observer_pos_x,
                             observer_pos_y,
                             observer_vel_x,
                             observer_vel_y,
                             work );
        force[i] += work[i];
      }
    }
  }

}
