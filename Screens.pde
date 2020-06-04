enum View {
  Menu, //display buttons that go to single game select and multi game select
  SingleGameSelect, //display slider for difficulty, text box for seed, and button to single game play
  SingleGamePlay, //load settings from select, create level, play level. when finish platform or forfeit go to single game end screen
  SingleGameEnd, //display stats from single run
  MultiGameSelect, //explain what the mode is (random difficulty and random seed)
  MultiGamePlay,
  MultiGameEnd
}

class RunData { //object to store data from each run in multi game runs - only storing from multi not single
  
  int actualDifficulty;
  int perceivedDifficulty;
  int seed;
  int attempts;
  float time;
  float finalTime;
  boolean forfeit;
  
  RunData(int _actualDifficulty, int _perceivedDifficulty, int _seed, int _attempts, float _time, float _finalTime, boolean _forfeit) {
    this.actualDifficulty = _actualDifficulty;
    this.perceivedDifficulty = _perceivedDifficulty;
    this.seed = _seed;
    this.attempts = _attempts;
    this.time = _time;
    this.finalTime = _finalTime;
    this.forfeit = _forfeit;
  }
  
  String asString() {
    return this.actualDifficulty + " " + this.perceivedDifficulty + " " + this.seed + " " + this.attempts + " " + this.time + " " + this.finalTime + " " + this.forfeit;
  }
  
  
}

View currentView = View.Menu;
int difficulty = 0;
int seed = 0;

int attempts = 1;
float time = 0;
float currentAttemptTime = 0;
boolean forfeitFlag = false;

int playthrough = 0;
RunData[] playthroughData = new RunData[5];
PrintWriter fileOut;

int perceivedDifficulty = 0;

void resetLevelVars() {
  attempts = 1;
  time = 0;
  currentAttemptTime = 0;
  forfeitFlag = false;
}

void setSeed() {
  String[] seedtxtRead = loadStrings("seed.txt");
  if (seedtxtRead.length > 0) {
    String readSeed = seedtxtRead[0];
    seed = int(readSeed);
  } else {
    randomiseSeed();
  }
}

void randomiseSeed() {
  seed = (int) random(-2147483648,2147483647);
}

void clearPlaythroughs() {
  playthrough = 0;
  playthroughData = new RunData[5];
}

Screen menuChoice;
Screen singleGameSelectChoice;
Screen singleGamePlayChoice;
Screen singleGameEndChoice;
Screen multiGameSelectChoice;
Screen multiGamePlayChoice;
Screen multiGameEndChoice;

void displayCurrentView() {
  switch (currentView) {
    case Menu:
      menuChoice.display();
      menuChoice.check();
      break;
    case SingleGameSelect:
      singleGameSelectChoice.display();
      singleGameSelectChoice.check();
      break;
    case SingleGamePlay:
      singleGamePlayChoice.display();
      singleGamePlayChoice.check();
      break;
    case SingleGameEnd:
      singleGameEndChoice.display();
      singleGameEndChoice.check();
      break;
    case MultiGameSelect:
      multiGameSelectChoice.display();
      multiGameSelectChoice.check();
      break;
    case MultiGamePlay:
      multiGamePlayChoice.display();
      multiGamePlayChoice.check();
      break;
    case MultiGameEnd:
      multiGameEndChoice.display();
      multiGameEndChoice.check();
      break;
  }
}

static interface Screen {
  void display();
  void check();
}

class MenuScreen implements Screen {
  
  //create 3 buttons
  Button playOne;
  Button playMultiple;
  Button exit;
  
  MenuScreen() {
    this.playOne = new Button(width/4, height/4, 150, "Play One");
    this.playMultiple = new Button(width/4, height/2, 150, "Play Five");
    this.exit = new Button(width/4, 3 * height/4, 150, "Exit");
  }
  
  void display() {
    background(0);
    textSize(30);
    text("Procedural Platformer", width/2 + 50, 30);
    this.playOne.display();
    this.playMultiple.display();
    this.exit.display();
  }
  
  void check() {
    if (this.playOne.pressed()) {
      currentView = View.SingleGameSelect;
    }
    
    if (this.playMultiple.pressed()) {
      currentView = View.MultiGameSelect;
    }
    
    if (this.exit.pressed()) {
      exit();
    }
  }
  
}

class SingleGameSelectScreen implements Screen {
  
  //create 3 buttons
  Button start;
  Button back;
  Slider difficultySlider;
  
  SingleGameSelectScreen() {
    this.start = new Button(width/4, height/2, 150, "Start");
    this.back = new Button(width/4, 3 * height/4, 150, "Back");
    this.difficultySlider = new Slider(width/4, height/4, width/2, 50, 75, 0, 100);
  }
  
