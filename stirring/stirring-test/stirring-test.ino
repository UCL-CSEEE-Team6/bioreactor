String valString;
String newSpeed;
int newSpeedVal = 500;
int data;

void setup() {
  Serial.begin(9600);
}

void loop() {
  if (Serial.available () > 0) {
    valString = Serial.readStringUntil('\n');
    if (valString == "start-stirring") {
      
      // do some arduino stuff...
      
    } else if (valString == "end-stirring") {
      
      // do some arduino stuff...
      
    } else if (valString == "change-speed") {
      
      newSpeed = Serial.readStringUntil('\n');
      newSpeedVal = newSpeed.toInt();

    } else if (valString == "stirring-check") {
      // return rpm
      
      Serial.println(newSpeedVal);
      
    }
  }
  delay (10);
}
