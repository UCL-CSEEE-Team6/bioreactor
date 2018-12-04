import controlP5.*;
import processing.serial.*;

int inf = 65535;

//declare gui drawer
ControlP5 cp5;

//declar fonts
PFont courier_new;
PFont consoleFont;
color [] colors = new color [7];

//declare res
int width = 1280;
int height = 800;
int bgColor = 10;
int initWidth = 10;
int textHeight = 70;
int sectionHeight = 250;
int consoleWidth = 325;
int consoleHeight = 700;

//declare timer
ControlTimer timer;

//declare console
Textarea console;
String consoleMsg;

//declare controls
boolean toggleHeating;
boolean prevToggleHeating = false;
Slider temperatureSlider;
float prevTemperatureValue;
Chart temperatureChart;

//declare sensor constants
int queryGap = 50;
int lastQueryTime = -50;

//declare TBD constants
int heatLowerBound = 30;
int heatUpperBound = 100;
int heatAdjustInterval = 5;
int speedLowerBound = 0;
int speedUpperBound = 2000;
int speedAdjustInterval = 100;

void setup () {
  //init window
  size(1280, 800);
  frameRate(60);
  
  //init gui drawer
  cp5 = new ControlP5(this);
  
  //init fonts
  courier_new = loadFont("CourierNew.vlw");
  consoleFont = loadFont("CourierNewPSMT-12.vlw");
  textFont(courier_new);
  
  //init timer
  timer = new ControlTimer();
  timer.setSpeedOfTime(1);
  
  //init console
  initConsole();
  
  //init buttons and controls
  initHeatingControls();
  
  //init graph
  initHeatingChart();
}

void initConsole() {
  console = cp5.addTextarea("console")
               .setPosition(width - consoleWidth - 10, height - consoleHeight - 25)
               .setSize(consoleWidth, consoleHeight)
               .setCaptionLabel("")
               .setFont(consoleFont)
               .setColorBackground(color(20))
               .scroll(1)
               .hideScrollbar();
}

void addConsoleMsg (String newMsg) {
    String s = console.getText();
    s += newMsg + "\n";
    console.setText(s);
}

void initHeatingControls () {
  cp5.addToggle("toggleHeating")
    .setValue(false)
    .setPosition(initWidth + 10, textHeight + 50)
    .setSize(100, 100)
    .setCaptionLabel("Toggle Heating");
  prevToggleHeating = false;
  temperatureSlider = cp5.addSlider("temperatureSlider")
    .setPosition(initWidth + 175, textHeight)
    .setSize(20, 200)
    .setRange(heatLowerBound, heatUpperBound)
    .setValue(heatLowerBound)
    .setNumberOfTickMarks( (heatUpperBound - heatLowerBound) / heatAdjustInterval + 1)
    .showTickMarks(true)
    .setCaptionLabel("Adjust Temperature");
  prevTemperatureValue = heatLowerBound;
}

void initHeatingChart () {
  temperatureChart = cp5.addChart("temperatureChart")
                        .setPosition(initWidth + 225, textHeight)
                        .setSize(700, sectionHeight - 50)
                        .setRange(heatLowerBound - 20, heatUpperBound + 20)
                        .setView(Chart.LINE)
                        .setCaptionLabel("")
                        .setStrokeWeight(10);
  temperatureChart.addDataSet("temperature");
  temperatureChart.setData("temperature", heatLowerBound - 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void draw () {
  background(bgColor);
  drawTimer();
  drawSection();
  drawSensorData();
  monitorUserControl();
}

void drawSection () {
  text("Heating", initWidth, textHeight);
  text("Stirring", initWidth, textHeight + sectionHeight);
  text("pH", initWidth, textHeight + sectionHeight * 2);
  text("Log", width - consoleWidth - 10, height - consoleHeight - 50);
}

void drawTimer () {
  textSize(32);
  fill(255);
  text(timer.toString(), 5, 35);
}

void drawSensorData () {
  if (millis() - lastQueryTime > queryGap) {
      drawTemperatureSensorData ();
      lastQueryTime = millis();
  }
}

void drawTemperatureSensorData () {
  temperatureChart.unshift("temperature", (int)queryHeatingTemperature());
}

void monitorUserControl () {
  heatingUserControl();
}

void heatingUserControl () {
  if (toggleHeating) {
    float temperatureValue = temperatureSlider.getValue();
    if (temperatureValue != prevTemperatureValue) {
      addConsoleMsg("changing temperature from " + prevTemperatureValue + " to " + temperatureValue);
      if (changeHeatingTemperature(temperatureValue) == true) {
        addConsoleMsg("temperature changed to " + temperatureValue);
      }
      else {
        addConsoleMsg("Failed! Temperature remains at " + prevTemperatureValue);
        temperatureSlider.setValue(prevTemperatureValue);
        temperatureValue = prevTemperatureValue;
      }
    }
    prevTemperatureValue = temperatureValue;
  }
  if ((toggleHeating != prevToggleHeating) && (prevToggleHeating == false)) {
    addConsoleMsg("started Heating at time " + timer.toString());
    startHeating();
  }
  if ((toggleHeating != prevToggleHeating) && (prevToggleHeating == true)) {
    addConsoleMsg("stopped Heating at time " + timer.toString());
    endHeating();
  }
  prevToggleHeating = toggleHeating;
}

void startHeating () {
  // do something to activate the heating module
}

void endHeating () {
  // do something to stop heating
}

boolean changeHeatingTemperature (float newTemperatureValue) {
  // how to change heating Temperature
  return true; // if changing temperature successful return true otherwise return false
}

float queryHeatingTemperature () {
  float currentTemperature = sin(frameCount * 0.01) * 50 + (heatLowerBound + heatUpperBound) / 2; // random demo stuff nvm
  // return value of temperature
  return currentTemperature;
}

void startStirring () {
}

void endStirring () {
}

boolean changeStirringSpeed (float newStirringSpeed) {
  
  return true;
}

float queryStirringSpeed () {
  float currentSpeed = sin(frameCount * 0.01) * 40 + (speedLowerBound + speedUpperBound) / 2;
  //return value of stirring speed
  return currentSpeed;
}

void startPH () {
}

void endPH () {
}
  
float readPHValue() {
  // some way to read pHValue
  float pHValue = 7;
  return pHValue;
}
