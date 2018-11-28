import controlP5.*;

ControlP5 controlP5;

color [] colors = new color [7];

ControlTimer c;
Textlabel t;

void setup() {
  size(1280,720);
  frameRate(60);
  controlP5 = new ControlP5(this);
  c = new ControlTimer();
  c.setSpeedOfTime(1);
}


void draw() {
  background(0);
  textSize(32);
  text(c.toString(), 10, 30);
}


void mousePressed() {
  c.reset();
}
