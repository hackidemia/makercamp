import android.bluetooth.*;
import android.content.Intent;

BluetoothAdapter mBluetoothAdapter;
BluetoothDevice device;
BluetoothSocket socket;
InputStream ins;
OutputStream ons;

private static final int REQUEST_ENABLE_BT = 3;
ArrayList<BluetoothDevice> pairedDevices = new ArrayList<BluetoothDevice>();
String status = "";

void onStart()
{
  super.onStart();
  println("onStart");
  mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
  
  Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
  startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
  
  while(!mBluetoothAdapter.isEnabled()) {
    delay(500);
  }
  
  if(mBluetoothAdapter != null) {
    if (mBluetoothAdapter.isEnabled()) {
      String mydeviceaddress = mBluetoothAdapter.getAddress();
      String mydevicename = mBluetoothAdapter.getName();
      status = mydevicename + " : " + mydeviceaddress;
    }
    else {
      enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
      startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
    }
  }
  for (BluetoothDevice pairedDevice : mBluetoothAdapter.getBondedDevices()) {
      pairedDevices.add(pairedDevice);
  }

  if (pairedDevices.size() > 0) {
    println(pairedDevices.size());
    device = pairedDevices.get(0);
    UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb"); //Standard //SerialPortService ID
    socket = mmDevice.createRfcommSocketToServiceRecord(uuid);        
    socket.connect();
    ons = socket.getOutputStream();
    ins = socket.getInputStream();
  }
}

void setup() {
  
}

void draw() {
  textSize(30);
  text("Status: " + status, 10, 50);
  text("Device: " + device.getName() + ":" + device.getAddress(), 10, 150);  
}
