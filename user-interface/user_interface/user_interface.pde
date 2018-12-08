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

boolean toggleStirring;
boolean prevToggleStirring = false;
Slider speedSlider;
float prevSpeedValue;
Chart speedChart;

boolean togglePH;
boolean prevTogglePH = false;
Button addAcid;
boolean prevAddAcid = false;
Button addAkali;
boolean prevAddAkali = false;
Chart phChart;

//declare sensor constants
int queryGap = 50;
int lastQueryTime = -50;

//declare TBD constants
int heatLowerBound = 28;
int heatUpperBound = 35;
int heatAdjustInterval = 1;
int speedLowerBound = 500;
int speedUpperBound = 1500;
int speedAdjustInterval = 500;
int phLowerBound = 3;
int phUpperBound = 7;

//declare Serial Port
//Serial heatingPort = new Serial(this, "/dev/cu.usbmodem142301", 9600);
Serial stirringPort = new Serial(this, "/dev/cu.usbmodem142401", 9600);
Serial phPort = new Serial(this, "/dev/cu.usbmodem142301", 9600);

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
  initStirringControls();
  initPHControls();
  
  //init graph
  initHeatingChart();
  initStirringChart();
  initPHChart();
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

void initStirringControls () {
  cp5.addToggle("toggleStirring")
    .setValue(false)
    .setPosition(initWidth + 10, textHeight + sectionHeight + 50)
    .setSize(100, 100)
    .setCaptionLabel("Toggle Stirring");
  prevToggleHeating = false;
  speedSlider = cp5.addSlider("speedSlider")
    .setPosition(initWidth + 175, textHeight + sectionHeight)
    .setSize(20, 200)
    .setRange(speedLowerBound, speedUpperBound)
    .setValue(speedLowerBound)
    .setNumberOfTickMarks( (speedUpperBound - speedLowerBound) / speedAdjustInterval + 1)
    .showTickMarks(true)
    .setCaptionLabel("Adjust Speed");
  prevSpeedValue = speedLowerBound;
}

void initPHControls () {
  cp5.addToggle("togglePH")
    .setValue(false)
    .setPosition(initWidth + 10, textHeight + sectionHeight * 2 + 50)
    .setSize(100, 100)
    .setCaptionLabel("Toggle PH Control");
  prevTogglePH = false;
  addAcid = cp5.addButton("addAcid")
    .setValue(0)
    .setPosition(initWidth + 125, textHeight + sectionHeight * 2 + 50)
    .setSize(75, 30)
    .setCaptionLabel("Add Acid");
  addAkali =cp5.addButton("addAkali")
    .setValue(0)
    .setPosition(initWidth + 125, textHeight + sectionHeight * 2 + 50 + 40)
    .setSize(75, 30)
    .setCaptionLabel("Add Akali");
}

