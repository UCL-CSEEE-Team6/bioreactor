const byte motorControl = 9;
double count;
const byte interruptPin = 2;
unsigned long timeold;
unsigned int rpm;
unsigned int realrpm;
int data;
int value;
String val;
String newSpeed;

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
  analogWrite(motorControl,data);
  if(Serial.available()>0)
  {
    val=Serial.readStringUntil('\n');
    if(val=="start-stirring"){
      data = 42;
    }
    else if (val == "end-stirring"){
      data = 0;
    }
    else if(val == "change-speed"){
      newSpeed = Serial.readStringUntil('\n');
      value = newSpeed.toInt();
      if (value==500){
        data=29;
      }
      else if (value==1000){
        data=42;
      }
      else if (value==1500){
        data=52;
      }
    }
    else if (val == "stirring-check" ){
      Serial.println(realrpm);
    }
  }
 /* if (realrpm > (value+20)){
    data = data - 1;
  }
  else if (realrpm < (value-20)){
    data = data + 1;
  }*/
  if (count >= 30){
    rpm = count/(millis()-timeold)*60*1000;
    timeold = millis();
    count = 0;
    realrpm=1.93*rpm;
    //Serial.println(realrpm);
  }
  /*if(millis()-timeold==1000){
    detachInterrupt(interruptPin);
    rpm=count*60;
    count=0;
    timeold = millis();
    realrpm=1.93*rpm;
    attachInterrupt(digitalPinToInterrupt(interruptPin),counts,FALLING);
  }*/
}

void counts()
{
  count = count + 0.5;
  //Serial.println(count);
}
