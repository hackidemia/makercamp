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
String deviceName; // JY-MCU linvor
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
int maxHits = 5;

void setup() {
  //  size(1200, 800); // displayWidth, displayHeight
  orientation(LANDSCAPE); 
  displayOptions();
  maxDistance = 150;
  myNinja = new Ninja(maxDistance);
  myFinger = new Finger(maxDistance);
  bg = loadImage("bg.png");
  hits = 0;
  isClose = false;
  vibe = new KetaiVibrate(this);
}

// most stuff happens in the ninja class

void draw() {
  hasStarted = true;
  if (isConfiguring) {
    background(190, 190, 190);
    textSize(30);
    devices = bt.getDiscoveredDeviceNames();
    info = "Discovered Devices:\n";
    for (int i=0; i < devices.size(); i++) {
      info += "["+i+"] "+devices.get(i).toString() + "\n";
    }
    text("Click to Connect:", 50, 150);
    text("Enable Vibration: " + enableVibration, 50, 250);
    text(info, 50, 350);
  } else {
    background(255, 255, 255);
    image(bg, 0, 0);
    
    if (hits >= maxHits) {
      textAlign(CENTER);
      textSize(60);
      text("YOU WON!", width/2, height/3);
      textSize(30);
      text("Click to start over", width/2, height/2);
    } else {
      textAlign(LEFT);
      if ((lastKill + retriggerTime) < millis() || hits == 0) {
        myNinja.display();
      } else {
        textSize(50);
        text("Ninja got killed", width/4, height/2);  
      }
      if (showSword) {
        myFinger.display();
      }
    
      textSize(30);
    
      if (deviceName == "") {
        fill(255, 0, 0);
        text("NO BLUETOOTH CONNECTION", 10, 100);
      }   
      
      fill(0, 0, 0);
      text("Hits: " + hits, 20, 50);
      text("Time: " + (millis()-time)/1000, width-140, 50);
      text("Life: ", 140, 50);
      rect(210, 28, width/2, 25);
      fill(255, 0, 0);
      rect(210, 28, int((width/2)*(myNinja.life/100.0)), 25);
      fill(0, 0, 0); 
    }
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
    if (hits >= maxHits) {
      hits = 0;
      time = millis();
    } else {
      showSword = true;
      if (mouseX > width/4*3 && mouseY < height/4) {
        print("RESET");
        time = millis();
        hits = 0;
      }  
    }
  }
}
