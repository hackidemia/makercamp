class Target {
  float x, y;
  int playerID;
  int score;
  int r;

  Target(float x_, float y_, int playerID_) {
    r = size*2 + 10;
    x = x_;
    y = y_;
    playerID = playerID_;
    score = 0;
  }
  
  void display(float x_, float y_) {
    x = x_;
    y = y_;
    fill (0);
    strokeWeight(6);
    
    if (playerID == 0) {
      stroke(0, 150, 0);
    }
    if (playerID == 1) {
      stroke(150, 0, 0);
    }

    ellipse(x, y, r, r);
    
    noStroke();
    fill(255);
    text(score, x, y);
  }
  
}
