class Slider {
  
  PVector sliderPos; //container pos and dimensions
  float sliderWidth;
  float sliderHeight;
  
  float buttonX; //button that will move pos and dimensions
  float buttonWidth;
  float buttonXMax; //the button can move from the slider pos x to the slider pos x + slider width - button width (within the bounds of the container)
  
  int v; //value that changes depending on the position of the slider
  int vMin;
  int vMax;
  
  Slider(float x, float y, float sW, float sH, float bW, int minValue, int maxValue) {
    this.sliderPos = new PVector(x,y);
    this.sliderWidth = sW; 
    this.sliderHeight = sH;
    this.buttonWidth = bW;
    this.buttonX = x;
    this.buttonXMax = x + sW - bW;
    this.v = 0;
    this.vMin = minValue;
    this.vMax = maxValue;
  }
  
  void setValue() { //value is set to the percentage of the distance of the button along the slider mapped to the minimum and maximum values
    this.v = int(map(this.buttonX - this.sliderPos.x, 0, this.buttonXMax - this.sliderPos.x, this.vMin, this.vMax));
  }
  
  int getValue() {
    return this.v;
  }
  
  void update() {
    if (mousePressed && mouseX > this.buttonX && mouseX < this.buttonX + this.buttonWidth && mouseY > this.sliderPos.y && mouseY < this.sliderPos.y + this.sliderHeight) {
      this.buttonX = mouseX - this.buttonWidth/2; //if the mouse is over the button and the mouse button is held down, the button moves to center itself over the mouse
    }
    
    if (this.buttonX > this.buttonXMax) {
      this.buttonX = this.buttonXMax; //sets the limits of movement for the button
    }
    
    if (this.buttonX < this.sliderPos.x) {
      this.buttonX = this.sliderPos.x;
    }
    
    this.setValue();
  }
  
  void display() {
    
    push();
    strokeWeight(1);
    fill(255,0,0);
    stroke(255,0,0);
    rect(this.sliderPos.x, this.sliderPos.y, this.buttonX - this.sliderPos.x, this.sliderHeight); //display a red rectangle for the slider bar to the left of the button
    
    fill(0,255,0);
    stroke(0,255,0);
    //display a green rectangle for the slider bar to the right of the button
    rect(this.buttonX + this.buttonWidth, this.sliderPos.y, (this.sliderPos.x + this.sliderWidth) - (this.buttonX + this.buttonWidth), this.sliderHeight);
    
    fill(220);
    stroke(220);
    if (mouseX > this.buttonX && mouseX < this.buttonX + this.buttonWidth && mouseY > this.sliderPos.y && mouseY < this.sliderPos.y + this.sliderHeight) {
      fill(255);
      stroke(255); //if the mouse is hovered over the button, set it to a lighter color
    }
    rect(this.buttonX, this.sliderPos.y, this.buttonWidth, this.sliderHeight);
    
    pop();
  }
  
}
