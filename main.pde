/*

  abv-2d.pde
 
 */


boolean runningStateToggle = true;

float simulationTime = 0.0; 

final int MAX_NUM_MONOPOLES = 20;
final int MAX_NUM_DIPOLES = 20;

int NUM_AGENTS = 40;  // number of camera agents

Agent[] agents = new Agent[NUM_AGENTS];

VisGuide visGuideByVOI = new VisGuide( MAX_NUM_MONOPOLES, 
                                       MAX_NUM_DIPOLES ); 

VisGuide visGuideByOtherAgents = new VisGuide( NUM_AGENTS-1, 0 );


VisGuide calc_visGuideByOtherAgnets( int myAgentId ) 
{
  VisGuide answer = new VisGuide( NUM_AGENTS-1, 0 );
  
  for ( int i=0; i<NUM_AGENTS; i++ ) {
    if ( i == myAgentId ) continue; // skip myself.
    answer.placeMonopole( agents[i].pos_x,
                          agents[i].pos_y,
                          agents[i].radius,
                          agents[i].chargeQ );
  }  
  return answer;
}


void draw() {
  float dt = 0.1; // delta t (time increment). 
                  // This should be fixed by each simulation.
  
  background( 150, 150, 200 );  // Background color of the window.

  
  if ( runningStateToggle ) { // Agents move if ON. Switch by mouse click.    
    for ( int repeat = 0; repeat<10; repeat++ ) { // To accelerate the computation
      for ( int i=0; i<NUM_AGENTS; i++ ) {         // of agents' motion.
        visGuideByOtherAgents = calc_visGuideByOtherAgnets( i );
        agents[i].move( dt, 
                        visGuideByVOI, 
                        visGuideByOtherAgents );  // Move for one time step.
      }
    }
    simulationTime += dt;  
    println( " t = " + simulationTime );
  } 
  
  visGuideByVOI.show();     // Draw monopole/dipole (colored circles).
  
  for ( int i=0; i<NUM_AGENTS; i++ ) {
    agents[i].show();  // Draw agents (random color small circles).
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
    visGuideByVOI.placeMonopole(pos_x, pos_y, radiusA, chargeQa );
  }
                           
  
  // place dipoles
  for ( int p=0; p<1; p++ ) {
    float pos_x = random( width*0.6, width*0.9 );
    float pos_y = random( height*0.1, height*0.9 );
    float momentAngle = random( 0, TWO_PI );
    float momentPx = cos(momentAngle);
    float momentPy = sin(momentAngle);
    visGuideByVOI.placeDipole( pos_x, pos_y, radiusA, chargeQa,
                             momentPx, momentPy );
    }

}


void mousePressed() {
  runningStateToggle = !runningStateToggle;
  if ( !runningStateToggle ) { // stopped.
    println( " Stopped." );
  }
}
