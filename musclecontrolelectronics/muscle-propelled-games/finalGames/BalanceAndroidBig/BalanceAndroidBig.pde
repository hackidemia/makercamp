import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.net.*;
import ketai.ui.*;
import ketai.sensors.*;

import controlP5.*;

import oscP5.*;
import netP5.*;

ControlP5 cp5;
KetaiBluetooth bt;
KetaiList klist;
String deviceName;// JY-MCU linvor
boolean deviceFound = false;
ArrayList devices = new ArrayList<String>();
boolean hasStarted = false;
boolean isConfiguring = true;
String info = "";

OscP5 oscP5;
KetaiSensor sensor;
KetaiVibrate vibe;

boolean btIsOff = true;
byte[] btOn = {1};
byte[] btOff = {2};
float appStart = 0;
int timeout = 10000;
boolean enableVibration = false;
        
NetAddress remoteLocation;
float x, y, remoteX, remoteY;
float myAccelerometerX, myAccelerometerY, rAccelerometerX, rAccelerometerY;
int targetX, targetY, remoteTargetX, remoteTargetY;
int score, remoteScore;
float speedX, speedY = .01;
int playerID;
Marble myMarble, remoteMarble;
Target myTarget, remoteTarget;
Powerup power;
boolean powerupCollected = false;
boolean feedbackActive = false;
boolean gameReady = false;
float retriggerTime = 5000;
float collectionTime = 0;
float feedbackStart = 0;
int feedbackTime = 1000;
int currentFeedbackTime = 0;
int resetTime = 0;
int size = 48;
boolean hasLost = false;
int maxPoints = 20;

String remoteAddress = "255.255.255.255";  //Customize!
//String remoteAddress = "192.168.0.0";  //Customize!

void setup() {
  sensor = new KetaiSensor(this);
  orientation(PORTRAIT);
  size(768, 1280);
  displayOptions();
  initNetworkConnection();
  // Android sensors
  sensor.start();
  vibe = new KetaiVibrate(this);
  strokeWeight(5);  
  imageMode(CENTER);
  playerID = 0;
}

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
    text("Click to Connect:", 50, 150);
    text("Enable Vibration: " + enableVibration, 50, 250);
    text("Player ID: " + (2-playerID), 50, 350);
    text(info, 50, 450);
  } else {
    background(200, 200, 200);
    textAlign(CENTER, CENTER);
    
    if (myTarget.score >= maxPoints || hasLost) { 
      if (!hasLost) sendGameOver();
      textSize(60);
      if (hasLost) {
        text("YOU LOST!", width/2, height/3);        
      } else {
        text("YOU WON!", width/2, height/3);
      }
      textSize(30);
      text("Click to start over", width/2, height/2);
    } else {
      if (deviceName == "") {
        textSize(30);
        fill(255, 0, 0);
        text("NO BLUETOOTH CONNECTION", width/2, height/2);
      }   
    
      sendUpdate();
      // show targets
      myTarget.display(targetX, targetY);
      remoteTarget.display(remoteTargetX, remoteTargetY);
      // show powerup
      if (!powerupCollected || (collectionTime + retriggerTime) < millis()) {
        powerupCollected = false;
          power.display();
      }
      // show marbles
      remoteMarble.display(remoteX, remoteY);
      // calculate speed and position
      speedX += (myAccelerometerX) * 0.1;
      speedY += (myAccelerometerY) * 0.1;
      if (x <= size+speedX || x > width-size+speedX) {
        speedX *= -0.8;
      }
      if (y <= size-speedY || y > height-size-speedY) {
        speedY *= -0.8;
      }
      x -= speedX;
      y += speedY;
    //  if (!feedbackActive) {
      myMarble.display(x, y);
    //  }
      // detect collisions 
      detectCollision();
      // handle feedback
      if (feedbackActive && (feedbackStart + currentFeedbackTime) < millis()) {
        deactivateFeedback();
      }
    }
  }
}

void detectCollision() {
  if (dist(x, y, targetX, targetY) < 20) {
    myTarget.score++;
    background(60, 0, 0);
    resetPlayer();
  }
  if (dist(x, y, power.x, power.y) < power.r && !powerupCollected) {
    println("P" + playerID +": GOT POWERUP");
    myMarble.gotPowerup(power.type);
    power.reset();
    resetPowerup();
    powerupCollected = true;
    collectionTime = millis();
  }
}

// NETWORKING
// OUTGOING
void sendUpdate()
{
  OscMessage myMessage = new OscMessage("remoteData");
  myMessage.add(playerID);
  myMessage.add(x/1.6);
  myMessage.add(y/1.6);
  myMessage.add(myAccelerometerX);
  myMessage.add(myAccelerometerY);
  myMessage.add(int(targetX/1.6));
  myMessage.add(int(targetY/1.6));
  myMessage.add(myTarget.score);
  oscP5.send(myMessage, remoteLocation);
}

