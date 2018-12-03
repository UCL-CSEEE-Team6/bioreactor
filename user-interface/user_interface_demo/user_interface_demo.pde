import controlP5.*;
ControlP5 controlP5;

color [] colors = new color [7];

int width = 1280;
int height = 800;
ControlTimer c;
Chart myChart;

void setup() {
  size(1280, 720);
  frameRate(60);
  controlP5 = new ControlP5(this);
  // init
  c = new ControlTimer();
  c.setSpeedOfTime(1);
  // timer
  controlP5.addBang("bang 1").setPosition(50, 50).setSize(100, 100);
  controlP5.addButton("button 1").setValue(1).setPosition(350, 50).setSize(300, 100);
  controlP5.addToggle("toggle 1").setValue(false).setPosition(850, 50).setSize(100, 100);
  controlP5.addSlider("slider 1", 0, 255, 640, 50, 200, 50, 500);
  controlP5.addSlider("slider 2", 0, 255, 640, 350, 200, 500, 50);
  controlP5.addKnob("knob 1", 0, 360, 0, 350, 350, 100);
  // user control
  controlP5.printPublicMethodsFor(Chart.class);
  myChart = controlP5.addChart("hello").setPosition(600, 300).setSize(400, 400).setRange(-20, 20).setView(Chart.BAR);
  myChart.addDataSet("world");
  myChart.setData("world", new float[4]);
  myChart.setStrokeWeight(1.5);
  myChart.addDataSet("earth");
  myChart.setColors("earth", color(6));
  myChart.updateData("earth", 1, 2, 10, 3);
  // draw chart
  controlP5.addFrameRate().setInterval(10).setPosition(width - 10, height - 10);
}

void draw() {
  background(0);
  textSize(32);
  fill(255);
  text(c.toString(), 35, 35);
  // draw time
  // BG
  for (int i = 0; i < 7; i++) {
    noStroke();
    fill(colors[i]);
    rect(10 + (i * 45), 210, 40, 40);
  }
  // draw buttons
  myChart.unshift("world", (sin(frameCount*0.01)*10));
  myChart.push("earth", (sin(frameCount*0.1)*10));
  // draw chart

}
