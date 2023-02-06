class Scene
{
  // TODO: Write this class!
  /*
    Things you'll need:
    Some way to store PShapes and their positions
    Some way to store lights--position plus color for the pointLight() function
    Other classes may be helpful here
    A background color for the scene
  */
  
  int numOfShapes;
  IntList shapeColors;
  ArrayList<PVector> shapeLocations;
  ArrayList<PShape> shapes;
  
  int numOfLights;
  IntList lightColors;
  ArrayList<PVector> lightLocations;
  
  color background;
  
  Scene(String file) {
    BufferedReader reader = createReader("scenes/" + file + ".txt");
    try
    {
      // Example: Get an entire line from the file
      // What you do with this line after is up to you
      String rgb[] = reader.readLine().split(",");
      background = color(int(rgb[0]), int(rgb[1]), int(rgb[2]));
      
      numOfShapes = int(reader.readLine());
      shapeColors = new IntList();
      shapeLocations = new ArrayList<PVector>();
      shapes = new ArrayList<PShape>();
      for (int i = 0; i < numOfShapes; i++) {
        String shapeLine[] = reader.readLine().split(",");
        shapes.add(loadShape("models/" + shapeLine[0] + ".obj"));
        shapeLocations.add(new PVector(int(shapeLine[1]), int(shapeLine[2]), int(shapeLine[3])));
        shapeColors.append(color(int(shapeLine[4]), int(shapeLine[5]), int(shapeLine[6])));
      }
      
      numOfLights = int(reader.readLine());
      lightColors = new IntList();
      lightLocations = new ArrayList<PVector>();
      for (int i = 0; i < numOfLights; i++) {
        String lightLine[] = reader.readLine().split(",");
        lightLocations.add(new PVector(int(lightLine[0]), int(lightLine[1]), int(lightLine[2])));
        lightColors.append(color(int(lightLine[3]), int(lightLine[4]), int(lightLine[5])));
      }
    }
      catch (IOException e)
      {
       // In case something went wrong during the process
       e.printStackTrace();
    }
  }
  void DrawScene() {
    // TODO: Draw all the information in this scene
    /*
      Just like using draw() with a regular sketch, things you would need to do
      Clear the screen with background()
      Set up any lights in this scene
      Draw each object in the correct location
    */
    background(background);
    
    for (int i = 0; i < numOfLights; i++) {
      color currentColor = lightColors.get(i);
      PVector location = lightLocations.get(i);
      pointLight(red(currentColor), green(currentColor), blue(currentColor), location.x, location.y, location.z);
    }
    
    for (int i = 0; i < numOfShapes; i++) {
      color currentColor = shapeColors.get(i);
      PVector location = shapeLocations.get(i);
      shapes.get(i).setFill(currentColor);
      pushMatrix();
      translate(location.x, location.y, location.z);
      shape(shapes.get(i));
      popMatrix();
    }
  }
  int GetShapeCount() {
    return numOfShapes;
  }
  int GetLightCount() {
    return numOfLights;
  }
}
