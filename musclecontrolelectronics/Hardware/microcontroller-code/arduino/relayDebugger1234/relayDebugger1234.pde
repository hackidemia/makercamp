import processing.serial.*;

Serial port;

void setup() {
  size(100, 150);
  noStroke();
  // Select port
  println(Serial.list());
  port = new Serial(this, Serial.list()[4], 9600);
}

void draw() {
  // Only to enable the method mouseDragged
}

void mouseClicked() {
  port.write("^" + "0" + "$");
}

void mouseDragged() {

}

void keyPressed() {
  int keyIndex = -1;
  if (key == '1')
    port.write("^" + "1" + "$");
  else if (key == '2')
    port.write("^" + "2" + "$"); 
  else if (key == '3')
    port.write("^" + "3" + "$"); 
  else if (key == '4')
    port.write("^" + "4" + "$"); 
}



