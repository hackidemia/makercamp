int screenNum, hits;
float maxDistance;

PShape bg;
Ninja myNinja;
Finger myFinger;

void setup() {
  size(800, 480); // displayWidth, displayHeight
  maxDistance = 150;
  myNinja = new Ninja(maxDistance);
  myFinger = new Finger(maxDistance);
  bg = loadShape("bg.svg");
  screenNum = 0;
  hits = 0;
}

void draw() {
  background(255,255,255);
  shape(bg, -width/2, -height/2, width*2, height*2);
  if (screenNum == 0) {
    displayMenu();
    if (keyCode == ENTER) {
      screenNum = 1;
    }
  } else {
    myNinja.display();
    myFinger.display();
    fill(0);
    textSize(16);
    text("Hits: " + hits, 10, 40);
  }
}

void keyPressed() {
  if (keyCode == SHIFT) {
    screenNum = 0;
    hits = 0;
  }
}

void displayMenu() {
  fill(0,0,0);
  textAlign(CENTER);
  textSize(32);
  text("Hit the Ninja", width / 2, 100);
  textSize(20);
  text("As soon as you come closer to the Ninja,", width / 2, 175);
  text("you need more power to move the sword.", width / 2, 200);
  textSize(24);
  text("Press Enter to start the game.", width / 2, height / 2);
  textSize(16);
  text("Press Shift to reset the game.", width / 2, height / 2 + 50);
  textAlign(LEFT);
}
class Finger{
  float x = 0;
  float y = 0;
  float xSize = 0;
  float ySize = 0;
  float maxDistance = 0;
  float hardness = 0;
  PShape s;
  
  Finger(float _maxDistance) {
    maxDistance = _maxDistance;
    xSize = 193/2;
    ySize = 168/2;
    s = loadShape("finger.svg");
  }
  
  void display() {
    float newX = mouseX;
    float newY = mouseY;
    float distance = sqrt(pow(myNinja.x - mouseX, 2) + pow(myNinja.y - mouseY, 2));
    if (distance < maxDistance) {
        newY -= maxDistance;
        fill(255,0,0);
        textSize(20);
        text("Electricity On -> Sword up", 10, 60);      
    }
    shape(s, newX, newY, xSize, ySize);
  }
}
class Ninja {
  float x = 0;
  float y = 0;
  float xSize = 0;
  float ySize = 0;
  float direction = 2;
  int[] col = {1,0};
  boolean hit = false;
  float maxDistance;
  int count = 0;
  int move, shapeNum;
  PShape[] s = new PShape[2];

  Ninja(float _maxDistance) {
    move = 15;
    shapeNum = 0;
    maxDistance = _maxDistance;
    x = int(random(width));
    y = height - maxDistance;
    xSize = 100;
    ySize = 100;
    s[0] = loadShape("ninja1.svg");
    s[1] = loadShape("ninja2.svg");
  }

  void isPressed() {
    float r = xSize/2;
    if (mouseX > (x-r) && mouseX < (x+r) && mouseY < (y+maxDistance) && mouseY > (y+maxDistance-r)) {
      col[0] = 0;
      col[1] = 1;
      count += 1;
      if (count > 5) {
        this.next();
      }
    }
    else {
      col[0] = 1;
      col[1] = 0;
      count = 0;
    }
  }
  
  void next() {
    col[0] = 1;
    col[1] = 0;
    x = int(random(width));
    count = 0;
    hits += 1;
  }
  
  void display() {
    this.isPressed();
    fill(255*col[0],255*col[1],0);
    if (move == 0) {
      shapeNum = abs(shapeNum-1);
      move = 15;
    }
    shape(s[shapeNum], x-xSize/2, y-ySize/2, xSize, ySize);
    move -= 1;
  }
}


