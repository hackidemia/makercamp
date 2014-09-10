int incomingByte;
const int led = 13;
// 12 for pin 6
const int switch1 = 6;     // the number of the pushbutton pin
// 34 for pin 4
const int switch2 = 4;     // the number of the pushbutton pin
int rumbleTime = 50;
boolean rumbleOn = false;

void setup() {
  pinMode(led, OUTPUT);
  pinMode(switch1, OUTPUT);     
  pinMode(switch2, OUTPUT);     
  Serial.begin(9600);
}

void loop() {  
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
        
    if (incomingByte == 1) {
      digitalWrite(led, HIGH);
      digitalWrite(switch1, HIGH);
    } else if (incomingByte == 2) {
      digitalWrite(led, LOW);
      digitalWrite(switch1, LOW);
    } else if (incomingByte == 3) {
      digitalWrite(led, HIGH);
      digitalWrite(switch2, HIGH);      
    } else if (incomingByte == 4) {
      digitalWrite(led, LOW);
      digitalWrite(switch2, LOW);      
    } else if (incomingByte == 5) {
      rumbleOn = true;
    } else if (incomingByte == 6) {
      rumbleOn = false;
    } else if (incomingByte == 7) {
      rumbleTime = 50;
    } else if (incomingByte == 8) {
      rumbleTime = 100;
    } else if (incomingByte == 9) {
      rumbleTime = 200;
    }
  }
  
  if (rumbleOn) {
    digitalWrite(led, HIGH);
    digitalWrite(switch1, HIGH);
    delay(rumbleTime);
    digitalWrite(led, LOW);
    digitalWrite(switch1, LOW);
    digitalWrite(switch2, HIGH);      
    delay(rumbleTime);      
    digitalWrite(switch2, LOW);  
  }
}