  void display() {
    background(0);
    this.start.display();
    this.back.display();
    this.difficultySlider.display();
    textSize(20);
    text("Difficulty", width/4, (height/4) - 10);
    text(difficulty, width/4, (height/4) + 75);
    text("In this mode, you give the level a set\ndifficulty and play through it once.\nYou may set the seed of the level\nin the seed.txt file. Otherwise, leave the\nseed.txt file blank for a random seed.", width/4 + 100, height/2 - 50);
  }
  
  void check() {
    
    this.difficultySlider.update();
    difficulty = this.difficultySlider.getValue();
    
    if (this.start.pressed()) {
      setSeed();
      game.init(seed, difficulty);
      resetLevelVars();
      currentView = View.SingleGamePlay;
    }
    
    if (this.back.pressed()) {
      currentView = View.Menu;
    }
  }
  
}

class SingleGamePlayScreen implements Screen {
  
  Button forfeit = new Button(75, 75, 75,"Forfeit");
  
  void display() {
    game.display(); // display the game
    forfeit.display();
    textSize(20);
    text("Attempt: " + attempts, 10, height - 75);
    text("Current Attempt Time: " + String.format("%.1f", currentAttemptTime / 60), 10, height - 50);
    text("Total Time: " + String.format("%.1f", time / 60), 10, height - 25);
  }
  
  void check() {
    game.update();
    
    if (game.player.pos.y > 500) {
      attempts++;
      currentAttemptTime = 0;
      game.player.setPos(0,-10);
    }
    
    if (forfeit.pressed()) {
      forfeitFlag = true;
      currentView = View.SingleGameEnd;
    }
    
    
    //need to do a check to see if the player is on the finish platform
    Platform lastPlatform = game.platformList.get(game.platformList.size() -1);
    
    if (game.player.pos.x > lastPlatform.pos.x && game.player.pos.x < lastPlatform.pos.x + lastPlatform.platformWidth && game.player.pos.y == lastPlatform.pos.y) {
      currentView = View.SingleGameEnd;
    }
    
    time++;
    currentAttemptTime++;
    
  }
  
}

class SingleGameEndScreen implements Screen {
  
  Button back;
  
  SingleGameEndScreen() {
    this.back = new Button(width/2, 3 * height/4, 150, "Menu");
  }
  
  void display() {
    background(0);
    text("Statistics", width/4, height/4);
    if (forfeitFlag) {
      text("You forfeit the level of difficulty: " + difficulty, width/4, height/4 + 25);
      text("Total time taken: " + String.format("%.1f", time / 60), width/4, height/4 + 50);
      text("Number of attempts: " + attempts, width/4, height/4 + 75);
      text("Seed: " + seed, width/4, height/4 + 100);
    } else {
      text("Level Difficulty: " + difficulty, width/4, height/4 + 25);
      text("Total time taken: " + String.format("%.1f", time / 60), width/4, height/4 + 50);
      text("Number of attempts: " + attempts, width/4, height/4 + 75);
      text("Final attempt completed in " + String.format("%.1f", currentAttemptTime / 60), width/4, height/4 + 100);
      text("Seed: " + seed, width/4, height/4 + 125);
    }
    this.back.display();
  }
  
  
  void check() {
    if (this.back.pressed()) {
      currentView = View.Menu;
    }
  }
  
}

class MultiGameSelectScreen implements Screen {
  
  Button back;
  Button play;
  
  MultiGameSelectScreen() {
    back = new Button(width/4, 3 * height/4, 150, "Back");
    play = new Button(3 * width/4, 3 * height/4, 150, "Play");
  }
  
  void display() {
    background(0);
    textSize(20);
    text("Here, you play five levels of varying difficulty in a row.\nAfter each level, you will be asked about how difficult you\nthought it was on a scale of 0 to 100.\nYou may forfeit the level if you deem it too difficult, but please\nattempt it first!", width/8, height/4);
    back.display();
    play.display();
  }
  
  void check() {
    if (back.pressed()) {
      currentView = View.Menu;
    }
    
    if (play.pressed()) {
      clearPlaythroughs();
      randomiseSeed();
      difficulty = (int) random(101);
      game.init(seed, difficulty);
      resetLevelVars();
      currentView = View.MultiGamePlay;
    }
  }
}

class MultiGamePlayScreen implements Screen {
  
  Button forfeit;
  
  MultiGamePlayScreen() {
    forfeit = new Button(75, 75, 75,"Forfeit");
  }
  
