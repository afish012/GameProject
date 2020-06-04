class Game {
  final int flameChange = 30;
  int flameCounter, currentFlame = 0;
  final int nFlames = 3;
  
  ArrayList<Platform> platformList;
  
  Player player;
  
  Generator generator;
  
  Game() {
    this.player = new Player();
    this.generator = new Generator(this.player);
  }
  
  void init(int seed, int difficulty) { //call this to remake the game with a set seed
    this.platformList = this.generator.createLevel(seed,difficulty);
    this.player.setPos(this.player.playerWidth / 2, 0);
  }
  
  void displayPlatforms() {
    for (Platform platform : platformList) {
      platform.display(this.player.pos.x);
    }
  }
  
  void update() {
    flameCounter++;
    
    if (flameCounter >= flameChange) {
      flameCounter = 0;
      currentFlame++;
      if (currentFlame >= nFlames) {
        currentFlame = 0;
      }
    }
    
    this.player.update(platformList);
  }
  
  void display() {
    background(gameBG);
    image(flames.get(currentFlame), 0, 0);
    push();
    translate((width / 2) - this.player.pos.x, (height / 2) - this.player.pos.y + this.player.playerHeight / 2 + 75);
    this.displayPlatforms();
    this.player.display();
    pop();
  }
  
}
