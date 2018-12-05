#include <math.h>
#define ph   //This will be info from analog ph
#define phS 7 //ph of standard solution
#define Es   //Electrical potential at reference or standard electrode
#define F 9.6485309*10000 //Faraday constant
#define R 8.314510 //universal gas constant
#define pump1  //pinNum of pump for acid
#define pump2  //pinNum of pump for alkali

bool acid;
bool alkali;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(ph,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  char str[];
  int Ex = analogRead(ph);
  int T = ;//This will get information from Temperature Team
  int ln = log(10)/log(2.71828);
  float phX = phS + (F*Es-F*Ex)/(R*T*ln);
  Serial.println("ph:",phX);
  str[]=Serial.read();
  if (str[]=="" || phX <= ) acid=True;
  if (str[]=="" && phX >= ) acid=False;
  if (str[]=="" || phX >= ) alkali=True;
  if (str[]=="" && phX <= ) alkali=False;
  if (acid==True) digitalWrite(pump1,HIGH);
  if (acid==False) digitalWrite(pump1,LOW);
  if (alkali==True) digitalWrite(pump2,HIGH);
  if (alkali==False) digitalWrite(pump2,LOW);
}
