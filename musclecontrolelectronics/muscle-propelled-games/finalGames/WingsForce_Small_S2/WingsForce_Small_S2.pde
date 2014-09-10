import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.net.*;
import ketai.ui.*;

import controlP5.*;

import java.io.IOException;
import java.lang.reflect.Method;
//for steady vibration
import android.content.Context;
import android.os.Vibrator;
//for pattern vibrations
import android.app.Notification;
import android.app.NotificationManager;

boolean hasStarted = false; // to prevent ControlP5 click event on start
boolean gaming = false;

float scaleFactor = 0.75;

// Bluetooth stuff
KetaiBluetooth bt;
KetaiList klist;
String deviceName; // JY-MCU linvor
ArrayList devices = new ArrayList<String>();
String info = "";
ControlP5 cp5;

// Setup vibration globals:
Vibrator v = null; //steady, below is patterns
NotificationManager gNotificationManager;
Notification vibrateLeft, vibrateRight;
long[] vLeft = {0,250,50};
long[] vRight = {0,50,250};
boolean vOn = true;
boolean enableVibration = false;
boolean isConfiguring = true;

boolean relay1 = false;
boolean relay2 = false;
PFont f1;
PFont f2;
String error;
byte valor;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

final int x = 0;
final int y = 1;
final int z = 2;

//wind
boolean wind = false;
int previousWind = 0;
int windtime = 5000;
int windduration = 2000;
boolean windLeft = false;
int windForce = 10;

int previous = 0;
int cloudtime = 3000; //millis for cloud spawn
boolean cloudrunning = false;
int cloudX = 1280;
int cloudY = 300;
int cloudspeed = 10;

Cloud[] clouds;
int cloudMAX = 40;
int health = 10;
int bonus = 0;
boolean victory = false;
boolean lost = false;
int win = 5;
int life = 10;
float W = 800; //size of X screen //changed
float mA = 90; // max angle that plane turns
PShape plane,cloud,cloud2_white,clouds_white,cloudz2_white,cloudz2_black,cloud2_black, windshapeLeft,windshapeRight;

//Build a container to hold the current rotation of the box
float boxRotation = 0;
  
float boxX = width*scaleFactor; //changed to half
float boxY = height*scaleFactor; //changed to half

//scale factor for the speed of the sprite motion
int move = 1;

AccelerometerManager accel;
float ax, ay, az;

//ramp-speed - play with this value until satisfied
float kFilteringFactor = 0.35f;

//last result storage - keep definition outside of this function, eg. in wrapping object
float[] accelD  = new float[3]; 

float[] currentAccel = new float[3];
float[] finalA = new float[3];

int indexCloud = 0;

void setup() {
  //size(640, 360);
  //size(1280, 720); //changed
  size(800, 600); //changed
  displayOptions();
  clouds = new Cloud[cloudMAX];  
  f1 = createFont("Arial",10,true);//changed half
  f2 = createFont("Arial",7,true);//changed half

  int index = 0;
  for (int y = 0; y < cloudMAX; y++) {
    boolean dir = false;
    int type = int(random(1,7.99));
    if (int(random(1,2.99))==1) dir = true;
    clouds[y++] = new Cloud(type,dir,(int)(10+random(0,30)));
  }
  
  //smooth();
  accel = new AccelerometerManager(this);
  //orientation(PORTRAIT);
  orientation(LANDSCAPE);
  plane = loadShape("biplane.svg");
  //cloudz2_white = loadShape("cloudz2_white.svg");
  //cloud2_white = loadShape("cloud2_white.svg");
  //cloud2_black = loadShape("cloud2_black.svg"); 
  //cloudz2_black = loadShape("cloudz2_black.svg"); 
  windshapeRight = loadShape("Wind-turbine-icon.svg"); 
  windshapeLeft = loadShape("windleft.svg");   
  smooth();
  fill(255);
  stroke(255);
  rectMode(CENTER);
  boxX = width*scaleFactor; //changed half
  boxY = height*scaleFactor; //changed half
  
  //vibrate steady
  v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
  //below is patterns
  gNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
  vibrateLeft = new Notification();
  vibrateRight = new Notification();
  vibrateLeft.vibrate = vLeft;
  vibrateRight.vibrate = vRight;
}

