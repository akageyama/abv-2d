class Pheromone {
  
  PVector src0; // Agent's position

  Pheromone( PVector s ) {
    src0 = s;
  }

  PVector getPheromoneGradient( PVector pos ) {
    PVector pg;
    pg = pos.sub(src0);
    
    return pg;
  }
}  