void sendPowerup()
{
  OscMessage myMessage = new OscMessage("powerup_used");
  myMessage.add(playerID);
  myMessage.add(myMarble.powerup);
  oscP5.send(myMessage, remoteLocation);
}

void sendGameOver()
{
  OscMessage myMessage = new OscMessage("game_over");
  myMessage.add(playerID);
  oscP5.send(myMessage, remoteLocation);
}

void resetPowerup()
{
  OscMessage myMessage = new OscMessage("powerup_reset");
  myMessage.add(playerID);
  myMessage.add(power.x/1.6);
  myMessage.add(power.y/1.6);
  myMessage.add(power.type); 
  oscP5.send(myMessage, remoteLocation);
}

void sendReset()
{
  OscMessage myMessage = new OscMessage("reset_game");
  myMessage.add(playerID);
  oscP5.send(myMessage, remoteLocation);
}

// NETWORKING
// INCOMING
void oscEvent(OscMessage theOscMessage) {
  //  theOscMessage.print();
  if (theOscMessage.get(0).intValue() != playerID) {
    if (theOscMessage.checkAddrPattern("remoteData")) {
      if (!gameReady) {
        resetPowerup();
        gameReady = true;
      }
      remoteX = theOscMessage.get(1).floatValue() * 1.6; 
      remoteY = theOscMessage.get(2).floatValue() * 1.6;
      rAccelerometerX = theOscMessage.get(3).floatValue();
      rAccelerometerY = theOscMessage.get(4).floatValue();
      remoteTargetX = int(theOscMessage.get(5).intValue() * 1.6);
      remoteTargetY = int(theOscMessage.get(6).intValue() * 1.6);
      remoteScore = theOscMessage.get(7).intValue();
      remoteTarget.score = remoteScore;
    }
    if (theOscMessage.checkAddrPattern("powerup_used")) {
      int type = theOscMessage.get(1).intValue(); 
      println("P" + playerID +": RECEIVED POWERUP TYPE: " + type);
      activateFeedback(type);
    }
    if (theOscMessage.checkAddrPattern("powerup_reset")) {
      powerupCollected = true;
      collectionTime = millis()-50;
      float x = theOscMessage.get(1).floatValue() * 1.6; 
      float y = theOscMessage.get(2).floatValue() * 1.6; 
      int type = theOscMessage.get(3).intValue(); 
      power.set(x, y, type);
    }
    if (theOscMessage.checkAddrPattern("reset_game")) {
      resetGame(true);
    }
    if (theOscMessage.checkAddrPattern("game_over")) {
      hasLost = true;
    }
  }
}

// INITS
void initNetworkConnection()
{
  oscP5 = new OscP5(this, 32000);
  remoteLocation = new NetAddress(remoteAddress, 32000);
}

void initGame() {
  x = width/2;
  y = height/2;
  myMarble = new Marble(x, y, playerID);
  targetX = int(random(size, width-size-10));
  targetY = int(random(size, height-size-10));
  myTarget = new Target(targetX, targetY, playerID);
  remoteX = width-150;
  remoteY = height-150;
  remoteTargetX = 150;
  remoteTargetY = height-200;
  remoteMarble = new Marble(remoteX, remoteY, abs(playerID-1));
  remoteTarget = new Target(remoteTargetX, remoteTargetY, abs(playerID-1));
  power = new Powerup();
}

void resetPlayer() {
  targetX = int(random(size, width-size-10));
  targetY = int(random(size, height-size-10));
  myTarget.x = targetX;
  myTarget.y = targetY;
}

void resetGame(boolean isRemoteReset) {
  myTarget.score = 0;
  hasLost = false;
  myMarble.usedPowerup();
  if (!isRemoteReset) {
    sendReset();
  }
}

// KEY AND MOUSE EVENTS
void mousePressed() {
  if (!isConfiguring) {
    if (myTarget.score >= maxPoints || hasLost) {  
      resetGame(false);
    } else {
      if (mouseX < width/5 && mouseY < height/5) {
        if (resetTime == 0) {
          resetTime = millis();
        } else {
          if (resetTime + 500 > millis()) {
            println("RESET");
            resetGame(false);
          }
          resetTime = 0;  
        }
      } else {
        if (myMarble.powerup >= 0) {
          println("P" + playerID +": USED POWERUP :)");
          sendPowerup();
          sendPowerup();
          sendPowerup();
          myMarble.usedPowerup();
        } 
        else {
          println("P" + playerID +": NO POWERUP :(");
        }
      }
    } 
  }
}

void onAccelerometerEvent(float _x, float _y, float _z){
  myAccelerometerX = _x * 1.6;
  myAccelerometerY = _y * 1.6;
}

