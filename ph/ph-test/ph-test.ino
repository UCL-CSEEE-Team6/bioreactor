String valString;
float newPHVal = 7;

void setup() {
  Serial.begin(9600);
}

void loop() {
  if (Serial.available () > 0) {
    valString = Serial.readStringUntil('\n');
    if (valString == "start-ph") {
      
      // do some arduino stuff...
      
    } else if (valString == "end-ph") {
      
      // do some arduino stuff...
      
    } else if (valString == "add-acid") {
      // ...
      newPHVal -= 0.05;
    } else if (valString == "add-akali") {
      // ...
      newPHVal += 0.05;
    } else if (valString == "ph-check") {
      // return rpm
      
      Serial.println(newPHVal);
      
    }
  }
  delay (10);
}
