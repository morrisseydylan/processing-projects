abstract class Interpolator
{
  Animation animation;
  
  // Where we at in the animation?
  float currentTime = 0;
  
  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;
  
  void SetAnimation(Animation anim)
  {
    animation = anim;
  }
  
  void SetFrameSnapping(boolean snap)
  {
    snapping = snap;
  }
  
  void UpdateTime(float time)
  {
    // Check to see if the time is out of bounds (0 / Animation_Duration)
    // If so, adjust by an appropriate amount to loop correctly
    currentTime += time;
    if (currentTime > animation.GetDuration())
      currentTime -= animation.GetDuration();
    else if (currentTime < 0)
      currentTime = animation.GetDuration() - currentTime;
  }
  
  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator
{
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;
  
  // Changing mesh colors
  color fillColor;
  
  PShape GetShape()
  {
    return currentShape;
  }
  
  void Update(float time)
  {
    UpdateTime(time);
    // TODO: Create a new PShape by interpolating between two existing key frames
    // using linear interpolation
    
    // Find index of current key frame
    int index = animation.keyFrames.size() - 1;
    for (int i = 0; i < animation.keyFrames.size(); i++) {
      if (animation.keyFrames.get(i).time < currentTime)
        index = i;
    }
    
    currentShape = createShape();
    currentShape.beginShape(TRIANGLES);
    currentShape.fill(fillColor);
    currentShape.noStroke();
    
    if (snapping) {
      KeyFrame currentKeyFrame = animation.keyFrames.get(index);
      for (int i = 0; i < currentKeyFrame.points.size(); i++) {
        PVector vertex = currentKeyFrame.points.get(i);
        currentShape.vertex(vertex.x, vertex.y, vertex.z);
      }
    }
    else {
      KeyFrame previousKeyFrame = animation.keyFrames.get(index);
      index++;
      if (index == animation.keyFrames.size())
        index = 0;
      KeyFrame nextKeyFrame = animation.keyFrames.get(index);
      
      float timeRatio = (currentTime - previousKeyFrame.time) / (nextKeyFrame.time - previousKeyFrame.time);
      if (timeRatio > 1)
        timeRatio = currentTime / nextKeyFrame.time;
      
      for (int i = 0; i < previousKeyFrame.points.size(); i++) {
        PVector vertex1 = previousKeyFrame.points.get(i);
        PVector vertex2 = nextKeyFrame.points.get(i);
        float x = (vertex2.x - vertex1.x) * timeRatio + vertex1.x;
        float y = (vertex2.y - vertex1.y) * timeRatio + vertex1.y;
        float z = (vertex2.z - vertex1.z) * timeRatio + vertex1.z;
        currentShape.vertex(x, y, z);
      }
    }
    currentShape.endShape();
  }
}

class PositionInterpolator extends Interpolator
{
  PVector currentPosition;
  
  void Update(float time)
  {
    UpdateTime(time);
    // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point
    
    // Find index of current key frame
    int index = animation.keyFrames.size() - 1;
    for (int i = 0; i < animation.keyFrames.size(); i++) {
      if (animation.keyFrames.get(i).time < currentTime)
        index = i;
    }
    
    if (snapping) {
      currentPosition = animation.keyFrames.get(index).points.get(0);
    }
    else {
      KeyFrame previousKeyFrame = animation.keyFrames.get(index);
      index++;
      if (index == animation.keyFrames.size())
        index = 0;
      KeyFrame nextKeyFrame = animation.keyFrames.get(index);
      
      float timeRatio = (currentTime - previousKeyFrame.time) / (nextKeyFrame.time - previousKeyFrame.time);
      if (timeRatio > 1)
        timeRatio = currentTime / nextKeyFrame.time;
      
      PVector vertex1 = previousKeyFrame.points.get(0);
      PVector vertex2 = nextKeyFrame.points.get(0);
      float x = (vertex2.x - vertex1.x) * timeRatio + vertex1.x;
      float y = (vertex2.y - vertex1.y) * timeRatio + vertex1.y;
      float z = (vertex2.z - vertex1.z) * timeRatio + vertex1.z;
      
      currentPosition = new PVector(x, y, z);
    }
  }
}
