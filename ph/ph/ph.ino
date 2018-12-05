#include <math.h>
#define ph   //This will be info from analog ph
#define phS 7 //ph of standard solution
#define Es 512  //Electrical potential at reference or standard electrode
#define F 9.6485309*10000 //Faraday constant
#define R 8.314510 //universal gas constant
#define pump1 13 //pinNum of pump for acid
#define pump2  //pinNum of pump for alkali
#define voltageSupply  //pinNum of voltage supply of 1.024V
#define tmp  //pinNum for temperature input

bool acid;
bool alkali;
int phv;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(ph,OUTPUT);
  pinMode(pump1,OUTPUT);
  pinMode(pump2,OUTPUT);
  analogWrite(voltageSupply,210);
}

double getTemp(int i)
{
  i=i-200;
  double temp;
  temp = log(((10240000/i)-10000));
  temp = 1/(0,001129148 + (0.000234125+(0.0000000876741 * temp * temp)) * temp);
  return temp;
}

void loop() {
  // put your main code here, to run repeatedly:
  char str;
  int phY=analogRead(ph);
  if (phY>50) phv=phY;
  float Ex = phv*5000/1023;
  int T = getTemp(analogRead(tmp)); //This will get information from Temperature Team
  Serial.print("temp");
  Serial.println(T);
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