void initHeatingChart () {
  temperatureChart = cp5.addChart("temperatureChart")
                        .setPosition(initWidth + 225, textHeight)
                        .setSize(700, sectionHeight - 50)
                        .setRange(heatLowerBound, heatUpperBound)
                        .setView(Chart.LINE)
                        .setCaptionLabel("")
                        .setStrokeWeight(10);
  temperatureChart.addDataSet("temperature");
  temperatureChart.setData("temperature", heatLowerBound, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void initStirringChart () {
  speedChart = cp5.addChart("speedChart")
                        .setPosition(initWidth + 225, textHeight + sectionHeight)
                        .setSize(700, sectionHeight - 50)
                        .setRange(speedLowerBound, speedUpperBound)
                        .setView(Chart.LINE)
                        .setCaptionLabel("")
                        .setStrokeWeight(10);
  speedChart.addDataSet("speed");
  speedChart.setData("speed", speedLowerBound, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void initPHChart () {
  phChart = cp5.addChart("phChart")
                        .setPosition(initWidth + 225, textHeight + sectionHeight * 2)
                        .setSize(700, sectionHeight - 50)
                        .setRange(phLowerBound, phUpperBound)
                        .setView(Chart.LINE)
                        .setCaptionLabel("")
                        .setStrokeWeight(10);
  phChart.addDataSet("ph");
  phChart.setData("ph", phLowerBound - 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
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
      drawTemperatureSensorData();
      drawSpeedSensorData();
      drawPHSensorData();
      lastQueryTime = millis();
  }
}

void drawTemperatureSensorData () {
  temperatureChart.unshift("temperature", queryHeatingTemperature());
}

void drawSpeedSensorData () {
  speedChart.unshift("speed", queryStirringSpeed());
}

void drawPHSensorData() {
  phChart.unshift("ph", queryPH());
}

void monitorUserControl () {
  heatingUserControl();
  stirringUserControl();
  phUserControl();
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
  //heatingPort.write("start-heating");
}

void endHeating () {
  //heatingPort.write("stop-heating");
}

boolean changeHeatingTemperature (float newTemperatureValue) {
  //heatingPort.write("change-temperature");
  //heatingPort.write(str(newTemperatureValue));
  //String changeStatus = trim(heatingPort.readStringUntil('\n'));
  //if (changeStatus == "true") return true;
  //else return false; // if changing temperature successful return true otherwise return false
  return true;
}

float queryHeatingTemperature () {
  float currentTemperature = sin(frameCount * 0.01) * 1.5 + (heatLowerBound + heatUpperBound) / 2; // random demo stuff nvm
  //heatingPort.write("temperature-check");
  //String temperatureString = trim(heatingPort.readStringUntil('\n'));
  //float currentTemperature = float(temperatureString);
  return currentTemperature;
}

void stirringUserControl () {
  if (toggleStirring) {
    float speedValue = speedSlider.getValue();
    if (speedValue != prevSpeedValue) {
      addConsoleMsg("changing speed from " + prevSpeedValue + " to " + speedValue);
      if (changeStirringSpeed(speedValue)) {
        addConsoleMsg("speed changed to " + speedValue);
      }
      else {
        addConsoleMsg("Failed! Speed remains at " + prevSpeedValue);
        speedSlider.setValue(prevSpeedValue);
        speedValue = prevSpeedValue;
      }
    }
    prevSpeedValue = speedValue;
  }
  if ((toggleStirring != prevToggleStirring) && (prevToggleStirring == false)) {
    addConsoleMsg("started Stirring at time " + timer.toString());
    startStirring();
  }
  if ((toggleStirring != prevToggleStirring) && (prevToggleStirring == true)) {
    addConsoleMsg("stopped Stirring at time " + timer.toString());
    endStirring();
  }
  prevToggleStirring = toggleStirring;
}

void startStirring () {
  //stirringPort.write("start-stirring");
}

void endStirring () {
  //stirringPort.write("end-stirring");
}

boolean changeStirringSpeed (float newStirringSpeed) {
  stirringPort.write("change-speed\n"); 
  stirringPort.write(str(newStirringSpeed) + "\n");
  return true;
}

float queryStirringSpeed () {
  //float currentSpeed = sin(frameCount * 0.01) * 40 + (speedLowerBound + speedUpperBound) / 2; // random demo stuff nvm
  stirringPort.write("stirring-check\n");
  String speedString = trim(stirringPort.readStringUntil('\n'));
  float currentSpeed = speedLowerBound;
  if (speedString != null) currentSpeed = float(speedString);
  return currentSpeed;
}

void phUserControl () {
  if (togglePH) {
    if (addAcid.isPressed() && !prevAddAcid) {
      addConsoleMsg("add acid at time " + timer.toString());
    } else if (addAcid.isPressed()) {
      addAcid();
    } else if (!addAcid.isPressed() && prevAddAcid) {
      addConsoleMsg("add acid finished at time " + timer.toString());
    }
    prevAddAcid = addAcid.isPressed();
    if (addAkali.isPressed() && !prevAddAkali) {
      addConsoleMsg("add akali at time " + timer.toString());
    } else if (addAkali.isPressed()) {
      addAkali();
    } else if (!addAkali.isPressed() && prevAddAkali) {
      addConsoleMsg("add akali finished at time " + timer.toString());
    }
    prevAddAkali = addAkali.isPressed();
  }
  if ((togglePH != prevTogglePH) && (prevTogglePH == false)) {
    addConsoleMsg("started pH module at time " + timer.toString());
    startPH();
  }
  if ((togglePH != prevTogglePH) && (prevTogglePH == true)) {
    addConsoleMsg("stopped pH module at time " + timer.toString());
    endPH();
  }
  prevTogglePH = togglePH;
}


void startPH () {
  phPort.write("start-ph\n");
}

void endPH () {
  phPort.write("end-ph\n");
}
  
void addAcid() {
  phPort.write("add-acid\n");
}

void addAkali () {
  phPort.write("add-akali\n");
}
float queryPH() {
  // some way to read pHValue
  phPort.write("ph-check\n");
  String phString = trim(phPort.readStringUntil('\n'));
  //println(phString);
  float currentPH = phLowerBound;
  if (phString != null) currentPH = float(phString);
  return currentPH;
}
