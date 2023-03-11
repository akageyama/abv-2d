/*

  abv-2d.pde
 
 */


boolean runningStateToggle = true;

float simulationTime = 0.0; 

int NUM_AGENTS = 100;  // number of camera agents

Agent[] agents = new Agent[NUM_AGENTS];

VisGuide visGuide = new VisGuide();


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
  
  visGuide.show();
  
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
  
  float radiusA = width/40;
  float chargeQa = 1.e3;
  
  // place monopoles
  for ( int p=0; p<1; p++ ) {
    float pos_x = random( width*0.1, width*0.5 );
    float pos_y = random( height*0.1, height*0.9 );
    visGuide.placeMonopole(pos_x, pos_y, radiusA, chargeQa );
  }
                           
  
  // place dipoles
  for ( int p=0; p<1; p++ ) {
    float pos_x = random( width*0.6, width*0.9 );
    float pos_y = random( height*0.1, height*0.9 );
    float momentAngle = random( 0, TWO_PI );
    float momentPx = cos(momentAngle);
    float momentPy = sin(momentAngle);
    visGuide.placeDipole( pos_x, pos_y, radiusA, chargeQa,
                          momentPx, momentPy );
    }
  }


void mousePressed() {
  runningStateToggle = !runningStateToggle;
  if ( !runningStateToggle ) { // stopped.
    println( " Stopped." );
  }
}
