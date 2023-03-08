class Monopole {
  PVector src_position;
  float src_radiusA;
  float src_radiusB;
  float src_chargeQ;

  Monopole( PVector position, 
            float radiusA, 
            float radiusB, 
            float chargeQ ) {
    src_position = position;              
    src_radiusA = radiusA;
    src_radiusB = radiusB;
    src_chargeQ = chargeQ;
  }
  
  PVector getField(PVector pos) {
    PVector relative_pos;
    PVector pheromoneGradientVector;
    
    relative_pos = pos.sub(src_position);
    pheromoneGradientVector = relative_pos;
    
    return pheromoneGradientVector;
  }
}

class Pheromone {
  
  PVector src0 = new PVector(100,100); // Agent's position

  final int MAX_NUM_MONOPOLES = 10;
  int num_monopoles = 0 ;
  Monopole[] monopoles;
  

  Pheromone() {
    monopoles = new Monopole[MAX_NUM_MONOPOLES];
  }
  
  void placeMonopole( PVector pos ) {
    monopoles[num_monopoles] = new Monopole( pos, 3.0, 10.0, 1.0 );
    num_monopoles += 1;
  }

  PVector getField(PVector pos) {
    PVector pheromoneGradientVector = new PVector(0,0);
    for (int i=0; i<num_monopoles; i++) {
      PVector pgv = monopoles[i].getField(pos);
      pheromoneGradientVector.add(pgv);
    }
    return pheromoneGradientVector;
  }
  
  PVector getPheromoneGradient( PVector pos ) {
    PVector pg;
    pg = pos.sub(src0);
    
    return pg;
  }
}
