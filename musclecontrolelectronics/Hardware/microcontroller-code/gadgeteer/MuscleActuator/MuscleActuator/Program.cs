using System;
using System.Collections;
using System.Threading;
using System.Text;
using Microsoft.SPOT;
using Microsoft.SPOT.Presentation;
using Microsoft.SPOT.Presentation.Controls;
using Microsoft.SPOT.Presentation.Media;
using Microsoft.SPOT.Touch;

using Gadgeteer.Networking;
using GT = Gadgeteer;
using GTM = Gadgeteer.Modules;

using Gadgeteer.Modules.Seeed;
using Gadgeteer.Modules.Velloso;
using Gadgeteer.Modules.GHIElectronics;
//using Gadgeteer.Modules.GHIElectronics;

namespace MuscleActuator
{
    public partial class Program
    {

        private byte[] StringToByteArray(string str)
        {
            System.Text.UTF8Encoding enc = new System.Text.UTF8Encoding();
            return enc.GetBytes(str);
        }

        private char[] ByteArrayToString(byte[] arr)
        {
            System.Text.UTF8Encoding enc = new System.Text.UTF8Encoding();
            return enc.GetChars(arr);
        }
        
        Bluetooth bluetooth = new Bluetooth(11);
        Bluetooth.Client client;
        const int defaultRumbleTime = 200;
        readonly int[] rumbleTimes = {50, 100, 200};
        GT.Timer rumbleTimer = new GT.Timer(defaultRumbleTime);
        bool connected = false;
        // This method is run when the mainboard is powered up or reset.   
        void ProgramStarted()
        {
            /*******************************************************************************************
            Modules added in the Program.gadgeteer designer view are used by typing 
            their name followed by a period, e.g.  button.  or  camera.
            
            Many modules generate useful events. Type +=<tab><tab> to add a handler to an event, e.g.:
                button.ButtonPressed +=<tab><tab>
            
            If you want to do something periodically, use a GT.Timer and handle its Tick event, e.g.:
                GT.Timer timer = new GT.Timer(1000); // every second (1000ms)
                timer.Tick +=<tab><tab>
                timer.Start();
            *******************************************************************************************/


            // Use Debug.Print to show messages in Visual Studio's "Output" window during debugging.
            Debug.Print("Program Started");

            bluetooth.SetDeviceName("Muscle actuator gadgeteer");
            //bluetooth.SetPinCode("1111");
            bluetooth.DebugPrintEnabled = false;
           
            client = bluetooth.ClientMode;

            pairingButton.ButtonPressed += delegate(Button sender, Button.ButtonState state)
            {
                if (!bluetooth.IsConnected)
                    client.EnterPairingMode();
                else
                    bluetooth.Reset();
            };

            /*disconnectButton.ButtonPressed += delegate(Button sender, Button.ButtonState state)
            {
                client.Disconnect();
            };*/

            bluetooth.BluetoothStateChanged += delegate(Bluetooth sender, Bluetooth.BluetoothState btState)
            {
                //Debug.Print("New state:" + btState.ToString());
                if (btState == Bluetooth.BluetoothState.Connected)
                {
                    client.Send("HELLO");
                } 
            };

            bluetooth.DataReceived += delegate(Bluetooth sender, string data)
            {
                StringBuilder dataBytesString = new StringBuilder();
                //Debug.Print("data-received " + data);
                byte[] dataBytes = StringToByteArray(data);
                foreach (byte b in dataBytes) {
                    dataBytesString.Append(b);
                    dataBytesString.Append(' ');
                }
                Debug.Print("data-received " + dataBytesString);
                if (dataBytes[0] == 1) 
                {
                    relays.Relay1 = true;
                    led.SetRedIntensity(255);
                }
                else if (dataBytes[0] == 2)
                {
                    relays.Relay1 = false;
                    led.SetRedIntensity(0);
                }
                else if (dataBytes[0] == 3)
                {
                    relays.Relay2 = true;
                    led.SetBlueIntensity(255);
                }
                else if (dataBytes[0] == 4)
                {
                    relays.Relay2 = false;
                    led.SetBlueIntensity(0);
                }
                else if (dataBytes[0] == 5)
                { 
                    rumbleTimer.Start();
                }
                else if (dataBytes[0] == 6)
                {
                    relays.Relay1 = false;
                    relays.Relay2 = false;
                    rumbleTimer.Stop();
                    led.TurnOff();
                }
                else if (dataBytes[0] > 6 && dataBytes[0] < 10)
                {
                    rumbleTimer.Interval = new TimeSpan(0, 0, 0, 0, rumbleTimes[dataBytes[0] - 7]);
                }
            };

            rumbleTimer.Tick += delegate(GT.Timer sender)
            {
                if(relays.Relay1 == true){
                    relays.Relay1 = false;
                    relays.Relay2 = true;
                    led.TurnBlue();
                }
                else if (relays.Relay2 == true)
                {
                    relays.Relay2 = false;
                    relays.Relay1 = true;
                    led.TurnRed();
                }
                else 
                {
                    relays.Relay2 = true;
                    led.TurnBlue();
                }
            };
        }
    }
}
