
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
  receive = Arrays.toString(data);
  println("RECEIVED: " + receive);
}

void onStart() {
  super.onStart();
  print("START BLUETOOTH");
  bt.start();
  print("Bluetooth started: " + bt.isStarted());
  print("SEARCH FOR DEVICES");
  bt.discoverDevices();
}

void onStop() {
  super.onStop();
  byte[] btOff = {6};
  bt.broadcast(btOff);
}

void bluetoothStart() {
  boolean deviceFound = false;

  print("WAITING");
  while(!deviceFound) {
    devices = bt.getDiscoveredDeviceNames();
    deviceFound = devices.contains(deviceName);
  }
  print("FOUND DEVICES: " + devices);

  print("Connect to device: " + deviceName);
  bt.connectToDeviceByName(deviceName);
  isConfiguring = false;
}

