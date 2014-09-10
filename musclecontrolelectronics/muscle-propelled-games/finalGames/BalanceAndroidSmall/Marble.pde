class Marble {
  int r;
  float x, y;
  PImage marble;
  int playerID;
  int powerup = -1;
  PImage[] sign = new PImage[3];
//  PShape marble;
  color c;

  Marble(float x_, float y_, int playerID_) {
    x = x_;
    y = y_;
    playerID = playerID_;
    if (playerID == 0) {
      c = color(0, 150, 0);
    }
    if (playerID == 1) {
      c = color(150, 0, 0);
    }
//    marble = loadShape("ball3.svg");
    marble = loadImage("marble.png");
    sign[0] = loadImage("lightning.png");
    sign[1] = loadImage("rumble.png");
    sign[2] = loadImage("lightning.png");
  }
  
  void gotPowerup(int type_) {
    powerup = type_;
  }
  
  void usedPowerup() {
    powerup = -1;
  }
  
  void display(float x_, float y_) {
    x = x_;
    y = y_;
    tint(c);
    image(marble, x, y);
    if (powerup >= 0) {
      tint(255);
      image(sign[powerup], x, y, size, size);
    }
  }
}