  void display() {
    game.display(); // display the game
    forfeit.display();
    textSize(20);
    text("Playthrough: " + (playthrough + 1), 10, height - 100);
    text("Attempt: " + attempts, 10, height - 75);
    text("Current Attempt Time: " + String.format("%.1f", currentAttemptTime / 60), 10, height - 50);
    text("Total Time: " + String.format("%.1f", time / 60), 10, height - 25);
  }
  
  void check() {
    game.update();
    
    if (game.player.pos.y > 500) {
      attempts++;
      currentAttemptTime = 0;
      game.player.setPos(0,-10);
    }
    
    if (forfeit.pressed()) {
      forfeitFlag = true;
      currentView = View.MultiGameEnd;
    }
    
    
    //need to do a check to see if the player is on the finish platform
    Platform lastPlatform = game.platformList.get(game.platformList.size() -1);
    
    if (game.player.pos.x > lastPlatform.pos.x && game.player.pos.x < lastPlatform.pos.x + lastPlatform.platformWidth && game.player.pos.y == lastPlatform.pos.y) {
      playthroughData[playthrough] = new RunData(difficulty, perceivedDifficulty, seed, attempts, time, currentAttemptTime, forfeitFlag);
      currentView = View.MultiGameEnd;
    }
    
    time++;
    currentAttemptTime++;
    
  }
  
}

class MultiGameEndScreen implements Screen {
  
  Slider perceivedDifficultySlider;
  Button next;
  
  Button left;
  Button right;
  Button back;
  
  boolean review = true;
  
  int statView = 0;
  
  MultiGameEndScreen() {
    perceivedDifficultySlider = new Slider(width/4, height/4, width/2, 50, 75, 0, 100);
    next = new Button(width/2, 3 * height/4, 150, "Next Level");
    
    left = new Button(100, 3 * height/4, 75, "Left");
    right = new Button(width - 100, 3 * height/4, 75, "Right");
    back = new Button(width/2, 3 * height/4, 75, "Menu");
  }
  
  
  void check() {
    if (this.review) {
      this.perceivedDifficultySlider.update();
      perceivedDifficulty = perceivedDifficultySlider.getValue();
      
      if (next.pressed()) {
        playthroughData[playthrough] = new RunData(difficulty, perceivedDifficulty, seed, attempts, time, currentAttemptTime, forfeitFlag);
        if (playthrough < 4) {
          playthrough++;
          randomiseSeed();
          difficulty = (int) random(101);
          game.init(seed, difficulty);
          resetLevelVars();
          currentView = View.MultiGamePlay;
        } else {
          this.review = false;
        }
      }
    } else {
      if (left.pressed()) {
        this.statView--;
        if (this.statView < 0) {
          this.statView = 0;
        }
      }
      
      if (right.pressed()) {
        this.statView++;
        if (this.statView > 4) {
          this.statView = 4;
        }
      }
      
      if (back.pressed()) {
        this.statView = 0;
        this.review = true;
        fileOut = createWriter("Results" + hour() + "-" + minute() + "-" + second() + ".txt");
        for (RunData data : playthroughData) {
          fileOut.println(data.asString());
        }
        fileOut.flush();
        fileOut.close();
        currentView = View.Menu;
      }
    }
  }
  
  void display() {
    background(0);
    
    if (this.review) {
      textSize(20);
      text("Difficulty", width/4, (height/4) - 10);
      text(perceivedDifficulty, width/4, (height/4) + 75);
      text("Select how difficult you thought this level was.", width/4, height/4 + 125);
      perceivedDifficultySlider.display();
      next.display();
    } else {
      text("Statistics: Level " + (this.statView + 1), width/4, height/4);
      text("You thought this level had a difficulty of " + playthroughData[this.statView].perceivedDifficulty, width/4, height/4 + 25);
      text("The actual difficulty was " + playthroughData[this.statView].actualDifficulty, width/4, height/4 + 50);
      text("You attempted this level " + playthroughData[this.statView].attempts + " times", width/4, height/4 + 75);
      text("Your time spent on this level was " + String.format("%.1f", playthroughData[this.statView].time / 60), width/4, height/4 + 100);
      
      if (playthroughData[this.statView].forfeit) {
        text("You forfeit this level", width/4, height/4 + 125);
      } else {
        text("Your final attempt was completed in " + String.format("%.1f", playthroughData[this.statView].finalTime / 60), width/4, height/4 + 125);
      }
      
      text("Seed: " + playthroughData[this.statView].seed, width/4, height/4 + 150);
      text("Please upload the files when you've finished playing!\nTheyre in the same folder as the game,\nread the readme to find where to upload them!", width/4, height/4 +175);
      
      left.display();
      right.display();
      back.display();
    }
  }
  
}
