#include <SPI.h>

const int slaveSelectPin = 10;
 
void setup()
{
  Serial.begin(9600);
  pinMode (slaveSelectPin, OUTPUT);
  SPI.begin();
}
 
int level = 0; 
byte incomingByte; 

void loop()
{
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    Serial.println(incomingByte); 
        
    if (incomingByte == 49) { //numbers 1 to 7//
      level = 0;
    } else if (incomingByte == 50) {
      level = 31;
    } else if (incomingByte == 51) {
      level = 63;
    } else if (incomingByte == 52) {
      level = 63 + 31;
    } else if (incomingByte == 53) {
      level = 127;
    } else if (incomingByte == 54) {
      level+=1;
      if (level>=127) level=127;
    } else if (incomingByte == 55) {
      level-=1;
      if (level<=0) level=0;
    }
  }  
  digitalPotWrite(level);
}
 
 
int digitalPotWrite(int value)
{
  digitalWrite(slaveSelectPin, LOW);
  SPI.transfer(0);
  SPI.transfer(value);
  digitalWrite(slaveSelectPin, HIGH);
}

