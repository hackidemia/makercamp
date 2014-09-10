class Powerup {
  int type;
  int h;
  int r;
  float x, y;
  PImage[] sign = new PImage[3];

  Powerup() {
    type = int(random(0, 2));
    h = int(size*2);
    r = h / 2;
    x = int(random(0+h, width-h));
    y = int(random(0+h, height-h));
    sign[0] = loadImage("lightning.png");
    sign[1] = loadImage("rumble.png");
    sign[2] = loadImage("lightning.png");
  }

  void set(float x_, float y_, int type_) {
    x = x_;
    y = y_;
    type = type_;
  }

  void reset() {
    type = int(random(0, 2));
    x = int(random(0+h, width-h));
    y = int(random(0+h, height-h));
  }

  void display() {
//    fill(0, 0, 255);
//    ellipse(x, y, h, h);
    tint(190);
    image(sign[type], x, y, h/3*2, h/3*2);
//    fill(0, 0, 0);
  }
}

void activateFeedback(int type) {
  feedbackActive = true;
  feedbackStart = millis();
  println("Starting: ");
  // turn ports on
  if (btIsOff) {
    if (type == 0) {
      print(type);
      if (myMarble.y <= myTarget.y) {
        println("LEFT");
        btOn[0] = 3;
        btOff[0] = 4;
      } else {
        println("RIGHT");
        btOn[0] = 1;
        btOff[0] = 2;
      }
    }
    if (type == 1) {
      print(type);
      btOn[0] = 5;
      btOff[0] = 6;
    }
    if (type == 2) {
      print(type);
    }
  }
  
  if (btIsOff) {
    println("BT ON");
    bt.broadcast(btOn);
    btIsOff = false;
  }

  currentFeedbackTime = 4000; //feedbackTime*type*2+1000;
  if (enableVibration) {
    vibe.vibrate(currentFeedbackTime);
  }
}

void deactivateFeedback() {
  
  if (!btIsOff) {
    println("BT OFF");
    bt.broadcast(btOff);
    btIsOff = true;
  }  
  
  feedbackActive = false;
  println("Stopping!");
  // all ports off
}

