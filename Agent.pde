
class Agent {
  PVector position;
  PVector velocity;

  color col;    // color.

  Agent( PVector initialPosition,
         PVector initialVelocity,
         int red, 
         int green, 
         int blue ) {
    position = initialPosition;
    velocity = initialVelocity;
println(" in Agent pos.x = " + position.x + " pos.y = " + position.y );    
    col = color( red, green, blue );
  }
  
  
  void display() {
    stroke( 0 );
    fill( col );
println( "in show of Agent, pos.x,y = " + position.x + " " + position.y );  
    ellipse( position.x, position.y, 10, 10 );  // place a circle
  }

  void move(float dt) {
    PVector field;
    
    //field = pheromone.getField(
    
    //position.add( velocity.mult( dt ) );
        
    if ( position.x >= width ) { // The agent hits the right wall. 
      position.x = width;
      velocity.x = -velocity.x; // Reverse the direction.
    }
    if ( position.x<= 0 ) {  // Hit the left wall.
      position.x = 0;
      velocity.x = -velocity.x;
    }
    if ( position.y >= height ) {// Hit the floor. 
      position.y = height;
      velocity.y = -velocity.y; // Reverse the direction.
    }
    if ( position.y <= 0 ) {  // Hit the ceiling.
      position.y = 0;
      velocity.y = -velocity.y;
    }
  }
}
