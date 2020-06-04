
//this wonderful function was written by Jeffrey Thompson at http://www.jeffreythompson.org/collision-detection/line-line.php
boolean collides(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float u1 = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float u2 = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  // if uA and uB are between 0-1, lines are colliding
  if (u1 >= 0 && u1 <= 1 && u2 >= 0 && u2 <= 1) {
    return true;
  }
  return false;
}

//modifying the function so it returns the location of the intersect on the line x1,y1 x2,y2
//to be used in the generator to determine where to place a platform - line1 will be the direction vector
PVector collidePoint(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float u1 = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  return new PVector(x1 + (u1 * (x2-x1)), y1 + (u1 * (y2-y1)));
}
