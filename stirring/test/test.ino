String valString;
String newSpeed;
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
      int newSpeedVal = newSpeed.toInt();
      
      if (newSpeedVal == 500) {

        data = 29;
        
      } else if (newSpeedVal == 1000) {
        
        data = 42;
        
      } else if (newSpeedVal == 1500) {
        
        data = 52;
        
      }
      
    } else if (valString == "stirring-check") {
      // return rpm
      
      Serial.println("1000");
      
    }
  }
}
