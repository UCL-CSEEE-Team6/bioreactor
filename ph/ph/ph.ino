#include <math.h>
#define ph   //This will be info from analog ph
#define phS 7 //ph of standard solution
#define Es 512  //Electrical potential at reference or standard electrode
#define F 9.6485309*10000 //Faraday constant
#define R 8.314510 //universal gas constant
#define pump1  //pinNum of pump for acid
#define pump2  //pinNum of pump for alkali
#define voltageSupply  //pinNum of voltage supply of 1.024V

bool acid;
bool alkali;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(ph,OUTPUT);
  analogWrite(voltageSupply,210);
}

void loop() {
  // put your main code here, to run repeatedly:
  char str;
  float Ex = analogRead(ph)*5000/1023;
  int T = ;//This will get information from Temperature Team
  float ln = log(10)/log(2.71828);
  float phX = phS + (F*Es-F*Ex)/(R*T*ln);
  Serial.println("ph:",phX);
  str=Serial.read();
  if (str=='' || phX >= 5.5) acid=True;
  if (str=='' && phX <= 5.2) acid=False;
  if (str=='' || phX <= 4。5) alkali=True;
  if (str=='' && phX >= 4.8) alkali=False;
  if (acid==True) digitalWrite(pump1,HIGH);
  if (acid==False) digitalWrite(pump1,LOW);
  if (alkali==True) digitalWrite(pump2,HIGH);
  if (alkali==False) digitalWrite(pump2,LOW);
}
