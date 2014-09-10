#define START_CHAR '^'
#define END_CHAR '$'
#define SIZE 8

char serialMessage[SIZE];
unsigned int readChar;
unsigned int count;
boolean readingSerial;

void setup() {
  Serial.begin(9600);
  readingSerial = false;
  pinMode(13, OUTPUT);    
  pinMode(12, OUTPUT);   
  pinMode(3, OUTPUT);    
  pinMode(4, OUTPUT); 
  //relays
  pinMode(6, OUTPUT);    
  pinMode(7, OUTPUT); 
  digitalWrite(3, HIGH); 
  digitalWrite(13, HIGH);
}

void loop() {
  if (Serial.available() > 0 && !readingSerial) {
    if (Serial.read() == START_CHAR) {
      serialRead();
    }
  }
}

void serialRead() {
  readingSerial = true;
  count = 0;
  
  iniReading:
  if (Serial.available() > 0) {
    readChar = Serial.read();
    if (readChar == END_CHAR || count == SIZE) {
      goto endReading;
    } else {
      serialMessage[count++] = readChar;
      goto iniReading;
    }
  }
  goto iniReading;
  
  endReading:
  readingSerial = false;
  serialMessage[count] = '\0';
  
  setRelay(serialMessage);
}

void setRelay(char* value)
{
  int a = atoi(value); 
  //Serial.println(value);
  //Serial.println(a);
  if (a == 1) {
    digitalWrite(6, LOW);
    digitalWrite(13, HIGH); 
    digitalWrite(12, LOW);  

  } else   if (a == 2) {
    digitalWrite(6, HIGH);
    digitalWrite(12, HIGH);
    digitalWrite(13, LOW);

  } else   if (a == 3) {
    digitalWrite(7, LOW);  
    digitalWrite(3, HIGH); 
    digitalWrite(4, LOW);  
  
  } else   if (a == 4) {
    digitalWrite(7, HIGH);  
    digitalWrite(4, HIGH);  
    digitalWrite(3, LOW); 
  }
}
