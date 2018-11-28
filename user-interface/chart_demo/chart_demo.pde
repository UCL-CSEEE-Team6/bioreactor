import controlP5.*;
ControlP5 controlP5;

color [] colors = new color [7];

int width = 1280;
int height = 720;

Chart myChart;

void setup() {
  size(1280, 720);
  smooth();
  controlP5 = new ControlP5(this);
  controlP5 = new ControlP5(this);
  controlP5.printPublicMethodsFor(Chart.class);
  myChart = controlP5.addChart("hello").setPosition(50, 50).setSize(400, 400).setRange(-20, 20).setView(Chart.BAR);
  myChart.addDataSet("world");
  myChart.setData("world", new float[4]);
  myChart.setStrokeWeight(1.5);
  myChart.addDataSet("earth");
  myChart.setColors("earth", color(6));
  myChart.updateData("earth", 1, 2, 10, 3);
}


void draw() {
  background(0);
  myChart.unshift("world", (sin(frameCount*0.01)*10));
  myChart.push("earth", (sin(frameCount*0.1)*10));
}
