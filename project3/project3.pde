Camera myCamera;
PShape monster;
PShape cube;
PShape triangleFan6;
PShape triangleFan20;

void setup() {
  size(1600, 1000, P3D);
  myCamera = new Camera();
  
  // load/create shapes
  myCamera.AddLookAtTarget(new PVector(0, 0, 0));    // half-scale monster
  myCamera.AddLookAtTarget(new PVector(75, 0, 0));   // wireframe monster
  monster = loadShape("monster.obj");
  monster.setStrokeWeight(1.0000001);
  monster.setFill(color(190, 230, 60));
  
  myCamera.AddLookAtTarget(new PVector(-100, 0, 0)); // cubes
  createCube();
  
  myCamera.AddLookAtTarget(new PVector(-50, 0, 0));  // triangle fans
  triangleFan6 = createTriangleFan(6);
  triangleFan20 = createTriangleFan(20);
}

void draw() {
  background(100);
  myCamera.Update();
  
  // draw grid
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
  
  // draw shapes
  pushMatrix(); // half-scale monster
  scale(1, -1, 1);
  scale(0.5, 0.5, 0.5);
  monster.setStroke(false);
  monster.setFill(true);
  shape(monster);
  popMatrix();
  
  pushMatrix(); // wireframe monster
  translate(75, 0, 0);
  scale(1, -1, 1);
  monster.setStroke(true);
  monster.setFill(false);
  shape(monster);
  popMatrix();
  
  pushMatrix(); // cubes
  translate(-100, 0, 0); // 1
  pushMatrix();
  scale(5, 5, 5);
  shape(cube);
  popMatrix();
  pushMatrix();          // 2
  translate(-10, 0, 0);
  shape(cube);
  popMatrix();
  pushMatrix();          // 3
  translate(10, 0, 0);
  scale(10, 20, 10);
  shape(cube);
  popMatrix();
  popMatrix();
  
  pushMatrix(); // triangle fans
  translate(-50, 0, 0);
  pushMatrix();
  translate(15, -10, 0);
  shape(triangleFan6);
  popMatrix();
  pushMatrix();
  translate(-15, -10, 0);
  shape(triangleFan20);
  popMatrix();
  popMatrix();
}

void keyPressed() {
  if (key == 32)
  myCamera.CycleTarget();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  myCamera.Zoom(e);
}

class Camera {
  ArrayList<PVector> targets;
  int currentTarget;
  float radius;
  
  Camera() {
    perspective(radians(50.0f), width/(float)height, 0.1, 1000);
    targets = new ArrayList<PVector>();
    currentTarget = 0;
    radius = 115;
  }
  void Update() {
    PVector target = targets.get(currentTarget);
    
    float phi = radians(map(mouseX, 0, width - 1, 0, 360));
    float theta = radians(map(mouseY, 0, height - 1, 1, 179));
    
    float derivedX = radius * cos(phi) * sin(theta);
    float derivedY = radius * cos(theta);
    float derivedZ = radius * sin(theta) * sin(phi);
    
    float positionX = target.x + derivedX;
    float positionY = target.y + derivedY;
    float positionZ = target.z + derivedZ;
    
    camera(positionX, positionY, positionZ, target.x, target.y, target.z, 0, 1, 0);
  }
  void AddLookAtTarget(PVector target) {
    targets.add(target);
  }
  void CycleTarget() {
    if (currentTarget == targets.size() - 1)
      currentTarget = 0;
    else
      currentTarget++;
  }
  void Zoom(float f) {
    radius += f * 5;
    if (radius < 30)
      radius = 30;
    else if (radius > 200)
      radius = 200;
  }
}

void createCube() {
  cube = createShape();
  cube.setStroke(false);
  cube.beginShape(TRIANGLE);
  cube.fill(255, 255, 0);
  cube.vertex(0.5, 0.5, 0.5);
  cube.vertex(-0.5, 0.5, 0.5);
  cube.vertex(-0.5, -0.5, 0.5);
  cube.fill(0, 255, 0);
  cube.vertex(0.5, 0.5, 0.5);
  cube.vertex(0.5, -0.5, 0.5);
  cube.vertex(-0.5, -0.5, 0.5);
  cube.fill(180, 180, 150);
  cube.vertex(-0.5, 0.5, 0.5);
  cube.vertex(-0.5, -0.5, 0.5);
  cube.vertex(-0.5, -0.5, -0.5);
  cube.fill(0, 0, 200);
  cube.vertex(-0.5, 0.5, 0.5);
  cube.vertex(-0.5, 0.5, -0.5);
  cube.vertex(-0.5, -0.5, -0.5);
  cube.fill(160, 209, 182);
  cube.vertex(-0.5, -0.5, -0.5);
  cube.vertex(-0.5, -0.5, 0.5);
  cube.vertex(0.5, -0.5, 0.5);
  cube.fill(247, 107, 0);
  cube.vertex(0.5, -0.5, 0.5);
  cube.vertex(0.5, -0.5, -0.5);
  cube.vertex(-0.5, -0.5, -0.5);
  cube.fill(255, 60, 40);
  cube.vertex(0.5, 0.5, 0.5);
  cube.vertex(0.5, -0.5, 0.5);
  cube.vertex(0.5, -0.5, -0.5);
  cube.fill(75, 129, 200);
  cube.vertex(0.5, 0.5, 0.5);
  cube.vertex(0.5, 0.5, -0.5);
  cube.vertex(0.5, -0.5, -0.5);
  cube.fill(255, 0, 0);
  cube.vertex(0.5, 0.5, 0.5);
  cube.vertex(0.5, 0.5, -0.5);
  cube.vertex(-0.5, 0.5, -0.5);
  cube.fill(255, 0, 255);
  cube.vertex(0.5, 0.5, 0.5);
  cube.vertex(-0.5, 0.5, 0.5);
  cube.vertex(-0.5, 0.5, -0.5);
  cube.fill(160, 60, 180);
  cube.vertex(-0.5, -0.5, -0.5);
  cube.vertex(0.5, -0.5, -0.5);
  cube.vertex(0.5, 0.5, -0.5);
  cube.fill(0, 128, 196);
  cube.vertex(0.5, 0.5, -0.5);
  cube.vertex(-0.5, 0.5, -0.5);
  cube.vertex(-0.5, -0.5, -0.5);
  cube.endShape();
}

PShape createTriangleFan(int numOfSegments) {
  PShape triangleFan = createShape();
  triangleFan.beginShape(TRIANGLE_FAN);
  for (int i = 0; i < numOfSegments; i++) {
    colorMode(HSB, numOfSegments, 1, 1);
    triangleFan.fill(color(i, 1, 1));
    float x = 10 * cos(radians(i * 360 / numOfSegments));
    float y = 10 * sin(radians(i * 360 / numOfSegments));
    triangleFan.vertex(x, y, 0);
  }
  colorMode(RGB, 255, 255, 255);
  triangleFan.endShape();
  return triangleFan;
}
