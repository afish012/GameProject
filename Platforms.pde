class Platform { //class for each platform in the game area

  PVector pos; // (x,y) position with a set width
  float platformWidth;
  
  color baseColor; //color of the platform
  color hitboxColor;
  
  void setColor() { //set color function for the base platform
    this.baseColor = color(83,111,122);
    this.hitboxColor = color(142,189,206);
  }
  
  Platform(float x, float y, float w) { //instantiate with a position and width
    this.pos = new PVector(x,y);
    this.platformWidth = w;
    this.setColor(); //set the color
  }
  
  boolean isStart() { return false; } //functions to return the state of the platform - start platform is unused but end platform is critical
  boolean isFinish() {return false; }
  
  void display(float playerX) { //displays the platform
  
    //find where the platform is in relation to the player - only display it if the player is near
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

class StartPlatform extends Platform { //start platform and end platform are the same as platform, except they display different colors and return different values for the start and end checks
  
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
