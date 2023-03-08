/*
  abv-2d.pde
 
 */


boolean runningStateToggle = true;

float simulationTime = 0.0; 

int NUM_AGENTS=100;

Agent[] agents = new Agent[NUM_AGENTS];

Pheromone pheromone = new Pheromone();

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
    agents[i].show();
    // pg = pheromone.getPheromoneGradient( pos );
    pg = pheromone.getField( pos );
    println(pg);
  }
}


void setup() {
  size( 1000, 800 );
  float maxVelocity = 50.0;
  float minVelocity =  0.0;
  
  
  for ( int i=0; i<NUM_AGENTS; i++ ) {
    // position
    float x0 = random( width );
    float y0 = random( height );
    // velocity
    float vel = random( minVelocity, maxVelocity );
    float angle = random( 0, TWO_PI );
    float vx0 = vel*cos( angle );
    float vy0 = vel*sin( angle );
    // color
    int r = int( random( 100, 255 ) );
    int g = int( random( 100, 255 ) );
    int b = int( random( 100, 255 ) );
    agents[i] = new Agent( x0, y0, vx0, vy0, r, g, b ); 
  }  
  
  PVector pos = new PVector(300,300);
  pheromone.placeMonopole( pos );
}


void mousePressed() {
  runningStateToggle = !runningStateToggle;
  if ( !runningStateToggle ) { // stopped.
    println( " Stopped." );
  }
}
