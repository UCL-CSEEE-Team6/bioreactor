const byte motorControl = 9;
double count;
int val = 0;
const byte interruptPin = 2;
unsigned long timeold;
unsigned int rpm;
unsigned int realrpm;
int data;

void setup() {
  Serial.begin(9600);
  pinMode(motorControl, OUTPUT);
  pinMode(interruptPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPin),counts,FALLING);
  rpm = 0;
  timeold = 0;
  count = 0;
  realrpm = 0;
  data = 0;
}

void loop() {
  if(Serial.available())
  {
    val=Serial.read();
    Serial.println(val);
  }
  if (realrpm > (val+20)){
    data = data - 1;
    analogWrite(motorControl,data);
  }
  else if (realrpm < (val-20)){
    data = data + 1;
    analogWrite(motorControl,data);
  }
  else{
    analogWrite(motorControl,data);
  }
  //analogWrite(motorControl,250);
  if (count >= 50){
    rpm = count/(millis()-timeold)*60*1000;
    timeold = millis();
    count = 0;
    realrpm=rpm;
    //Serial.println(realrpm);
  }
}

void counts()
{
  count = count + 0.5;
  //Serial.println(count);
}
