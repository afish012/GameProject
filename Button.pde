class Button {
  PVector pos;
  float diameter;
  String message;
  
  Button(float _x, float _y, float _diameter, String _message) {
    this.pos = new PVector(_x, _y);
    this.diameter = _diameter;
    this.message = _message;
  }
  
  void setPos(float _x, float _y) {
    this.pos = new PVector(_x, _y);
  }
  
  void display() {
    push();
    textAlign(CENTER);
    stroke(40);
    strokeWeight(3);
    fill(100);
    if (sqrt(sq(this.pos.x - mouseX) + sq(this.pos.y - mouseY)) < this.diameter / 2) {
      fill(120);
    }
    circle(this.pos.x, this.pos.y, this.diameter);
    fill(255);
    textSize(this.diameter / this.message.length());
    text(this.message, this.pos.x, this.pos.y);
    pop();
  }
  
  boolean pressed() {
    if (sqrt(sq(this.pos.x - mouseX) + sq(this.pos.y - mouseY)) < this.diameter / 2 && mousePressed && buttonUsable) {
      buttonUsable = false;
      return true;
    }
    
    return false;
  }
}
