/*

  abv-2d.pde
  
 */


boolean runningStateToggle = false;

float simulationTime = 0.0; 

int NUM_AGENTS=10;

Agent[] agents;

//Pheromone pheromone = new Pheromone();



void draw() {
  float dt = 0.1; // delta t (time increment).
  
  background( 150, 150, 200 );

  if ( runningStateToggle ) {
    for ( int i=0; i<NUM_AGENTS; i++ ) {
      agents[i].move( dt );
    }  
    simulationTime = simulationTime + dt;  
    println( " t = " + simulationTime );
  }   
 
  PVector pg;
  PVector pos = new PVector(100,100);
  
  for ( int i=0; i<NUM_AGENTS; i++ ) {
    agents[i].display();
    println( " in mian/draw, agents[" + i + "].x = " + agents[i].position.x );    
    //pg = pheromone.getField( pos );
    //println(pg);
  } //<>//
  
  //for ( Agent ant : agents ) {
  //  println( " in mian/draw, agent pos.x = " + ant.position.x );    
  //  ant.display();
  //}
  
}


void setup() {
  size( 1000, 800 );
  float maxVelocity = 0.0;
  float minVelocity = 0.0;
  PVector pos = new PVector(0,0);
  PVector vel = new PVector(0,0);
  
  agents = new Agent[NUM_AGENTS];

  for ( int i=0; i<NUM_AGENTS; i++ ) {
    // position
    pos.x = random( width );
    pos.y = random( height );
    println( " i,x,y = " + i + " " + pos.x + " " + pos.y );
    // velocity
    float velocity = random( minVelocity, maxVelocity );
    float angle = random( 0, TWO_PI );
    vel.x = velocity*cos( angle );
    vel.y = velocity*sin( angle );
    // color
    int r = int( random( 100, 255 ) );
    int g = int( random( 100, 255 ) );
    int b = int( random( 100, 255 ) );
    agents[i] = new Agent( pos, vel, r, g, b );
    println(" in setup, agents[" + i + "].position.x = " + agents[i].position.x );
  }  
  
  //PVector  = new PVector(300,300);
  //pheromone.placeMonopole( pos );
}


void mousePressed() {
  runningStateToggle = !runningStateToggle;
  if ( !runningStateToggle ) { // stopped.
    println( " Stopped." );
  }
}
