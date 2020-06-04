class Platform { //class for each platform in the game area

  PVector pos; // (x,y) position with a set width
  float platformWidth;
  
  color baseColor;
  color hitboxColor;
  
  void setColor() {
    this.baseColor = color(83,111,122);
    this.hitboxColor = color(142,189,206);
  }
  
  Platform(float x, float y, float w) { //instantiate with a position and width, and a type (0 default, 1 start, 2 end)
    this.pos = new PVector(x,y);
    this.platformWidth = w;
    this.setColor();
  }
  
  boolean isStart() { return false; }
  boolean isFinish() {return false; }
  
  void display(float playerX) { //displays the platform
    float dist1 = this.pos.x - playerX;
    float dist2 = this.pos.x + this.platformWidth - playerX;
    if (dist1 < 0) {
      dist1 *= -1;
    }
    if (dist2 < 0) {
      dist2 *= -1;
    }
    
    //check if the platform is on screen or the player is on the platform
    if (dist1 < width/2 || dist2 < width/2 || (this.pos.x < playerX && this.pos.x + this.platformWidth > this.pos.x)) {
      push();
      stroke(this.baseColor);
      fill(this.baseColor);
      rect(this.pos.x, this.pos.y, this.platformWidth, 30);
      
      stroke(this.hitboxColor);
      fill(this.hitboxColor);
      rect(this.pos.x, this.pos.y, this.platformWidth, 5);
      
      pop();
    }
  }
  
}

class StartPlatform extends Platform {
  
  StartPlatform(float x, float y, float w) {
    super(x,y,w);
  }
  
  void setColor() {
    super.baseColor = color(42,145,79);
    super.hitboxColor = color(83,217,122);
  }
  
  boolean isStart() { return true; }
  boolean isFinish() {return false; }
  
  
}

class EndPlatform extends Platform {
  
  EndPlatform(float x, float y, float w) {
    super(x,y,w);
  }

  void setColor() {
    super.baseColor = color(228,55,79);
    super.hitboxColor = color(221,101,122);
  }
  
  boolean isStart() { return false; }
  boolean isFinish() {return true; }
  
  
}
