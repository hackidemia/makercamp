void setup() {
  size(600, 600);  
  background(250, 7, 30);
  stroke(0, 0, 255);
  fill(200, 200, 0);
  strokeWeight(3);
  line(width, height, width/2, height/2);
  rectMode(CENTER);
  colorMode(HSB, 360);
  frameRate(5);
}

float distance(int x1, int y1, int x2, int y2) {
  return sqrt(sq(x2-x1)+(y2-y1));
}

float af = 1;

void draw() {
  background(0);  
  rect(width/2, height/2, 100, 100);
  float lastX = width/2;
  float lastY = height/2;
  for (int i=0; i < 360; i++) {
    float angle = i*af*0.1;
    float dist = 10+i*2;
    fill(i, 350, 350, 169);
    float x = width/2+ cos(radians(angle))*dist;
    float y = height/2+ sin(radians(angle))*dist;
    line(x, y, lastX, lastY);
    lastX = x;
    lastY = y;
  }
  af = af + 1.0;
}
