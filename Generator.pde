class Generator {
  
  final int softWidthCap = 4000; //stop attempting to place platforms here/place the finish platform here
  final float angleLimitUp = radians(-85);
  final float angleMinUp = radians(-10);
  final float angleLimitDown = radians(65);
  final float angleMinDown = radians(10);
  final int iterations = 1000;
  final int dirStretch = 50000;
  
  Player referencePlayer; //generator relies heavily on constraints invoked on the player class, so we need a reference to it
  PVector dir;
  float platformWidthLimit;
  
  
  Generator (Player player) {
    this.referencePlayer = player; //pass the player that is going to be controlled
    this.dir = PVector.fromAngle(map(noise(0), 0, 1, this.angleLimitUp, this.angleLimitDown)); //set dir to a random angle between the limits
    this.platformWidthLimit = this.referencePlayer.playerWidth * 5;
  }
  
  
  ///BEGIN FUNCTIONS FOR EMULATING PLAYER
  
  ArrayList<PVector> predictPath(float x, float y, float predictedXVel, int n) { //takes a point, and the possible velocity of the player at that point, and predicts where the player will be after n iterations
    ArrayList<PVector> path = new ArrayList<PVector>(); //to store each step
    
    PVector step = new PVector(x,y);
    PVector newVel = new PVector(predictedXVel, -this.referencePlayer.termVelVertical);
    
    for (int i = 0; i < n; i++) {
      //note - add() is a function for both the pvector and arraylist classes, which can get slightly confusing!
      path.add(step.copy()); //add the initial starting point to the path
      
      //this block of code is determining the acceleration to apply to the velocity, using the same logic as in the players update function.
      float nAccVertical = this.referencePlayer.accPlayerDown;
      if (newVel.y < 0) {
        nAccVertical = this.referencePlayer.accPlayerUp;
      }
      
      
      //assume the player is travelling left to right always
      newVel.add(this.referencePlayer.accHorizontal, nAccVertical);
      this.referencePlayer.limitVel(newVel); //use the reference players limit velocity function to limit the newVel vector to the same constraints
      
      step.add(newVel);
    }
    
    
    return path;
  }
  
  float predictVelocity(float startX, float endX, float initialXVel) { //predict the maxmimum velocity the player can reach along a platform
    PVector step = new PVector(startX, 0); //move the point until it reaches endX. using vectors for simplicitiy's sake
    PVector newVel = new PVector(initialXVel, 0); //going to apply horizontal acceleration to this vector
    
    while (step.x < endX) {
      newVel.add(this.referencePlayer.accHorizontal, 0);
      this.referencePlayer.limitVel(newVel);
      step.add(newVel);
    }
    //EXPERIMENTAL
    //if (step.x - endX < this.referencePlayer.playerWidth / 2) { //the step is going to have overstepped the platform
    //  return newVel.x; //if the player is still able to jump off the platform, that is fine
    //}
    
    return newVel.x - this.referencePlayer.accHorizontal; //return the velocity found before the player overstepped the endX
  }
  
  ///END FUNCTIONS FOR EMULATING PLAYER
  
  //void applyNoise(float xPos) { //apply noise to the direction vector at the specified x
  //  float noiseToAngle = map(noise(xPos), 0, 1, angleLimitUp - dir.heading(), angleLimitDown - dir.heading());
  //  dir.rotate(noiseToAngle);
  //}
  
  void setAngleAt(float xPos, float angleUp, float angleDown) { //apply noise to the direction vector at the specified x within the specified bounds
    this.dir = PVector.fromAngle(map(noise(xPos), 0, 1, angleUp, angleDown));
  }
  
  ArrayList<Platform> createLevel(int seed, int difficulty) {
    
    noiseSeed(seed);
    
    ArrayList<Platform> newLevel = new ArrayList<Platform>();
    float setSize = this.platformWidthLimit * map(difficulty, 0, 100, 1, 0.3); //variable to set length of platform
    
    int n = 0;
    float xVelAcrossPlatform = 0;
    ArrayList<PVector> jumpPath;
    
    float angleUp = map(difficulty, 0, 100, this.angleMinUp, this.angleLimitUp);
    float angleDown = map(difficulty, 0, 100, this.angleMinDown, this.angleLimitDown);
    
    //begin by placing a start platform beginning at 0,0
    newLevel.add(new StartPlatform(0,0, setSize));
    this.setAngleAt(setSize + (this.referencePlayer.playerWidth / 2), angleUp, angleDown);
    
    while (newLevel.get(n).pos.x < this.softWidthCap) { //while the most recent platform is below the level cap
      xVelAcrossPlatform = this.predictVelocity(newLevel.get(n).pos.x - (this.referencePlayer.playerWidth / 2), newLevel.get(n).pos.x + newLevel.get(n).platformWidth + (this.referencePlayer.playerWidth / 2), xVelAcrossPlatform);
      jumpPath = predictPath(newLevel.get(n).pos.x + newLevel.get(n).platformWidth + (this.referencePlayer.playerWidth / 2), newLevel.get(n).pos.y, xVelAcrossPlatform, this.iterations);
      jumpPath.remove(0);
      
      float x1 = newLevel.get(n).pos.x + newLevel.get(n).platformWidth + (this.referencePlayer.playerWidth / 2);
      float y1 = newLevel.get(n).pos.y;
      float x2 = newLevel.get(n).pos.x + newLevel.get(n).platformWidth + (this.referencePlayer.playerWidth / 2) + this.dir.x * this.dirStretch;
      float y2 = newLevel.get(n).pos.y + this.dir.y * this.dirStretch;
      
      for (int i = 0; i < jumpPath.size() - 1; i++) {
        
        float x3 = jumpPath.get(i).x;
        float y3 = jumpPath.get(i).y;
        float x4 = jumpPath.get(i+1).x;
        float y4 = jumpPath.get(i+1).y;
        
        if (collides(x1, y1, x2, y2, x3, y3, x4, y4)) {
          PVector collidesAt = collidePoint(x1, y1, x2, y2, x3, y3, x4, y4);
          
          ///add code for difficulty affect here
          float modifier = map(difficulty, 0, 100, 0, 1);
          
          float xDiff = collidesAt.x - x1;
          float yDiff = collidesAt.y - y1;
          
          if (x1 + (xDiff * modifier) > this.softWidthCap) {
            newLevel.add(new EndPlatform(x1 + (xDiff * modifier), y1 + (yDiff * modifier), setSize));
          } else {
            newLevel.add(new Platform(x1 + (xDiff * modifier), y1 + (yDiff * modifier), setSize));
          }
          this.setAngleAt(x1 + (xDiff * modifier) + setSize, angleUp, angleDown);
          
          if (y3 > y4) {
            xVelAcrossPlatform = 0;
          }
          
          break;
        }
      }
      n++;
    }
    
    
    
    return newLevel;
  }
  
  
  
}
