class Game {
  final int flameChange = 30; //variables for displaying the animated flames
  int flameCounter, currentFlame = 0;
  final int nFlames = 3;
  
  ArrayList<Platform> platformList; //list to hold the array of platforms created by the generator
  
  Player player; //game has a player object
  
  Generator generator; //game has a generator object
  
  Game() { //when created, creates a new player and sets the generator's reference player to that player
    this.player = new Player();
    this.generator = new Generator(this.player);
  }
  
  void init(int seed, int difficulty) { //call this to remake the game with a set seed and difficulty
    this.platformList = this.generator.createLevel(seed,difficulty); //uses the generator to remake the level list
    this.player.setPos(this.player.playerWidth / 2, 0); //reset the position of the player
  }
  
  void displayPlatforms() { //goes through each platform in the list and calls it's display function
    for (Platform platform : this.platformList) {
      platform.display(this.player.pos.x);
    }
  }
  
  void update() {
    this.flameCounter++; //code responsible for updating the animated flame - will cycle through the 3 frames imported in setup()
    
    if (this.flameCounter >= this.flameChange) {
      this.flameCounter = 0;
      this.currentFlame++;
      if (this.currentFlame >= this.nFlames) {
        this.currentFlame = 0;
      }
    }
    
    this.player.update(this.platformList); //calls the player's update function on the current level
  }
  
  void display() {
    background(gameBG); //uses the game background defined in setup()
    image(flames.get(this.currentFlame), 0, 0); //adds the animated flames to the background
    push();
    translate((width / 2) - this.player.pos.x, (height / 2) - this.player.pos.y + this.player.playerHeight / 2 + 75); //translates to the players location
    this.displayPlatforms(); //displays all the platforms
    this.player.display(); //displays the player
    pop();
  }
  
}
