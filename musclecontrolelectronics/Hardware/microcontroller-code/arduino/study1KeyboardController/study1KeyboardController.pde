//how to use this controller for study 1 (measuring force)
//start
//1- hit "5" for 5 ms burst (if need to repeat, just hit 5 again)
//2- hit t to advance doubling the ms (100, 200, ..)
  //if you need to repeat, hit "r" and then "t" again to replay that duration
  //stop at 1s

import processing.serial.*;

Serial port;

void setup() {
  size(100, 150);
  noStroke();
  // Select port
  println(Serial.list());
  port = new Serial(this, Serial.list()[4], 9600);
}

int i = 0;
boolean test = false;
boolean test5 = false;

void draw() {
  
  if (test) {
    i++;
    port.write("^" + "2" + "$");
    delay(100*i);
    port.write("^" + "1" + "$");
    println(i+"00ms");
    test=false;

  } else if (test5) {
    port.write("^" + "2" + "$");
    delay(50);
    port.write("^" + "1" + "$");
    println("50ms");
    test5=false; 
  }
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
     else if (key == 't')
    test = true;
    else if (key == '5')
    test5 = true;
    else if (key == 'r')
    i--;
}



