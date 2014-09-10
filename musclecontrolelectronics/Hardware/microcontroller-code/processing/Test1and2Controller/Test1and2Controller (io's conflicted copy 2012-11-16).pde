import oscP5.*;
import netP5.*;
import processing.opengl.*;
import processing.serial.*;
Serial port;

//CONFIGURATION
boolean ACTUATION=true; //if USB connection data is sent or not
boolean test=false; //plays the test by loading pre-randomized data
boolean intro=false; //plays the introductory stimulation patterns
boolean goingup=false; //plays an incremental 50ms-1s (10 steps) for flexor and then extender, first 3 intensity and then 4 intensity
boolean rumble=false; //plays rumble

//data
ArrayList sensorData;
ArrayList columnOne;

//communications
OscP5 oscP5;
NetAddress myRemoteLocation;

//waiting times and variables
int safety = 0; //milliseconds were we still collect data after stimulation has been shut off. 
int userID=0; //0 means something went wrong, or somebody forgot anything
boolean skip=true;
int timestart = 0;
int curEvtDur = 0;


void setup()
{
  oscP5 = new OscP5(this,7700);
  println(Serial.list());
  if (ACTUATION) port = new Serial(this, Serial.list()[4], 9600);

  //read file
  sensorData=new ArrayList();
  columnOne=new ArrayList();
  //readData("C:/Users/pedro.lopes/Desktop/userstudy/proxy/10_3.txt");
  myRemoteLocation = new NetAddress("127.0.0.1",9000);
}

void readData(String myFileName){
  File file=new File(myFileName);
  //StringBuffer contents = new StringBuffer(); 
  BufferedReader br=null;
  
  try{
    br=new BufferedReader(new FileReader(file));
    String text=null;
    
    while((text=br.readLine())!=null){
      String [] subtext = splitTokens(text,",");
      columnOne.add(int(subtext[0]));
      sensorData.add(text);
    }
  }catch(FileNotFoundException e){
    e.printStackTrace();
  }catch(IOException e){
    e.printStackTrace();
  }finally{
    try {
      if (br != null){
        br.close();
      }
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  for (int i=0; i<sensorData.size(); i++){
    print(columnOne.get(i) + ".....");
    println(sensorData.get(i));
  }
  
}

void draw()
{
  
  //if (timestart + curEvtDur > millis())
  //{
    //wait for key
  //  println("wait for key" + millis());
  //}
 // else 
  //{
  if (intro){
    newEvent(1,300,1,3);
    endEvent(1);
    newEvent(2,500,1,3);
        endEvent(2);
    newEvent(3,700,1,3);
        endEvent(3);
    newEvent(4,500,1,3);
        endEvent(1);
    newEvent(5,700,1,3);
        endEvent(1);
    newEvent(6,300,2,3);
        endEvent(1);
    newEvent(7,500,2,3);
        endEvent(1);
    newEvent(8,700,2,3);
        endEvent(1);
    newEvent(9,500,2,3);
        endEvent(1);
    newEvent(10,700,2,3);
        endEvent(1);
    intro = false;
  }
  
 if (goingup){ 
  
  start(userID);
  newTrial(1);
    newEvent(1,50,1,3);
        endEvent(1);
    newEvent(2,100,1,3);
        endEvent(1);
    newEvent(3,200,1,3);
        endEvent(1);
    newEvent(4,300,1,3);
        endEvent(1);
    newEvent(5,400,1,3);
        endEvent(1);
    newEvent(6,500,1,3);
        endEvent(1);
    newEvent(7,600,1,3);
        endEvent(1);
    newEvent(8,700,1,3);
        endEvent(1);
    newEvent(9,800,1,3);
        endEvent(1);
    newEvent(10,900,1,3); 
        endEvent(1);
    newEvent(11,1000,1,3); 
        endEvent(1);
  endTrial(1);
  newTrial(2);
    newEvent(1,50,2,3);
        endEvent(1);
    newEvent(2,100,2,3);
        endEvent(1);
    newEvent(3,200,2,3);
        endEvent(1);
    newEvent(4,300,2,3);
        endEvent(1);
    newEvent(5,400,2,3);
        endEvent(1);
    newEvent(6,500,2,3);
        endEvent(1);
    newEvent(7,600,2,3);
        endEvent(1);
    newEvent(8,700,2,3);
        endEvent(1);
    newEvent(9,800,2,3);
        endEvent(1);
    newEvent(10,900,2,3); 
        endEvent(1);
    newEvent(11,1000,2,3); 
        endEvent(1);
  endTrial(2);
  delay(5000);
  newTrial(3);
    newEvent(1,50,1,4);
        endEvent(1);
    newEvent(2,100,1,4);
        endEvent(1);
    newEvent(3,200,1,4);
        endEvent(1);
    newEvent(4,300,1,4);
        endEvent(1);
    newEvent(5,400,1,4);
        endEvent(1);
    newEvent(6,500,1,4);
        endEvent(1);
    newEvent(7,600,1,4);
        endEvent(1);
    newEvent(8,700,1,4);
        endEvent(1);
    newEvent(9,800,1,4);
        endEvent(1);
    newEvent(10,900,1,4); 
        endEvent(1);
    newEvent(11,1000,1,4); 
        endEvent(1);
  endTrial(3);
  newTrial(4);
    newEvent(1,50,2,4);
        endEvent(1);
    newEvent(2,100,2,4);
        endEvent(1);
    newEvent(3,200,2,4);
        endEvent(1);
    newEvent(4,300,2,4);
        endEvent(1);
    newEvent(5,400,2,4);
        endEvent(1);
    newEvent(6,500,2,4);
        endEvent(1);
    newEvent(7,600,2,4);
        endEvent(1);
    newEvent(8,700,2,4);
        endEvent(1);
    newEvent(9,800,2,4);
        endEvent(1);
    newEvent(10,900,2,4); 
        endEvent(1);
    newEvent(11,1000,2,4); 
        endEvent(1);
  endTrial(4); 
  stop(userID);  
  goingup = false; 
 }
 
 if (rumble)
 {
   int rumblespeed = 35;
   int rumbler = 40;
   for (int i=0;i<rumbler;i++)
   {
   newEventNoMessage(i,rumblespeed,3,3); 
   endEventNoWaitNoMessage(i);
   }
  
     rumble = false; 
 }
  
 if (test){
  //wait for the second.
  //get next data
  //execute it
  //loop

  start(userID);
  newTrial(1);
  
//  readData("C:/Users/pedro.lopes/Desktop/userstudy/proxy/10_3.txt");
  String filename = "C:/Users/pedro.lopes/Desktop/userstudy/proxy/notouch/" + userID + "_1_2.txt";
  readData(filename);
  
  for (int i=0; i<sensorData.size(); i++){
    String in = (String)sensorData.get(i);
    StringTokenizer st = new StringTokenizer(in, ","); 
    newEvent(i,Integer.parseInt(st.nextToken()),Integer.parseInt(st.nextToken()),Integer.parseInt(st.nextToken())); 
    println(in);
    endEvent(i);
  }  
  
  endTrial(1);
  test = false;
 }
 //}
}

void haptics(int dir)
{
  println("haptics turn " + dir); 
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void newTrial(int val)
{
  println("trial " + val); 
  OscMessage myMessage = new OscMessage("/trial");
  myMessage.add(val); 
  oscP5.send(myMessage, myRemoteLocation); 
}

void endTrial(int val)
{
  println("endtrial " + val); 
  OscMessage myMessage = new OscMessage("/endtrial");
  myMessage.add(val); 
  oscP5.send(myMessage, myRemoteLocation); 
}

void newEvent(int evtNum,int evtDur,int flexORext,int intensity)
{
  println("event " + evtNum + " time " + evtDur + " type " + flexORext + " with intensity " +intensity); 
  OscMessage myMessage = new OscMessage("/event");
  myMessage.add(evtNum); 
  myMessage.add(evtDur); 
  myMessage.add(flexORext); 
  myMessage.add(intensity);   
  oscP5.send(myMessage, myRemoteLocation); 
  
  if (flexORext == 1)
  {
  if (ACTUATION) port.write("^" + "1" + "$");     
  if (ACTUATION) port.write("^" + "2" + "$"); 
  }
  else 
  {
  //if (ACTUATION) port.write("^" + "3" + "$");  
  if (ACTUATION) port.write("^" + "4" + "$");    
  }
  
   
  
  
  //timestart=millis();
  //curEvtDur = evtDur+safety;
  delay(evtDur);

}

void newEventNoMessage(int evtNum,int evtDur,int flexORext,int intensity)
{
  
  if (flexORext == 1)
  {
  if (ACTUATION) port.write("^" + "1" + "$");     
  if (ACTUATION) port.write("^" + "2" + "$"); 
  }
  else if (flexORext == 2)
  {
  //if (ACTUATION) port.write("^" + "3" + "$");  
  if (ACTUATION) port.write("^" + "4" + "$");    
  }
  else if (flexORext == 3)
  {
  if (ACTUATION) port.write("^" + "1" + "$");     
  if (ACTUATION) port.write("^" + "2" + "$"); 
  if (ACTUATION) port.write("^" + "4" + "$");    
  }
  delay(evtDur);
}

void endEventNoWaitNoMessage(int val)
{
  if (ACTUATION) port.write("^" + "1" + "$");     
  if (ACTUATION) port.write("^" + "3" + "$");     
}

void endEvent(int val)
{
  if (ACTUATION) port.write("^" + "1" + "$");     
  if (ACTUATION) port.write("^" + "3" + "$");     
  println("endevent " + val); 
  OscMessage myMessage = new OscMessage("/endevent");
  myMessage.add(val); 
  oscP5.send(myMessage, myRemoteLocation); 
  
  //wait for keypress and then random wait
  delay(int(random(3000,6000)));
  //timestart=millis();
  //curEvtDur = int(random(1000,4000))+safety;
}

void user(int val)
{
  println("userID " + val); 
  OscMessage myMessage = new OscMessage("/user");
  myMessage.add(val); 
  oscP5.send(myMessage, myRemoteLocation); 
  userID=val;
}

void start(int val)
{
  println("start " + val); 
  OscMessage myMessage = new OscMessage("/start");
  myMessage.add(val); 
  oscP5.send(myMessage, myRemoteLocation); 
}

void stop(int val)
{
  println("stop " + val); 
  OscMessage myMessage = new OscMessage("/stop");
  myMessage.add(val); 
  oscP5.send(myMessage, myRemoteLocation); 
}

void sendReply(int rep)
{
 println("reply is " + rep);
 OscMessage myMessage = new OscMessage("/reply");
 myMessage.add(rep); 
 oscP5.send(myMessage, myRemoteLocation); 
}

void keyPressed()
{
  //println("KEY" + keycode);
  if (key == CODED) {
    if (keyCode == LEFT) {
      sendReply(LEFT);
    }
    else if (keyCode == RIGHT) {
      sendReply(RIGHT);      
    }
  }
 
 if (key == 'x') 
   stop(userID);
  
  if (key == 'u' && goingup == false) 
  {
   goingup = true;
   println("goingup started");
  }
  else if (key == 'u' && goingup == true) 
  {
   goingup = false;
   println("goingup finished. writedata");
  }
  
   if (key == 'r' && rumble == false) 
  {
   rumble = true;
   println("rumble started");
  }
  else if (key == 'r' && rumble == true) 
  {
   rumble = false;
   println("rumble finished. writedata");
  }
  
  if (key == 'i' && intro == false) 
  {
   intro = true;
   println("intro started");
  }
  else if (key == 'i' && intro == true) 
  {
   intro = false;
   println("intro finished.");
  }
  
  if (key == 't' && test == false) 
  {
   test = true;
   println("test started");
  }
  else if (key == 't' && test == true) 
  {
   test = false;
   println("test finished, write data");
  }
  
  if (key == 'w') 
  {
       haptics(1);
    if (ACTUATION) port.write("^" + "1" + "$");     
    if (ACTUATION) port.write("^" + "3" + "$");     
  }
  else if (key == 's') 
  {
       haptics(1);
     if (ACTUATION) port.write("^" + "4" + "$");        
     if (ACTUATION) port.write("^" + "2" + "$"); 
  } else if (key == 'a') {
       haptics(1);
     if (ACTUATION) port.write("^" + "1" + "$");     
     if (ACTUATION) port.write("^" + "2" + "$"); 
  }
  else if (key == 'd')
  {
       haptics(1);
    //if (ACTUATION) port.write("^" + "3" + "$");     
     if (ACTUATION) port.write("^" + "4" + "$");         
  }
  else if (key == '0')
  {
    user(0);
  }
  else if (key == '1')
  {
    user(1);
  }
  else if (key == '2')
  {
    user(2);
  }
  else if (key == '3')
  {
    user(3);
  }
  else if (key == '4')
  {
    user(4);
  }
  else if (key == '5')
  {
    user(5);
  }
  else if (key == '6')
  {
    user(6);
  }
  else if (key == '6')
  {
    user(6);
  }
  else if (key == '7')
  {
    user(7);
  }
  else if (key == '8')
  {
    user(8);
  }
  else if (key == '9')
  {
    user(9);
  }
}

void keyReleased(){
   if (ACTUATION) port.write("^" + "1" + "$");     
   if (ACTUATION) port.write("^" + "3" + "$");     
}
