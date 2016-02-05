
float screenDiagonal = 0;
PVector axis = new PVector(1, 0);
PVector cam = new PVector(100, 100);
float angle = 0;

void setup(){
  size(600, 400);
  screenDiagonal = sqrt(width * width + height * height);
}

void draw(){
  background(0);
  moveAxes();
  drawAxes();
  Keys.update();
}
void moveAxes() {
  if(mousePressed) {
    if(Keys.isDown(Keys.SPACE)){
      cam.add(new PVector(mouseX - pmouseX, mouseY - pmouseY));
    } else {
      angle += .01;
      axis = PVector.fromAngle(angle);
    }
  }
}

void drawAxes(){
  pushMatrix();
  translate(cam.x, cam.y);
  PVector p1 = PVector.mult(axis, screenDiagonal);
  PVector p2 = PVector.mult(axis, -screenDiagonal);
  
  stroke(64);
  strokeWeight(1);
  line(-width, 0, width, 0);
  line(0, -height, 0, height);
  stroke(255);
  strokeWeight(2);
  line(p1.x, p1.y, p2.x, p2.y);
  popMatrix();
}