void draw() {
  if (!gaming)    {
    background(190, 190, 190);
    hasStarted = true;
    textSize(30/2);
    devices = bt.getDiscoveredDeviceNames();
    info = "Discovered Devices:\n";
    for (int i=0; i < devices.size(); i++) {
      info += "["+i+"] "+devices.get(i).toString() + "\n";
    }
    text("Click to Connect:", 100, 150);
    text("Enable Vibration: " + enableVibration, 100, 250);
    text(info, 50, 350);
  } else {
    currentAccel[x] = ax; 
    currentAccel[y] = ay; 
    currentAccel[z] = az; 
    //currentAccel = filterAccel(ax,ay,az); //filterData
    
    //background color
    if(boxX > width || boxX < 0 || boxY > height || boxY < 0)
      background(255,0,0);
    else
      background(204,255,255);
    //else {
  //    background(mouseY * (255.0/800), 100, 0);
      //background((int)distance(width/2,height/2,boxX,boxY), 10 , 255);
    //}
  
    float motion = (currentAccel[x]-10);  
  
    //deal with Plane Rotation  
      //dependent on touch (debug)
        //boxRotation += (float) (pmouseX - mouseX)/100; 
      //dependent on X position
        //boxRotation = radians(((boxX-(W/2))/(W/2))*mA);
        //println((float)((boxX-(W/2))/(W/2))*mA);
      //dependent on AccelX + Y
        boxRotation = radians((float)motion * ((currentAccel[y])*-1));  
        //println((float)motion * ((currentAccel[y])*-1));
    
    //deal with Plane position
    if ( (abs(motion)) > 0.5)
    boxX += motion * ((currentAccel[y])*-1);
    //boxX += (currentAccel[x])*-1;
    //boxY += currentAccel[y];
    boxY = mouseY; //500;
  
  
    if (millis() > previous + cloudtime)
    {
      //println("timeout");
      previous = millis();
      if (indexCloud != cloudMAX){
        //clouds[indexCloud++] = new Cloud(type,dir,(int)(10+random(0,10)));
        //clouds[indexCloud++] = new Cloud(1,true,10);
        indexCloud++;
        //println("spawned cloud" + indexCloud + "of " + cloudMAX);
        cloudtime = int(random(500, 4000/indexCloud/2));
      }
      
    }
    
    if (millis() > previousWind + windtime)
    {
      wind = true;
      previousWind = millis();  
      //println("ONE WIND");  
      if (int(random(1,2.99))==1) windLeft = false;
      else windLeft = true;
      windtime = int(random (5000,7000));
      windduration = int(random(1000,4000));
      windForce = int(random(10,30));
      if (enableVibration) {
        v.vibrate(windduration);      
      }
    }
    
      //wind renderer------------------------------
    if (wind && millis() + 200 < previousWind + windduration) 
    {
       pushMatrix();
       if (windLeft){
         //if (windLeft) 
         if (vOn) 
         {
//           gNotificationManager.notify(-1, vibrateLeft);
           vOn = false; 
         }
         else vOn=true;
         
         //translate(0,height/2); //changed
         translate(-20,175); //changed
         //println("render wind left"); 
         shape(windshapeLeft, 0, 0,512*scaleFactor,512*scaleFactor); //changed to half 
       }
       else{
         //else 
         if (vOn) 
         {
//           gNotificationManager.notify(-1, vibrateRight);
           vOn = false; 
         }
         else vOn=true;
         
         //translate(width/2,height/2); //translate(width-100,height); //changed
         translate(300,175); //translate(width-100,height); //changed
         //println("render wind right");  
         shape(windshapeRight, 250, 0,512*scaleFactor,512*scaleFactor); //changed to half 
       }
       popMatrix(); 
    }
    else wind = false;
  
    //Draw Plane------------------------------
    pushMatrix();
    if (windLeft && wind)
    {
      try
      {
        if (!relay2) {
          byte[] data = {1};
          bt.broadcast(data); //read 1, RELAY 2 ON 
          relay2 = true;
        }
      }
      catch(Exception ex)
      {
        error = ex.toString();
        println(error);
      }
      boxX+=windForce;
      translate(boxX*move, boxY*move);
      rotate(boxRotation);
    }
    else if (!windLeft&& wind)
    {
      try
      {
        if (!relay1) {
          byte[] data = {3};
          bt.broadcast(data); //read 3, RELAY 1 ON  
          relay1 = true;
        }
      }
      catch(Exception ex)
      {
        error = ex.toString();
        println(error);
      }
      boxX-=windForce;
      translate(boxX*move, boxY*move);
      rotate(boxRotation);    
    }
    else if (!wind) {
      try
      {
        if (relay1)  {
          byte[] data = {4};
          bt.broadcast(data); //read 4, RELAY 1 ON 
          relay1 = false;
        }
        if (relay2)  {
          byte[] data = {2};
          bt.broadcast(data); //read 2, RELAY 2 ON 
          relay2 = false;
        }
      }
      catch(Exception ex)
      {
        error = ex.toString();
        println(error);
      }
      translate(boxX*move, boxY*move);
      rotate(boxRotation);
    }
      
    //rect(0,0, 150, 150); //debug rect rectangle box
    //shape(plane, -230, -75, 460*scaleFactor, 150*scaleFactor);  //changed to half
    shape(plane, -175, -75, 460*scaleFactor, 150*scaleFactor);  //changed to half , and now hacked it
    popMatrix();
  
    //cloud renderer------------------------------
    for(int it = 0;it<indexCloud;it++){
     if (clouds[it] != null) {
       
       if (clouds[it].isDrawn == false)
       {
         clouds[it]=null;
         continue;
       }
       
       //println("will run for cloud" + it + "of " + cloudMAX);
       clouds[it].update();
       pushMatrix();
       //println(clouds[it].posX + "-" + clouds[it].speed);
       translate(clouds[it].posX, clouds[it].posY);
       clouds[it].draw();
       popMatrix(); 
       //println("updated cloud" + it + "of " + cloudMAX);
     }
    }
    //cloud spawn at beggining
    
    //cloud killer
    
    //cloud must be static
    
    /*pushMatrix();
      cloudX = (cloudX - 1*cloudspeed);
      translate(cloudX, cloudY);
      //rect(0,0, 150, 150);
      shape(cloud2_white, -185, -80, 370, 190);   
    popMatrix();*/
    if (true){
      pushMatrix();
      //fill(255);
      stroke(255);
      textSize(70/2); //changed to half
      textAlign(CENTER, CENTER);
      translate(width/2, height/4);//?
      if(boxX > width || boxX < 0 || boxY > height || boxY < 0)
      {
        //text("Flew away",0, 0, width, height);//?
        //lost = true;
      }
      else 
      {
        //text("Flew away",0, 0, width, height);
        //lost = false;
      }
  
      /*else {text("x: " + nf(currentAccel[x], 1, 2) + "\n" + 
           "y: " + nf(currentAccel[y], 1, 2) + "\n" + 
           "z: " + nf(currentAccel[z], 1, 2), 
           0, 0, width, height);
      }*/
      
      if (bonus >= win & !lost)
      {
        text("Victory!",0, 0, width, height);
        victory = true;
      }
      else if (health <=0 && !victory || lost)
      {
        text("Plane Damaged!",0, 0, width, height);
        lost = true;
      }
      stroke(0,204,51);
      fill(0,204,51);
      text("Goal:" + bonus + "/" + win, -width/2+75, -100, 400, 400);// changed
      //text("Goal:" + bonus + "/" + win, -width/2+175, -100, 400, 400);// orginal
      stroke(255,153,0);
      fill(255,153,0);
      //text("Life:" + health + "/" + life ,-width/2+175, -75, 400, 400);//original
      text("Life:" + health + "/" + life ,-width/2+88, -60, 400, 400);//changed
      popMatrix();
    }
    
    if (deviceName == "") {
      textSize(40);//?
      fill(255, 0, 0);
      text("NO BLUETOOTH CONNECTION", 300, 200);
    }   
  }   
}

