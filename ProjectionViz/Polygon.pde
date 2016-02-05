class Polygon
{
  private boolean colliding = false;
  private boolean doneCheckingPoints = false;
  private boolean dirty = true;
  
  private ArrayList<PVector> points = new ArrayList<PVector>();
  private PVector[] pointsTransformedToArray;
  private PVector[] normals;
  
  AABB aabb = new AABB();
  
  private float rotation = 0;
  private float scale = 0;
  private PVector position = new PVector(0, 0);
  
  public float getScale()
  {
    return scale;
  }
  
  public float getRotation()
  {
    return rotation;
  }
  
  public PVector getPosition()
  {
    return position.copy();
  }
  
  public void setScale(float value)
  {
    scale = value;
    dirty = true;
  }
  
  public void setRotation(float value)
  {
    rotation = value;
    dirty = true;
  }
  
  public void setPosition(PVector vector)
  {
    position = vector.copy();
    dirty = true;
  }
  
  void update()
  {
    doneCheckingPoints = false;
    colliding = false;
    aabb.resetColliding();
    if(dirty) recalc();
  }
  
  void recalc()
  {
    dirty = false;
    PMatrix2D matrix = new PMatrix2D();
    matrix.translate(position.x, position.y);
    matrix.rotate(rotation);
    matrix.scale(scale);
    
    pointsTransformedToArray = new PVector[points.size()];
    for (int i = 0; i < points.size(); i++)
    {
      PVector vector = new PVector();
      matrix.mult(points.get(i), vector);
      pointsTransformedToArray[i] = vector;
    }
    
    normals = new PVector[pointsTransformedToArray.length];
    for (int i = 0; i < pointsTransformedToArray.length; i++)
    {
      int j = (i == pointsTransformedToArray.length - 1 ? 0 : i + 1);
      PVector firstPoint = pointsTransformedToArray[i];
      PVector secondPoint = pointsTransformedToArray[j];
      PVector edge = PVector.sub(secondPoint, firstPoint);
      
      PVector normal = new PVector(-edge.y, edge.x);
      normals[i] = normal.normalize();
    }
    aabb.recalc(pointsTransformed);
  }
  
  void draw()
  {
    noStroke();
    fill(255);
    //if (colliding) fill(255, 0, 0);
    
    beginShape();
    for (int i = 0; i < pointsTransformedToArray.length; i++)
    {
      vertex(pointsTransformedToArray[i].x, pointsTransformedToArray[i].y);
    }
    endShape();
    
    aabb.draw();
  }
  
  void addPoint(PVector vector)
  {
    addPoint(vector.x, vector.y);
  }
  
  void addPoint(float x, float y)
  {
    points.add(new PVector(x, y));
  }
  
  void checkCollisions(ArrayList<Polygon> shapes)
  {
    for (Polygon polygon : shapes)
    {
      if (polygon == this) continue;
      if (polygon.doneCheckingPoints == true) continue;
      if (checkCollision(polygon))
      {
        colliding = true;
        polygon.colliding = true;
      }
    }
    doneCheckingPoints = true;
  }
  
  boolean checkCollision(Polygon polygon)
  {
    if (aabb.checkCollision(polygon.aabb))
    {
      for (PVector normal : normals)
      {
        MinMax firstMinMax = this.projectAlongAxis(normal);
        MinMax secondMinMax = polygon.projectAlongAxis(normal);
        if (firstMinMax.min > secondMinMax.max) return false;
        if (secondMinMax.min > firstMinMax.max) return false;
      }
      return true;
    }
    return false;
  }
  
  MinMax projectAlongAxis(PVector normalAxis)
  {
    float min = 0, max = 0;
    
    int i = 0;
    for (PVector point : pointsTransformedToArray)
    {
      float distanceAlongAxis = point.dot(normalAxis);
      if (i == 0 || distanceAlongAxis < min) min = distanceAlongAxis;
      if (i == 0 || distanceAlongAxis > max) max = distanceAlongAxis;
      i++;
    }
    return new MinMax(min, max);
  }
}