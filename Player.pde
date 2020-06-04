class Player {
  
  PVector pos, prevPos;
  PVector vel = new PVector(0,0);
  boolean canJump = false; //this always starts false - the player will only be able to jump when touching a platform
  
  ///these variables aren't for changing - i used them to fine tune the experience
  final float accHorizontal = 0.075; //only need one acceleration variable - vertical accel is constant
  final float friction = 0.2;
  
  final float accPlayerUp = 0.5; //when player is traveling upwards, lessen their ascent slowly
  final float accPlayerDown = 0.6; //when the player is traveling down, make them reach terminal velocity quicker
  
  final float termVelHorizontal = 5; //maximum velocity player can reach
  final float termVelVertical = 10;
  
  final float playerHeight = 30; //variables for the players hitbox
  final float playerWidth = 20;
  ///
  
  
  Player(float x, float y) { //instantiate the player with a starting position
    this.pos = new PVector(x,y);
  }
  
  Player() { //when called with no position, just place at the corner of the screen - place later
    this(0,0);
  }
  
  void setPos(float x,float y) {
    this.pos.set(x,y);
    this.vel.set(0,0);
  }
  
  void limitVel(PVector toLimit) { //function to limit a velocity vector to the terminal velocities defined above
    if (toLimit.x > this.termVelHorizontal) {
      toLimit.x = this.termVelHorizontal;
    } else if (toLimit.x < this.termVelHorizontal * -1) {
      toLimit.x = this.termVelHorizontal * -1;
    }
    
    if (toLimit.y > this.termVelVertical) {
      toLimit.y = this.termVelVertical;
    } else if (toLimit.y < this.termVelVertical * -1) {
      toLimit.y = this.termVelVertical * -1;
    }
  }
  
  float movePlayer() { //function resposible for left/right movement and friction
    if (keyLeft + keyRight == 0) { //if one  or no keys held
      if (this.vel.x > 0) { //if the velocity is above 0
        if (this.vel.x - this.friction < 0) { //make sure the friction doesnt go below 0
          return -this.vel.x;
        } else {
          return -this.friction;
        }
      } else if (this.vel.x < 0) {
        if (this.vel.x - this.friction > 0) { //do the same checks but for a value below 0
          return this.vel.x;
        } else {
          return this.friction;
        }
      }
      //the above will not apply any acceleration if the velocity is already 0 (at rest)
    } else if (keyLeft + keyRight == -1 && this.vel.x > 0) {
      return -this.accHorizontal - this.friction; //if moving one way, and the key to move the other is pressed, apply both acceleration and friction
    } else if (keyLeft + keyRight == 1 && this.vel.x < 0) {
      return this.accHorizontal + this.friction;
    }
    
    return this.accHorizontal * (keyLeft + keyRight); //otherwise pressing a key - left key results in a negative value (move left), right results in a positive
  }

  
  void platformCheck(ArrayList<Platform> platforms) { //function for checking if the player is about to go through any platforms - if they are, put them on the platform and mark them ready for jumping
    this.canJump = false; //assume player not on platform
    for (Platform platform : platforms) { //check each platform in list
      //the pos variable states the middle of the bottom of the players hitbox, so we need to check left and right of it (2 points)
      PVector oldLeft = this.prevPos.copy().sub(this.playerWidth / 2, 0);
      PVector oldRight = this.prevPos.copy().add(this.playerWidth / 2, 0);
      PVector newLeft = this.pos.copy().sub(this.playerWidth / 2, 0);
      PVector newRight = this.pos.copy().add(this.playerWidth / 2, 0);
      
      //if either point collides with the platform, then the player is on it.
      //only say that a collision occurs when the player is jumping onto the platform, not passing through it - otherwise the player will snap to the platform when jumping from below it
      if (this.prevPos.y <= platform.pos.y && (collides(oldLeft.x, oldLeft.y, newLeft.x, newLeft.y, platform.pos.x, platform.pos.y, platform.pos.x + platform.platformWidth, platform.pos.y) || collides(oldRight.x, oldRight.y, newRight.x, newRight.y, platform.pos.x, platform.pos.y, platform.pos.x + platform.platformWidth, platform.pos.y))) {
        this.canJump = true; //set jump flag
        this.pos.y = platform.pos.y; //set the players position to the y of the platform
        this.vel.y = 0; //set the velocity to 0
        break; //dont need to check other platforms - there should be no overlap
      }
    }
  }
  
  void jumpCheck() {
    if (this.canJump && keyJump && jumpOnce) { //if the player can jump, and the jump key is being held
      this.canJump = false; //set canJump to false, as about to jump
      jumpOnce = false; //prevent the player from holding the spacebar to continuosly jump
      this.pos.y -= 0.0001; //lift the player slightly off the platform by a very small amount
                           //this means the player is no longer colliding with the platform it is on - this results in the platformCheck function not setting the velocity to zero
      this.vel.y = -this.termVelVertical; //set the players y velocity to the maximum it can be (upwards)
    }
  }
  
  void update(ArrayList<Platform> platforms) {
    //check jumps - if jump set canJump to false
    this.jumpCheck();
    
    float accVertical = this.accPlayerDown; //assume player travelling down
    
    if (vel.y < 0) { //player actually going up
      accVertical = this.accPlayerUp;
    }
    
    this.vel.add(this.movePlayer(), accVertical); //add the accelerations to the velocities
    this.limitVel(this.vel); //make sure the velocities arent going above the limit
    
    this.prevPos = this.pos.copy(); //store the current position before changing it - this is needed for collision detection
    this.pos.add(vel); //add the velocities to the positions
    
    //check platforms
    this.platformCheck(platforms);
  }
  
  void display() {
    if (this.vel.x > 0) { //going right
      image(playerRightMove, this.pos.x - playerRightMove.width/2, this.pos.y - playerRightMove.height);
    } else if (this.vel.x < 0) { //going left
      image(playerLeftMove, this.pos.x - playerLeftMove.width/2, this.pos.y - playerLeftMove.height);
    } else { //stationary
      image(playerStop, this.pos.x - playerStop.width/2, this.pos.y - playerStop.height);
    }
  }

  
  
}
