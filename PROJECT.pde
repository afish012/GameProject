
Game game; //game is responsible for drawing the game space and the logic behind it

PImage gameBG;
PImage playerLeftMove;
PImage playerRightMove;
PImage playerStop;

ArrayList<PImage> flames = new ArrayList<PImage>();

boolean keyJump = false; //input keys
boolean jumpOnce = true; //store a value that will be used to make sure the player only jumps once per jump key held and released
                         //if this check was not done, the player could hold space and jump automatically upon landing

boolean buttonUsable = true;

int keyLeft = 0; //integers, as if both keys are pressed, they cancel out
int keyRight = 0;

Button playOne;

void setup() {
  size(750,750); //size of game is 750 by 750 pixels
  frameRate(60); //set framerate to 60
  ellipseMode(CENTER); //set mode for drawing circles to center
  
  game = new Game(); //instantiate the game object, used for drawing and updating the player and the level
  menuChoice = new MenuScreen(); //instantiation of all the screens that are used
  singleGameSelectChoice = new SingleGameSelectScreen();
  singleGamePlayChoice = new SingleGamePlayScreen();
  singleGameEndChoice = new SingleGameEndScreen();
  multiGameSelectChoice = new MultiGameSelectScreen();
  multiGamePlayChoice = new MultiGamePlayScreen();
  multiGameEndChoice = new MultiGameEndScreen();
  
  ///load assets from folder
  gameBG = loadImage("assets/bg.png");
  playerLeftMove = loadImage("assets/playerLeftMove.png");
  playerRightMove = loadImage("assets/playerRightMove.png");
  playerStop = loadImage("assets/playerStop.png");
  
  //add the flames to the array - to be cycled through to give animated effect
  flames.add(loadImage("assets/flame1.png"));
  flames.add(loadImage("assets/flame2.png"));
  flames.add(loadImage("assets/flame3.png"));
  ///
}

void draw() {
  displayCurrentView(); //use the display function defined in Screens to draw to the canvas
}

void mouseReleased() {
  buttonUsable = true; //when the mouse is released, set the button flag to true - used in the Button class
}

void keyPressed() { //upon pressing the key, the state is set to true - this is to allow for multiple keys being pressed at the same time
  if (key == ' ') {
    keyJump = true;
  }
  if (key == 'a' || key == LEFT) {
    keyLeft = -1;
  }
  if (key == 'd' || key == RIGHT) {
    keyRight = 1;
  }
}

void keyReleased() {
  if (key == ' ') { //jump key
    keyJump = false;
    jumpOnce = true;
  }
  if (key == 'a' || key == LEFT) {
    keyLeft = 0;
  }
  if (key == 'd' || key == RIGHT) {
    keyRight = 0;
  }
}
