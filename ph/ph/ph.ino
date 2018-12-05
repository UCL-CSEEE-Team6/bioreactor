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
int phv;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(ph,OUTPUT);
  analogWrite(voltageSupply,210);
}

void loop() {
  // put your main code here, to run repeatedly:
  char str;
  int phx=analogRead(ph);
  if (phx>50) phv=phx;
  float Ex = phv*5000/1023;
  int T = ;//This will get information from Temperature Team
  float ln = log(10)/log(2.71828);
  float phX = phS + (F*Es-F*Ex)/(R*T*ln);
  Serial.print("ph:");
  Serial.println(phX);
  str=Serial.read();
  if (str==' ' || phX >= 5.5) acid=true;
  if (str==' ' && phX <= 5.2) acid=false;
  if (str==' ' || phX <= 4.5) alkali=true;
  if (str==' ' && phX >= 4.8) alkali=false;
  Serial.print("acid:");
  Serial.println(acid);
  Serial.print("alkali:");
  Serial.print(alkali);
  if (acid==true) digitalWrite(pump1,HIGH);
  if (acid==false) digitalWrite(pump1,LOW);
  if (alkali==true) digitalWrite(pump2,HIGH);
  if (alkali==false) digitalWrite(pump2,LOW);
}
