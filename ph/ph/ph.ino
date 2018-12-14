#include <math.h>
#include <string.h>
const int ph=A5; //This will be info from analog ph
const int phS=7; //ph of standard solution
const float Es=512.0;  //Electrical potential at reference or standard electrode
const float F=9.6485309*10000; //Faraday constant
const float R=8.314510; //universal gas constant
const int pump1=13; //pinNum of pump for acid
const int pump2=12; //pinNum of pump for alkali
const int voltageSupply=11; //pinNum of voltage supply of 1.024V
const int tmp = A1; //pinNum for temperature input

bool acid;
bool alkali;
int phv;
String str;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(pump1,OUTPUT);
  pinMode(pump2,OUTPUT);
  analogWrite(voltageSupply,210);
}

double getTemp(int i)
{
  i=i-200;
  double temp;
  temp = log(((10240000/i)-10000));
  temp = 1/(0.001129148 + (0.000234125+(0.0000000876741 * temp * temp)) * temp);
  return temp;
}

void loop() {
  // put your main code here, to run repeatedly:
  phv=analogRead(ph);
  float Ex = phv*5000.0/1023;
  int T = getTemp(analogRead(tmp)); //This will get information from Temperature Team
  float ln = log(10)/log(2.71828);
  float phX = phS + ((Es-Ex)*0.001*F)/(R*T*ln);
  str=Serial.readString();
  if (str=="ph-check") Serial.println(phX);
  str=Serial.read();
  if (str=="add-acid" || phX >= 5.5) acid=true;
  if (phX <= 5.2) acid=false;
  if (str=="add-alkali" || phX <= 4.5) alkali=true;
  if (phX >= 4.8) alkali=false;
  if (acid==true) digitalWrite(pump1,HIGH);
  if (acid==false) digitalWrite(pump1,LOW);
  if (alkali==true) digitalWrite(pump2,HIGH);
  if (alkali==false) digitalWrite(pump2,LOW);
  delay(100);
}
