class Ninja {
  int x = 0;
  int y = 0;
  int xSize = 0;
  int ySize = 0;
  int direction = 2;
  boolean hit = false;
  int maxDistance;
  int life;
  int move, shapeNum;
  PShape[] s = new PShape[2];
  PShape blood;
  int bloodTime = 1000;

  Ninja(int _maxDistance) {
    move = 15;
    shapeNum = 0;
    maxDistance = _maxDistance;
    xSize = 200;
    ySize = 200;
    life = 100;
    x = int(random(xSize, width - xSize));
    y = height - xSize/2-50;
    s[0] = loadShape("ninja1.svg");
    s[1] = loadShape("ninja2.svg");
    blood = loadShape("blood.svg");
  }

  // checks if the ninja was hit
  void isHit() {
    float r = xSize / 2;

    // check if the mouse is in the range if the ninja
    if (mouseX > (x-r) && mouseX < (x+r) && mouseY < (y+r) && mouseY > (y-r)) {
      isClose = true;
//      fill(255, 0, 0);
//      textSize(40);
//      text("Electricity On -> Finger up", 10, 100);      
      if (btIsOff) {
        println("BT ON");
        bt.broadcast(btOn);
        btIsOff = false;
      }

      // check if the slice is complete (over the full distance)
      if (abs(distance[0] - mouseX) >= (xSize-10)) {
        // HIT!
        lastHit = millis();
        if (enableVibration) {
          vibe.vibrate(100);
        }
        life -= int(random(35, 60));
        distance[0] = mouseX;
        distance[1] = mouseY;
      }
    }
    else {
      // remember the position where the slice started
      distance[0] = mouseX;    
      distance[1] = mouseY;
      isClose = false;
      if (!btIsOff) {
        println("BT OFF");
        bt.broadcast(btOff);
        btIsOff = true;
      }
    }
    // number of hits to defeat the ninja
    if (life <= 0) {
      bt.broadcast(btOff);
      lastKill = millis();
      this.next();
    }
  }

  // set the ninja to a new position
  void next() {
    life = 100;
    hits += 1;
    int tmpX = x;
    while (abs (tmpX - x) < maxDistance) {
      tmpX = int(random(xSize+20, width - xSize-20));
    }
    x = tmpX;
  }

  void display() {
    this.isHit();
    // let the ninja move
    if (move == 0) {
      shapeNum = abs(shapeNum-1);
      move = 8;
    }
    shape(s[shapeNum], x-xSize/2, y-ySize/2, xSize, ySize);
    // show blood for x seconds after a valid hit
    if ((lastHit + bloodTime) > millis() && life < 100) {
      shape(blood, x-xSize/2, y-ySize/2, xSize, ySize);
    }
    move -= 1;
  }
}

