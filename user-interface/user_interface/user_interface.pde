import controlP5.*;
ControlP5 controlP5;

color [] colors = new color[7];

int width = 1280;
int height = 720;

void setup() {
  size(1280, 720);
  
  controlP5 = new ControlP5(this);
  
  controlP5.addBang("bang 1", 50, 50, 100, 100);
  controlP5.addButton("button 1", 1, 350, 50, 300, 100);
  controlP5.addToggle("toggle 1", false, 850, 50, 100, 100);
  controlP5.addSlider("slider 1", 0, 255, 640, 50, 400, 50, 500);
  controlP5.addSlider("slider 2", 0, 255, 640, 350, 400, 500, 50);
  controlP5.addKnob("knob 1", 0, 360, 0, 350, 600, 100);
  controlP5.addNumberbox("numberbox 1", 50, 850, 600, 300, 70);
}

void draw() {
  background(0);
  
  for (int i = 0; i < 7; i++) {
    noStroke();
    fill(colors[i]);
    rect(10 + (i * 45), 210, 40, 40);
  }
}
