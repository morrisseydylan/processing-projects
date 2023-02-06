import controlP5.*;

ControlP5 cp5;

controlP5.Button startBttn;
controlP5.DropdownList shapeDropdown;

controlP5.Textlabel maximumStepsLabel;
controlP5.Slider maximumStepsSlider;
controlP5.Textlabel stepRateLabel;
controlP5.Slider stepRateSlider;
controlP5.Textlabel stepSizeLabel;
controlP5.Slider stepSizeSlider;
controlP5.Textlabel stepScaleLabel;
controlP5.Slider stepScaleSlider;

controlP5.Toggle constrainStepsTogg;
controlP5.Toggle simulateTerrainTogg;
controlP5.Toggle useStrokeTogg;
controlP5.Toggle useRandomSeedTogg;

controlP5.Textfield seedValueText;

RandomWalk walk;

void setup() {
  size(1200, 800);
  background(50, 140, 210);
  rectMode(CENTER);
  
  cp5 = new ControlP5(this);
  
  startBttn = cp5.addButton("Start")
    .setPosition(10, 10)
    .setSize(100, 30)
    .setColorBackground(color(0, 150, 0));
  
  shapeDropdown = cp5.addDropdownList("squares")
    .setPosition(10, 50)
    .setItemHeight(40)
    .setBarHeight(40)
    .addItem("squares", 0)
    .addItem("hexagons", 1)
    .setSize(160, 120)
    .setValue(0)
    .close();
    
  maximumStepsLabel = cp5.addTextlabel("maximumStepsLabel")
    .setPosition(10, 200)
    .setText("Maximum Steps");
    
  maximumStepsSlider = cp5.addSlider("maximumStepsSlider")
    .setPosition(10, 210)
    .setSize(180, 20)
    .setRange(100, 50000)
    .setCaptionLabel("")
    .setDecimalPrecision(0)
    .setValue(50000);

  stepRateLabel = cp5.addTextlabel("stepRateLabel")
    .setPosition(10, 240)
    .setText("Step Rate");
    
  stepRateSlider = cp5.addSlider("stepRateSlider")
    .setPosition(10, 250)
    .setSize(180, 20)
    .setRange(1, 1000)
    .setCaptionLabel("")
    .setDecimalPrecision(0);

  stepSizeLabel = cp5.addTextlabel("stepSizeLabel")
    .setPosition(10, 310)
    .setText("Step Size");
    
  stepSizeSlider = cp5.addSlider("stepSizeSlider")
    .setPosition(10, 320)
    .setSize(80, 20)
    .setRange(10, 30)
    .setCaptionLabel("")
    .setDecimalPrecision(0);

  stepScaleLabel = cp5.addTextlabel("stepScaleLabel")
    .setPosition(10, 350)
    .setText("Step Scale");
    
  stepScaleSlider = cp5.addSlider("stepScaleSlider")
    .setPosition(10, 360)
    .setSize(80, 20)
    .setRange(1, 1.5)
    .setCaptionLabel("");
  
  constrainStepsTogg = cp5.addToggle("constrain steps")
    .setPosition(10, 400)
    .setSize(20, 20)
    .setState(true);
    
  simulateTerrainTogg = cp5.addToggle("simulate terrain")
    .setPosition(10, 440)
    .setSize(20, 20)
    .setState(true);
    
  useStrokeTogg = cp5.addToggle("use stroke")
    .setPosition(10, 480)
    .setSize(20, 20);
    
  useRandomSeedTogg = cp5.addToggle("use random seed")
    .setPosition(10, 520)
    .setSize(20, 20);
    
  seedValueText = cp5.addTextfield("seed value")
    .setPosition(110, 520)
    .setSize(70, 20)
    .setInputFilter(ControlP5.INTEGER)
    .setText("0");
  
  walk = null;
}

void draw() {
  stroke(0);
  fill(100);
  rect(100, 400, 200, 800);
  
  if (walk != null)
    if (walk.walking)
      walk.TakeSteps(Integer.parseInt(stepRateSlider.getValueLabel().getText()));
}