public void resume() {
  if (accel != null) {
    accel.resume();
  }
}

    
public void pause() {
  if (accel != null) {
    accel.pause();
  }
}


public void shakeEvent(float force) {
  println("shake : " + force);
}


public void accelerationEvent(float x, float y, float z) {
//  println("acceleration: " + x + ", " + y + ", " + z);
  ax = x;
  ay = y;
  az = z;
  redraw();
}

float[] filterAccel(float xA, float yA, float zA){

//acceleration.x,.y,.z is the input from the sensor
//result.x,.y,.z is the filtered result

//high-pass filter to eleminate gravity
accelD[x] = xA * kFilteringFactor + accelD[x] * (1.0f - kFilteringFactor);
accelD[y] = yA * kFilteringFactor + accelD[y] * (1.0f - kFilteringFactor);
accelD[z] = zA * kFilteringFactor + accelD[z] * (1.0f - kFilteringFactor);

finalA[x] = xA - accelD[x];
finalA[y] = yA - accelD[y];
finalA[z] = zA - accelD[z];

return finalA;
}

public boolean surfaceTouchEvent(MotionEvent event) {
    // if you want the variables for motionX/motionY, mouseX/mouseY etc.
    // to work properly, you'll need to call super.surfaceTouchEvent().
    return super.surfaceTouchEvent(event);
}

float distance(float px1, float py1, float px2, float py2){
 return sqrt(pow((px1-px2),2)+ pow((py1-py2),2));
}

