#include <math.h>
#define ph   //This will be info from analog ph
#define phS 7 //ph of standard solution
#define Es   //Electrical potential at reference or standard electrode
#define F 9.6485309*10000 //Faraday constant
#define R 8.314510 //universal gas constant
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(ph,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  int Ex = analogRead(ph);
  int T = ;//This will get information from Temperature Team
  int ln = log(10)/log(2.71828);
  float phX = phS + (F*Es-F*Ex)/(R*T*ln);
  Serial.println(phX);

}
