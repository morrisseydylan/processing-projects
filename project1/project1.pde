import controlP5.*;

ControlP5 cp5;
controlP5.Button startBttn;
controlP5.Toggle colorTogg;
controlP5.Toggle gradualTogg;
controlP5.Slider iterationSlider;
controlP5.Slider stepSlider;

boolean colorToggled = false;
boolean gradualToggled = false;
int iterations = 1000;
int stepCount = 1;

int[][] points = new int[500000][3];
int numOfPoints = 0;
int startingFrame;

boolean colorRampUp = false;
boolean gradualWalking = false;

int currentX;
int currentY;

void setup() {
  size(800, 800);
  background(140, 170, 209);
  cp5 = new ControlP5(this);
  
  startBttn = cp5.addButton("start").setPosition(10, 30).setSize(100, 30);
  startBttn.getCaptionLabel().setText("start").setSize(20);
  
  colorTogg = cp5.addToggle("toggleColor").setPosition(124, 30).setSize(30, 30);
  colorTogg.getCaptionLabel().setText("color").setSize(20).setPadding(35, -25);
  
  gradualTogg = cp5.addToggle("toggleGradual").setPosition(124, 61).setSize(30, 30);
  gradualTogg.getCaptionLabel().setText("gradual").setSize(20).setPadding(35, -25);
  
  iterationSlider = cp5.addSlider("setIterations").setPosition(239, 30).setSize(375, 30).setRange(1000, 500000);
  iterationSlider.getCaptionLabel().setText("iterations").setSize(20);
  iterationSlider.getValueLabel().setSize(20);
  
  stepSlider = cp5.addSlider("setStepCount").setPosition(239, 60).setSize(375, 30).setRange(1, 1000);
  stepSlider.getCaptionLabel().setText("step count").setSize(20);
  stepSlider.getValueLabel().setSize(20);
  
  resetSteps();
}

void draw() {
  background(140, 170, 209);
  stroke(0);
  
  if (gradualWalking) {
    int currentFrame = frameCount - startingFrame;
    int numOfPointsToDraw = currentFrame * stepCount;
    if (numOfPointsToDraw > numOfPoints) numOfPointsToDraw = numOfPoints;
    for (int i = 0; i < numOfPointsToDraw; i++) {
      if (points[i][0] != -1) {
        if (colorRampUp) stroke(points[i][2]);
        point(points[i][0], points[i][1]);
      }
    }
  }
  else {
    for (int i = 0; i < numOfPoints; i++) {
      if (points[i][0] != -1) {
        if (colorRampUp) stroke(points[i][2]);
        point(points[i][0], points[i][1]);
      }
    }
  }
}

void start() {
  resetSteps();
  numOfPoints = iterations;
  currentX = 400;
  currentY = 400;
  points[0][0] = currentX;
  points[0][1] = currentY;
  
  for (int i = 1; i < numOfPoints; i++) {
    boolean validDirection = true;
    do {
      int direction = int(random(4));
      if (direction == 0) {
        if (currentY == 0) {
          validDirection = false;
        } else {
          currentY--;
          validDirection = true;
        }
      }
      if (direction == 1) {
        if (currentX == 800) {
          validDirection = false;
        } else {
          currentX++;
          validDirection = true;
        }
      }
      if (direction == 2) {
        if (currentY == 800) {
          validDirection = false;
        } else {
          currentY++;
          validDirection = true;
        }
      }
      if (direction == 3) {
        if (currentX == 0) {
          validDirection = false;
        } else {
          currentX--;
          validDirection = true;
        }
      }
    } while (!validDirection);
    points[i][0] = currentX;
    points[i][1] = currentY;
  }
  
  if (colorToggled) {
    colorRampUp = true;
    for (int i = 0; i < numOfPoints; i++) {
      points[i][2] = int(float(i) / float(numOfPoints) * 255);
    }
  } else {
    colorRampUp = false;
  } //<>//
  if (gradualToggled) {
    gradualWalking = true;
    startingFrame = frameCount;
  }
  else {
    gradualWalking = false;
  }
}

void toggleColor(boolean val) {
  colorToggled = val;
}

void toggleGradual(boolean val) {
  gradualToggled = val;
}

void setIterations(int val) {
  iterations = val;
}

void setStepCount(int val) {
  stepCount = val;
}

void resetSteps() {
  for (int i = 0; i < 500000; i++) {
    points[i][0] = -1;
    points[i][1] = -1;
    points[i][2] = 0;
  }
}
