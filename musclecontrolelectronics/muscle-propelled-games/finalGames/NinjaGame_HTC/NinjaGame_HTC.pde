import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.net.*;
import ketai.ui.*;

import controlP5.*;

ControlP5 cp5;
KetaiVibrate vibe;
KetaiBluetooth bt;
KetaiList klist;
String deviceName = "JY-MCU"; // JY-MCU linvor
ArrayList devices = new ArrayList<String>();
boolean hasStarted = false;
boolean isConfiguring = true;
String info = "";

int hits, maxDistance, time;
boolean isClose;
boolean btIsOff = false;
byte[] btOn = {1};
byte[] btOff = {2};

PImage bg;
Ninja myNinja;
Finger myFinger;
int[] distance = {0, 0};
int retriggerTime = 2000;
float lastKill = 0;
float lastHit = 0;
boolean showSword = false;
float appStart = 0;
int timeout = 10000;
boolean enableVibration = false;

void setup() {
  //  size(1200, 800); // displayWidth, displayHeight
  orientation(LANDSCAPE); 
  bluetoothStart();
  maxDistance = 200;
  myNinja = new Ninja(maxDistance);
  myFinger = new Finger(maxDistance);
  bg = loadImage("bg.png");
  hits = 0;
  isClose = false;
  vibe = new KetaiVibrate(this);
}

// most stuff happens in the ninja class

void draw() {
  if (isConfiguring) {
    hasStarted = true;
    background(190, 190, 190);
    textSize(30);
    devices = bt.getDiscoveredDeviceNames();
    info = "Discovered Devices:\n";
    for (int i=0; i < devices.size(); i++) {
      info += "["+i+"] "+devices.get(i).toString() + "\n";
    }
    text("Click to Connect:", 100, 150);
    text("Enable Vibration: " + enableVibration, 100, 250);
    text(info, 50, 350);
  } else {
    background(255, 255, 255);
    image(bg, 0, 0);
    
    if ((lastKill + retriggerTime) < millis()) {
      myNinja.display();
    } else {
      textSize(100);
      text("Ninja got killed", width/4, height/2);  
    }
    if (showSword) {
      myFinger.display();
    }
  
    textSize(40);
  
    if (deviceName == "") {
      fill(255, 0, 0);
      text("NO BLUETOOTH CONNECTION", 10, 100);
    }   
    
    fill(0, 0, 0);
    text("Hits: " + hits, 10, 50);
    text("Time: " + (millis()-time)/1000, width-200, 50);
    text("Life: ", 200, 50);
    rect(300, 25, width/2, 25);
    fill(255, 0, 0);
    rect(300, 25, int((width/2)*(myNinja.life/100.0)), 25);
    fill(0, 0, 0);
  }
}

void mouseReleased() {
  showSword = false;
}

void mouseClicked() {
  showSword = false;
}

void mousePressed() {
  if (isConfiguring) {
    //
  } else {
  showSword = true;
    if (mouseX > width/4*3 && mouseY < height/4) {
      print("RESET");
      time = millis();
      hits = 0;
    }  
  }
}