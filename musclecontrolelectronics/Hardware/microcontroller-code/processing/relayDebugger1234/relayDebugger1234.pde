import processing.serial.*;

Serial port;

void setup() {
  size(500, 250);
  noStroke();
  // Select port
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  textAlign(CENTER);
}

void draw() {
  // Only to enable the method mouseDragged
  fill(0,0,0);
  textSize(32);
  text("Relay 1 OFF: Press 1", width / 2, 50);
  text("Relay 1 ON: Press 2", width / 2, 100);
  text("Relay 2 OFF: Press 3", width / 2, 150);
  text("Relay 2 ON: Press 4", width / 2, 200);
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



