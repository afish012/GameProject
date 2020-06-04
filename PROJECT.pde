
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
  size(750,750);
  frameRate(60);
  ellipseMode(CENTER);
  
  game = new Game();
  menuChoice = new MenuScreen();
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
  
  flames.add(loadImage("assets/flame1.png"));
  flames.add(loadImage("assets/flame2.png"));
  flames.add(loadImage("assets/flame3.png"));
  ///
}

void draw() {
  displayCurrentView();
}

void mouseReleased() {
  buttonUsable = true;
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
  if (key == ' ') {
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