abstract class RandomWalk {
  boolean walking;
  int maximumSteps;
  int stepsTaken;
  int stepDistance;
  float stepScale;
  boolean useColor;
  boolean useStroke;
  boolean bound;
  
  float x;
  float y;
  HashMap<PVector, Integer> count;
  
  RandomWalk() {
    walking = true;
    maximumSteps = Integer.parseInt(maximumStepsSlider.getValueLabel().getText());
    stepsTaken = 0;
    stepDistance = Integer.parseInt(stepSizeSlider.getValueLabel().getText());
    stepScale = Float.parseFloat(stepScaleSlider.getValueLabel().getText());
    useColor = simulateTerrainTogg.getState();
    useStroke = useStrokeTogg.getState();
    bound = constrainStepsTogg.getState();
    
    x = 700;
    y = 400;
    count = new HashMap<PVector, Integer>();
  }
   public abstract void Update();
   public abstract void Draw();
   public void TakeSteps(int numOfSteps) {
    if (stepsTaken + numOfSteps > maximumSteps)
      numOfSteps = maximumSteps - stepsTaken;
    for (int i = 0; i < numOfSteps; i++) {
      Update();
      Draw();
    }
    stepsTaken += numOfSteps;
    if (stepsTaken >= maximumSteps)
      walking = false;
  }
   public int GetTerrainColor(int count) {
    if (count < 4) return color(160, 126, 84);
    if (count < 7) return color(143, 170, 64);
    if (count < 10) return 135;
    int colorVal = count * 20;
    if (count > 255) return 255;
    return colorVal;
  }
}

class SquareWalk extends RandomWalk {
  SquareWalk() {
    count.put(new PVector(x, y), 1);
    Draw();
  }
   public void Update() {
    if (bound) {
      boolean invalidDirection;
      do {
        int direction = PApplet.parseInt(random(4));
        if (direction == 0) {
          if (y <= stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            y -= stepDistance * stepScale;
            invalidDirection = false;
          }
        }
        else if (direction == 1) {
          if (x >= 1200 - stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            x += stepDistance * stepScale;
            invalidDirection = false;
          }
        }
        else if (direction == 2) {
          if (y >= 800 - stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            y += stepDistance * stepScale;
            invalidDirection = false;
          }
        }
        else {
          if (x <= 200 + stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            x -= stepDistance * stepScale;
            invalidDirection = false;
          }
        }
      } while (invalidDirection);
    }
    else {
      int direction = PApplet.parseInt(random(4));
      if (direction == 0)
        y -= stepDistance * stepScale;
      else if (direction == 1)
        x += stepDistance * stepScale;
      else if (direction == 2)
        y += stepDistance * stepScale;
      else
        x -= stepDistance * stepScale;
    }
    PVector point = new PVector(x, y);
    int value = count.getOrDefault(point, 0) + 1;
    count.put(point, value);
  }
   public void Draw() {
    if (useStroke) stroke(0);
    else noStroke();
    if (useColor) fill(GetTerrainColor(count.get(new PVector(x, y))));
    else fill(165, 100, 200);
    rect(x, y, stepDistance, stepDistance);
  }
}

