class Finger {
  float x = 0;
  float y = 0;
  float xSize = 0;
  float ySize = 0;
  float maxDistance = 0;
  PShape s;
  
  Finger(float _maxDistance) {
    maxDistance = _maxDistance;
    xSize = 96;
    ySize = 84;
    s = loadShape("sword.svg");
  }
  
  void display() {
    shape(s, mouseX-xSize/2, mouseY-ySize, parseInt(xSize*1.5), parseInt(ySize*1.5));
  }
}
