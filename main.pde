/*

  abv-2d.pde
 
 */


boolean runningStateToggle = true;

float simulationTime = 0.0; 

int NUM_AGENTS = 8;

Agent[] agents = new Agent[NUM_AGENTS];

Pheromone pheromone = new Pheromone();

void draw() {
  float dt = 0.1; // delta t (time increment).
  
  background( 150, 150, 200 );

  if ( runningStateToggle ) {
    for ( int repeat = 0; repeat< 20; repeat++ ) {
      for ( int i=0; i<NUM_AGENTS; i++ ) {
        agents[i].move( dt );
      }
    }
    simulationTime += dt;  
    println( " t = " + simulationTime );
  } 
  
  pheromone.show();
  
  for ( int i=0; i<NUM_AGENTS; i++ ) {
    agents[i].show();
  }  
 
}


void setup() {
  size( 1000, 800 );
  
  for ( int i=0; i<NUM_AGENTS; i++ ) {
    // initial position
    float x0 = random( width );
    float y0 = random( height );
    // initial velocity
    float vx0 = 0.0;
    float vy0 = 0.0;
    // color
    int r = int( random( 100, 255 ) );
    int g = int( random( 100, 255 ) );
    int b = int( random( 100, 255 ) );
    agents[i] = new Agent( x0, y0, vx0, vy0, r, g, b ); 
  }  
  
  float monopole_radiusA = width/6;
  pheromone.placeMonopole( width/2, 
                           height/2,
                           monopole_radiusA );
}


void mousePressed() {
  runningStateToggle = !runningStateToggle;
  if ( !runningStateToggle ) { // stopped.
    println( " Stopped." );
  }
}
