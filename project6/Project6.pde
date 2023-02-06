// VertexAnimation Project - Student Version
import java.io.*;
import java.util.*;

Camera myCamera = new Camera();

/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

// Create animations for interpolators
Animation cubeAnim;
ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();

void setup()
{
  size(1200, 800, P3D);
 
  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");

  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);  
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*====== Create Animations For Cubes ======*/
  cubeAnim = new Animation();
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one
  for (int i = 0; i < 4; i++) {
    cubeAnim.keyFrames.add(new KeyFrame());
    cubeAnim.keyFrames.get(i).time = 0.5 * (i + 1);
  }
  
  cubeAnim.keyFrames.get(0).points.add(new PVector(0, 0, 0));
  cubeAnim.keyFrames.get(1).points.add(new PVector(0, 0, 100));
  cubeAnim.keyFrames.get(2).points.add(new PVector(0, 0, 0));
  cubeAnim.keyFrames.get(3).points.add(new PVector(0, 0, -100));
  
  for (int i = 0; i < 11; i++) {
    cubes.add(new PositionInterpolator());
    cubes.get(i).SetAnimation(cubeAnim);
    cubes.get(i).Update(0.1 * i);
    if (i % 2 == 1)
      cubes.get(i).SetFrameSnapping(true);
  }
  
  /*====== Create Animations For Spheroid ======*/
  Animation spherePos = new Animation();
  // Create and set keyframes
  for (int i = 0; i < 4; i++) {
    spherePos.keyFrames.add(new KeyFrame());
    spherePos.keyFrames.get(i).time = i + 1;
  }
  
  spherePos.keyFrames.get(0).points.add(new PVector(-100, 0, 100));
  spherePos.keyFrames.get(1).points.add(new PVector(-100, 0, -100));
  spherePos.keyFrames.get(2).points.add(new PVector(100, 0, -100));
  spherePos.keyFrames.get(3).points.add(new PVector(100, 0, 100));
  
  spherePosition.SetAnimation(spherePos);
  

}

void draw()
{
  lights();
  background(0);
  DrawGrid();

  float playbackSpeed = 0.005f;

  // Implement your own camera
  myCamera.Update();

  /*====== Draw Forward Monster ======*/
  pushMatrix();
  translate(-40, 0, 0);
  monsterForward.fillColor = color(128, 200, 54);
  monsterForward.Update(playbackSpeed);
  shape(monsterForward.currentShape);
  popMatrix();
  
  /*====== Draw Reverse Monster ======*/
  pushMatrix();
  translate(40, 0, 0);
  monsterReverse.fillColor = color(220, 80, 45);
  monsterReverse.Update(-playbackSpeed);
  shape(monsterReverse.currentShape);
  popMatrix();
  
  /*====== Draw Snapped Monster ======*/
  pushMatrix();
  translate(0, 0, -60);
  monsterSnap.fillColor = color(160, 120, 85);
  monsterSnap.Update(playbackSpeed);
  shape(monsterSnap.currentShape);
  popMatrix();
  
  /*====== Draw Spheroid ======*/
  spherePosition.Update(playbackSpeed);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();
  
  /*====== Update and draw cubes ======*/
  // For each interpolator, update/draw
  pushMatrix();
  translate(-100, 0, 0);
  for (int i = 0; i < 11; i++) {
    noStroke();
    if (i % 2 == 1)
      fill(255, 255, 0);
    else
      fill(255, 0, 0);
    
    cubes.get(i).Update(playbackSpeed);
    PVector position = cubes.get(i).currentPosition;
    
    pushMatrix();
    translate(position.x, position.y, position.z);
    box(15);
    popMatrix();
    
    translate(20, 0, 0);
  }
  popMatrix();
}

void mouseDragged() {
  myCamera.Move((mouseX - pmouseX) * 0.15, (mouseY - pmouseY) * 0.15);
}

void mouseWheel(MouseEvent event)
{
  myCamera.Zoom(event.getCount());
}

// Create and return an animation object
Animation ReadAnimationFromFile(String fileName)
{
  Animation animation = new Animation();

  // The BufferedReader class will let you read in the file data
  try
  {
    BufferedReader reader = createReader(fileName);
    int keyFrames = Integer.parseInt(reader.readLine());
    int verticesPerFrame = Integer.parseInt(reader.readLine());
    float lastTime = 0;
    for (int i = 0; i < keyFrames; i++) {
      KeyFrame currentFrame = new KeyFrame();
      currentFrame.time = Float.parseFloat(reader.readLine());
      for (int j = 0; j < verticesPerFrame; j++) {
        String[] vertex = reader.readLine().split(" ");
        float x = Float.parseFloat(vertex[0]);
        float y = Float.parseFloat(vertex[1]);
        float z = Float.parseFloat(vertex[2]);
        currentFrame.points.add(new PVector(x, y, z));
      }
      lastTime = currentFrame.time;
      animation.keyFrames.add(currentFrame);
    }
  }
  catch (FileNotFoundException ex)
  {
    println("File not found: " + fileName);
  }
  catch (IOException ex)
  {
    ex.printStackTrace();
  }
 
  return animation;
}

void DrawGrid()
{
  // Draw the grid
  // Dimensions: 200x200 (-100 to +100 on X and Z)
  for (int x = -100; x <= 100; x += 10) {
    if (x == 0) // z-axis is blue
      stroke(0, 0, 255);
    else
      stroke(255);
    line(x, 0, -100, x, 0, 100);
  }
  for (int z = -100; z <= 100; z+= 10) {
    if (z == 0) // x-axis is red
      stroke(255, 0, 0);
    else
      stroke(255);
    line(-100, 0, z, 100, 0, z);
  }
}

class Camera {
  float radius;
  float phi;
  float theta;
  
  Camera() {
    radius = 130;
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
