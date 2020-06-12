class Button {
  PVector pos; //position of the button
  float diameter; //diameter of the button
  String message; //message inside the button
  
  Button(float _x, float _y, float _diameter, String _message) {
    this.pos = new PVector(_x, _y);
    this.diameter = _diameter;
    this.message = _message;
  }
  
  void setPos(float _x, float _y) { //only used for debug - allows for moving the buttons
    this.pos = new PVector(_x, _y);
  }
  
  void display() {
    push();
    textAlign(CENTER);
    stroke(40);
    strokeWeight(3);
    fill(100); //draw the button with a lighter fill if the mouse is over it
    if (sqrt(sq(this.pos.x - mouseX) + sq(this.pos.y - mouseY)) < this.diameter / 2) {
      fill(120);
    }
    circle(this.pos.x, this.pos.y, this.diameter); //draw a circle with the set location and dimensions
    fill(255);
    textSize(this.diameter / this.message.length()); //set the text size according to the buttons size
    text(this.message, this.pos.x, this.pos.y); //write the text in the middle of the button
    pop();
  }
  
  boolean pressed() { //returns true when the button is pressed. Will only return true on one frame, as the buttonUsable flag gets triggered
    if (sqrt(sq(this.pos.x - mouseX) + sq(this.pos.y - mouseY)) < this.diameter / 2 && mousePressed && buttonUsable) {
      buttonUsable = false;
      return true;
    }
    
    return false;
  }
}
