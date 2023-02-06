import controlP5.*;
ControlP5 cp5;

controlP5.Slider rows;
controlP5.Slider columns;
controlP5.Slider terrainSize;
controlP5.Button generate;
controlP5.Textfield loadFromFile;
controlP5.Toggle stroke;
controlP5.Toggle colour;
controlP5.Toggle blend;
controlP5.Slider heightModifier;
controlP5.Slider snowThreshold;

Camera myCamera;
Terrain myTerrain;

void setup() {
  size(1200, 800, P3D);
  
  cp5 = new ControlP5(this);
  
  rows = cp5.addSlider("rows")
    .setPosition(10, 10)
    .setValue(10)
    .setRange(1, 100)
    .setDecimalPrecision(0);
    
  columns = cp5.addSlider("columns")
    .setPosition(10, 30)
    .setValue(10)
    .setRange(1, 100)
    .setDecimalPrecision(0);
    
  terrainSize = cp5.addSlider("terrain size")
    .setPosition(10, 50)
    .setValue(30)
    .setRange(20, 50);
    
  generate = cp5.addButton("generate")
    .setPosition(10, 80);
    
  loadFromFile = cp5.addTextfield("load from file")
    .setPosition(10, 110)
    .setText("terrain1")
    .setAutoClear(false);
    
  stroke = cp5.addToggle("stroke")
    .setPosition(250, 10)
    .setState(true);
    
  colour = cp5.addToggle("color")
    .setPosition(300, 10);
    
  blend = cp5.addToggle("blend")
    .setPosition(350, 10);
    
  heightModifier = cp5.addSlider("height modifier")
    .setPosition(250, 50)
    .setValue(1)
    .setRange(-5, 5);
    
  snowThreshold = cp5.addSlider("snow threshold")
    .setPosition(250, 70)
    .setValue(5)
    .setRange(1, 5);
  
  myCamera = new Camera();
  myTerrain = new Terrain("");
}

void draw() {
  background(0);
  myCamera.Update();
  myTerrain.Draw();
  camera();
  perspective();
}

void generate() {
  myTerrain = new Terrain(loadFromFile.getText());
}

void keyReleased() {
  if (key == ENTER && loadFromFile.isFocus()) generate();
}

class Terrain {
  color snow = color(255, 255, 255);
  color grass = color(143, 170, 64);
  color rock = color(135, 135, 135);
  color dirt = color(160, 126, 84);
  color water = color(0, 75, 200);

  ArrayList<PVector> vertices;
  ArrayList<Integer> triangles;
  
  Terrain(String filename) {
    vertices = new ArrayList<PVector>();
    triangles = new ArrayList<Integer>();
    
    PImage image = null;
    if (filename != "") {
      image = loadImage(filename + ".png");
    }
    
    float minimum = terrainSize.getValue() / -2.0;
    float maximum = terrainSize.getValue() / 2.0;
    
    int numOfRows = (int)rows.getValue();
    int numOfColumns = (int)columns.getValue();
    for (int z = 0; z <= numOfRows; z++) {
      for (int x = 0; x <= numOfColumns; x++) {
        float zPos = map(z, 0, numOfRows, minimum, maximum);
        float xPos = map(x, 0, numOfColumns, minimum, maximum);
        
        float yPos;
        if (image == null) yPos = 0;
        else {
          float x_index = map(x, 0, numOfColumns + 1, 0, image.width);
          float y_index = map(z, 0, numOfRows + 1, 0, image.height);
          color colorAtIndex = image.get((int)x_index, (int)y_index);
          yPos = map(red(colorAtIndex), 0, 255, 0, 1);
        }
        
        vertices.add(new PVector(xPos, yPos, zPos));
        
        if (z == numOfRows || x == numOfColumns) continue;
        int verticesInARow = numOfColumns + 1;
        int startingIndex = z * verticesInARow + x;
        
        triangles.add(startingIndex);
        triangles.add(startingIndex + 1);
        triangles.add(startingIndex + verticesInARow);
        
        triangles.add(startingIndex + 1);
        triangles.add(startingIndex + verticesInARow + 1);
        triangles.add(startingIndex + verticesInARow);
      }
    }
  }
  void Draw() {
    scale(1, -1, 1);
    if (stroke.getState()) stroke(0);
    else noStroke();
    beginShape(TRIANGLES);
    for (Integer index : triangles) {
      PVector vert = vertices.get(index);
      if (colour.getState()) {
        float relativeHeight = abs(vert.y * heightModifier.getValue() / -1 * snowThreshold.getValue());
        if (relativeHeight > 0.8)
          if (blend.getState()) fill(lerpColor(rock, snow, (relativeHeight - 0.8) / 0.2));
          else fill(snow);
        else if (relativeHeight > 0.4)
          if (blend.getState()) fill(lerpColor(grass, rock, (relativeHeight - 0.4) / 0.4));
          else fill(rock);
        else if (relativeHeight > 0.2)
          if (blend.getState()) fill(lerpColor(dirt, grass, (relativeHeight - 0.2) / 0.2));
          else fill(grass);
        else
          if (blend.getState()) fill(lerpColor(water, dirt, relativeHeight / 0.2));
          else fill(water);
      }
      else fill(255);
      vertex(vert.x, vert.y * heightModifier.getValue(), vert.z);
    }
    endShape();
  }
}

void mouseDragged() {
  if (cp5.isMouseOver()) return;
  myCamera.Move((mouseX - pmouseX) * 0.15, (mouseY - pmouseY) * 0.15);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  myCamera.Zoom(e);
}

class Camera {
  float radius;
  float phi;
  float theta;
  
  Camera() {
    radius = 30;
    phi = 90;
    theta = 120;
  }
  void Move(float deltaX, float deltaY) {
    phi += deltaX;
    theta += deltaY;
    
    if (theta < 1) theta = 1;
    else if (theta > 179) theta = 179;
  }
  void Update() {
    float phiR = radians(phi);
    float thetaR = radians(theta);
    
    float derivedX = radius * cos(phiR) * sin(thetaR);
    float derivedY = radius * cos(thetaR);
    float derivedZ = radius * sin(thetaR) * sin(phiR);
    
    camera(derivedX, derivedY, derivedZ, 0, 0, 0, 0, 1, 0);
    perspective(radians(90), width/(float)height, 0.1, 1000);
  }
  void Zoom(float f) {
    radius += f * 5;
    if (radius < 10)
      radius = 10;
    else if (radius > 200)
      radius = 200;
  }
}
