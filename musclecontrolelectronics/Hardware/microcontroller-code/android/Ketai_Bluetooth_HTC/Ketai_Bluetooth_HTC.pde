import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.net.*;
import ketai.ui.*;

import controlP5.*;

ControlP5 cp5;
KetaiList klist;
KetaiBluetooth bt;
String info = "";
String deviceName = "JY-MCU";  // name of device JY-MCU, linvor
ArrayList devices = new ArrayList<String>();
boolean hasStarted = false;
boolean isConfiguring = true;
String receive = "";

void setup()
{
  orientation(PORTRAIT);
  background(78, 93, 75);
  bluetoothStart();
  textSize(30);
}

void draw() {
  background(190, 190, 190);
  hasStarted = true;
  if (isConfiguring) {
    devices = bt.getDiscoveredDeviceNames();
    info = "Discovered Devices:\n";
    for (int i=0; i < devices.size(); i++) {
      info += "["+i+"] "+devices.get(i).toString() + "\n";
    }
    text("Click to Connect:", 50, 150);
    text(info, 50, 300);
  } else {
    displaySwitches();  
  }
}

// simple ON/OFF switch sending two messages
public void mousePressed() {
  if (isConfiguring) {
    //
  } else {
    byte[] btOn = {1};
    if (mouseY < height/4) {
      if (mouseX < width/2) {
        btOn[0] = 1;    
      } else {
        btOn[0] = 2;    
      }
    }
    if (mouseY > height/4 && mouseY < height/2) {
      if (mouseX < width/2) {
        btOn[0] = 3;    
      } else {
        btOn[0] = 4;    
      }
    }
    if (mouseY > height/2 && mouseY < height/4*3) {
      if (mouseX < width/2) {
        btOn[0] = 5;    
      } else {
        btOn[0] = 6;    
      }
    }
    if (mouseY > height/4*3) {
      if (mouseX < width/3) {
        btOn[0] = 7;    
      } else if (mouseX > width/3*2) {
        btOn[0] = 9;    
      } else {
        btOn[0] = 8;            
      }
    }
    print("Send: " + btOn[0]);
    bt.broadcast(btOn);
  }
}

void displaySwitches() {
  fill(0, 255, 0);
  rect(0, 0, width/2, height/4);
  fill(255, 0, 0);
  rect(width/2, 0, width/2, height/4);
  fill(255);
  textSize(60);
  text("Left", width/4, height/6);
  
  fill(0, 100, 0);
  rect(0, height/4, width/2, height/4);
  fill(100, 0, 0);
  rect(width/2, height/4, width/2, height/4);   
  fill(255);
  textSize(60);
  text("Right", width/4, height/3);
  
  fill(0, 180, 0);
  rect(0, height/2, width/2, height/4);
  fill(180, 0, 0);
  rect(width/2, height/2, width/2, height/4);
  fill(255);
  textSize(60);
  text("Rumble", width/4, height/3*2);

  fill(0, 180, 100);
  rect(0, height/4*3, width/3, height/4);
  fill(0, 0, 255);
  rect(width/3, height/4*3, width/3, height/4);
  fill(0, 0, 180);
  rect(width/3*2, height/4*3, width/3, height/4);
  fill(255);
  textSize(40);
  text("50ms", width/10, height/10*9);
  text("100ms", width/5*2, height/10*9);
  text("200ms", width/10*7, height/10*9);

  textSize(30);
  text("Connected to: " + deviceName, 10, 50);
  text("Receive: " + receive, 10, 100);    
}
