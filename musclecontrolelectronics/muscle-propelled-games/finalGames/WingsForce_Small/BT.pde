// disable volume buttons
@Override
public boolean onKeyDown(int keyCode, KeyEvent event){
    if (keyCode == KeyEvent.KEYCODE_VOLUME_UP){
        return true;
    }
    if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN){
        return true;
    }
    return super.onKeyDown(keyCode, event); 
}

//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data) {
//  receive = Arrays.toString(data);
//  println("RECEIVED: " + receive);
}

void onStart() {
  super.onStart();
  println("Start");
  if (isConfiguring) {
    print("START BLUETOOTH");
    bt.start();
    print("Bluetooth started: " + bt.isStarted());
    print("SEARCH FOR DEVICES");
    bt.discoverDevices();
  }
}

void onStop() {
  super.onStop();
  println("Stop");
  byte[] btOff = {2};
  bt.broadcast(btOff);
  btOff[0] = 4;
  bt.broadcast(btOff);
}

void onPause() {
  super.onPause();
  println("Pause");
  byte[] btOff = {2};
  bt.broadcast(btOff);
  btOff[0] = 4;
  bt.broadcast(btOff);
}

void onResume() {
  super.onResume();
  println("Resume");
  bt.connectToDeviceByName(deviceName);  
}

void onRestart() {
  super.onRestart();
  println("Restart");
}

void bluetoothStart() {
  boolean deviceFound = false;

  klist = new KetaiList(this, bt.getDiscoveredDeviceNames());  
//  print("WAITING");
//  while(!deviceFound) {
//    devices = bt.getDiscoveredDeviceNames();
//    deviceFound = devices.contains(deviceName);
//  }
//  print("FOUND DEVICES: " + devices);
//
//  print("Connect to device: " + deviceName);
//  bt.connectToDeviceByName(deviceName);
}

void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  deviceName = selection;
  println(deviceName);
  bt.connectToDeviceByName(selection);

  //dispose of list for now
  klist = null;
}

void displayOptions() {
  cp5 = new ControlP5(this);
  cp5.addButton("ConnectToDevice")
     .setValueLabel("Connect To Device")
     .setPosition(width/2,80)
     .setSize(width/3,100);
  cp5.addToggle("EnableVibration")
     .setValue(false)
     .setPosition(width/2,200)
     .setSize(width/3,80)
     .setMode(ControlP5.SWITCH);
}

public void ConnectToDevice(int theValue) {
  if (hasStarted) {
    print("Show list");
    klist = new KetaiList(this, bt.getDiscoveredDeviceNames());
    cp5.hide();
    isConfiguring = false;
    gaming = true;
    previous = millis() + 1000;
    previousWind = millis();
  }    
}

public void EnableVibration(boolean theFlag) {
  enableVibration = theFlag;
  println("Vibration " + enableVibration);
}