class HexagonWalk extends RandomWalk {
  HexagonWalk() {
    count.put(CartesianToHex(), 1);
    Draw();
  }
   public void Update() {
    if (bound) {
      boolean invalidDirection;
      do {
        int direction = PApplet.parseInt(random(6));
        if (direction == 0) {
          if (x >= 1200 - stepDistance * sqrt(3) * stepScale || y >= 800 - stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            x += stepDistance * sqrt(3) / 2.0f * stepScale;
            y += stepDistance / 2.0f * stepScale;
            invalidDirection = false;
          }
        }
        else if (direction == 1) {
          if (y >= 800 - stepDistance * stepScale * 2) {
            invalidDirection = true;
          } else {
            y += stepDistance * stepScale;
            invalidDirection = false;
          }
        }
        else if (direction == 2) {
          if (x <= 200 + stepDistance * sqrt(3) * stepScale || y >= 800 - stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            x -= stepDistance * sqrt(3) / 2.0f * stepScale;
            y += stepDistance / 2.0f * stepScale;
            invalidDirection = false;
          }
        }
        else if (direction == 3) {
          if (x <= 200 + stepDistance * sqrt(3) * stepScale || y <= stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            x -= stepDistance * sqrt(3) / 2.0f * stepScale;
            y -= stepDistance / 2.0f * stepScale;
            invalidDirection = false;
          }
        }
        else if (direction == 4) {
          if (y <= stepDistance * stepScale * 2) {
            invalidDirection = true;
          } else {
            y -= stepDistance * stepScale;
            invalidDirection = false;
          }
        }
        else {
          if (x >= 1200 - stepDistance * sqrt(3) * stepScale || y <= stepDistance * stepScale) {
            invalidDirection = true;
          } else {
            x += stepDistance * sqrt(3) / 2.0f * stepScale;
            y -= stepDistance / 2.0f * stepScale;
            invalidDirection = false;
          }
        }
      } while (invalidDirection);
    }
    else {
      int direction = PApplet.parseInt(random(6));
      if (direction == 0) {
        x += stepDistance * sqrt(3) / 2.0f * stepScale;
        y += stepDistance / 2.0f * stepScale;
      }
      else if (direction == 1) {
        y += stepDistance * stepScale;
      }
      else if (direction == 2) {
        x -= stepDistance * sqrt(3) / 2.0f * stepScale;
        y += stepDistance / 2.0f * stepScale;
      }
      else if (direction == 3) {
        x -= stepDistance * sqrt(3) / 2.0f * stepScale;
        y -= stepDistance / 2.0f * stepScale;
      }
      else if (direction == 4) {
        y -= stepDistance * stepScale;
      }
      else {
        x += stepDistance * sqrt(3) / 2.0f * stepScale;
        y -= stepDistance / 2.0f * stepScale;
      }
    }
    PVector point = CartesianToHex();
    int value = count.getOrDefault(point, 0) + 1;
    count.put(point, value);
  }
   public void Draw() {
    if (useStroke) stroke(0);
    else noStroke();
    if (useColor) fill(GetTerrainColor(count.get(CartesianToHex())));
    else fill(165, 100, 200);
    beginShape();
    float radius = stepDistance / 2.0f;
    for (int i = 0; i <= 360; i+= 60) {
      float xPos = x + cos(radians(i)) * radius;
      float yPos = y + sin(radians(i)) * radius;
  
      vertex(xPos, yPos);
    }
    endShape();
  }
   public PVector CartesianToHex()
  {
    float hexRadius = stepDistance / 2.0f;
    
    float startX = x;
    float startY = y;
  
    float col = (2.0f/3.0f * startX) / (hexRadius * stepScale);
    float row = (-1.0f/3.0f * startX + 1/sqrt(3.0f) * startY) / (hexRadius * stepScale);
    
    /*===== Convert to Cube Coordinates =====*/
    float x = col;
    float z = row;
    float y = -x - z; // x + y + z = 0 in this system
    
    float roundX = round(x);
    float roundY = round(y);
    float roundZ = round(z);
    
    float xDiff = abs(roundX - x);
    float yDiff = abs(roundY - y);
    float zDiff = abs(roundZ - z);
    
    if (xDiff > yDiff && xDiff > zDiff)
      roundX = -roundY - roundZ;
    else if (yDiff > zDiff)
      roundY = -roundX - roundZ;
    else
      roundZ = -roundX - roundY;
      
    /*===== Convert Cube to Axial Coordinates =====*/
    PVector result = new PVector(roundX, roundZ);
    
    return result;
  }
}

void Start() {
  background(50, 140, 210);
  
  if (useRandomSeedTogg.getState())
    randomSeed(frameCount);
  else
    randomSeed(Integer.parseInt(seedValueText.getText()));
  
  if (shapeDropdown.getValue() == 0)
    walk = new SquareWalk();
  else
    walk = new HexagonWalk();
}
