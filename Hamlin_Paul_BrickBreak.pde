/**
 * Authors: John Paul, Kyle Hamlin
 * Contains all code for brick break
 **/

import processing.sound.*;

int FR = 200, lives = 5, gameState = 0, size = 20, ballsInPlay = 0, score = 0, diff = 5;
PImage back = new PImage();
PImage med = new PImage();
PImage hard = new PImage();
SoundFile s0, s1, s2, s3, s4;
ArrayList<WreckingBall> balls = new ArrayList<WreckingBall>(1);
ArrayList<Brick> bricks = new ArrayList<Brick>(1);
ArrayList<PowerUps> apups = new ArrayList<PowerUps>(1);
ArrayList<PowerUps> spups = new ArrayList<PowerUps>(1);
boolean ballKilled = false, ballSpawn = false, timerStarted = false, fallCalled = false;
Timer time = new Timer();
Paddle paddle;


//Sets up our drawing, and starts playing music. This will be changed later so music can be more dynamic. 
//Also loads the background image. 
void setup()
{
  back = loadImage("Background.jpg");
  med = loadImage("mediumDiffBackground.jpg");
  hard = loadImage("hardDiffBackground.jpg");
  rectMode(CORNER);
  size(600, 800);
  frameRate(FR);
  noStroke();
  s0 = new SoundFile(this, "PumpedKicks.mp3");
  s1 = new SoundFile(this, "extraBall.wav");
  s2 = new SoundFile(this, "paddleSize.wav");
  s3 = new SoundFile(this, "paddleStar.wav");
  s4 = new SoundFile(this, "paddleSlowDown.wav");
  s0.loop();
}

//Handles displaying our game and background. 
void draw()
{
  switch(diff) {
  case 5: 
    background(back);
    break;
  case 10: 
    background(med);
    break;
  case 20: 
    background(hard);
    break;
  }
  switch(gameState) {
  case 0: //Menu State
    score = 0;
    lives = 5;
    ballsInPlay = 1;
    ballKilled = true;
    timerStarted = false;
    drawMenu();
    if (bricks.size() > 0) {
      bricks = new ArrayList<Brick>();
    }
    if (spups.size() > 0) {
      spups = new ArrayList<PowerUps>();
    }
    if (apups.size() > 0) {
      apups = new ArrayList<PowerUps>();
    }
    for (int i = 0; i < balls.size(); i++) {
      balls.remove(i);
    }
    if (balls.size() > 1 || balls.size() <= 0) {
      balls = new ArrayList<WreckingBall>(1);
      balls.add(0, new WreckingBall(size, width/2, height/2 - 30));
    }

    break;

  case 1: //Game state
    fallCalled = false;
    if (random(-0.01, bricks.size()) < time.getTime().get(0) && bricks.size() < (time.getTime().get(0)+1)*5) {
      int diff = (int) random(1, time.getTime().get(1)+2);
      bricks.add(new Brick(diff, (int)random(30, width - 30), (int)random(35, (2*height)/3)));
    }
    if (keyPressed) {
      if (keyCode == LEFT || key == 'A' || key == 'a') {
        paddle.pressedLeft();
      } else if (keyCode == RIGHT || key == 'D' || key == 'd') {
        paddle.pressedRight();
      }
    }
  }
  if (!timerStarted) {
    time.startTimer();
    timerStarted = true;
  }
  time.update();
  textSize(25);
  fill(0, 0, 0);
  text("Score: " + score, 10, 25);
  text(nf(time.getTime().get(0), 2) + " : " + nf(time.getTime().get(1), 2), ((width*4)/8) -45, 25);
  text("Lives: " + lives, (width * 6)/8, 25);
  cursor(CROSS);
  //paddle.noPress();
  paddle.display();
  for ( int i = 0; i < bricks.size(); i++) {
    Brick brick = bricks.get(i);
    brick.capDifficulty(diff);
    if (brick.getHits() <= 0) {
      bricks.remove(i);
      score += 100;
      if (random(0, 100) > 60) {
        spups.add(new PowerUps(random(0, 100)));
      }
      //continue;
    }
    int sideH= -1;
    for ( WreckingBall ball : balls) {
      ball.coolDown();
      sideH = brick.ballCollisionCheck(ball);
      switch(sideH) {
      case -1:
        break;
      case 0:
      case 2:
        brick.updateColor();
        ball.invertXVel();
        ball.bounceDecay();
        score += 2;
        break;
      case 1:
      case 3:
        brick.updateColor();
        ball.invertYVel();
        ball.bounceDecay();
        score += 2;
        break;
      }
    }
    brick.displayBrick();
  }
  for (int z = 0; z<spups.size(); z++) {
    PowerUps p = spups.get(z);
    if (!fallCalled) {
      p.fall();
    }

    p.display();
    if (p.detectPaddle(paddle)) {
      spups.remove(z);
      switch(p.id) {
      case 0: 
        s1.play();
        break;
      case 1: 
        s2.play();
        break;
      case 2: 
        s3.play();
        break;
      case 3: 
        s4.play();
        break;
      }
      p.startTimer();
      apups.add(p);
    }
    if (p.loc.y > height) {
      spups.remove(z);
    }
  }

  for (int z = 0; z < apups.size(); z++) {
    PowerUps p = apups.get(z);
    switch(p.id) {
    case 0:
      balls.add(new WreckingBall(size, (int)random(0, width), (int)random(0, height/2)));
      ballsInPlay += 1;
      apups.remove(z);
      break;
    case 1:
      if (paddle.pWidth > 150) {
        paddle.pWidth += 3;
      }
      apups.remove(z);
      break;
    case 2:
      paddle.pWidth = 10000;
      if (p.getUpTime().getTime().get(1) >= 10) {
        switch(diff) {
        case 5:
          paddle.pWidth = 105;
          break;
        case 10:
          paddle.pWidth = 95;
          break;
        case 20:
          paddle.pWidth = 75;
          break;
        }
        apups.remove(z);
      }
      break;
    case 3:
      paddle.speed = 3;
      paddle.myColor = color(0, 0, 0);
      if (p.getUpTime().getTime().get(1) >= 5) {
        paddle.speed = 7.5;
        paddle.myColor = color(255, 50, 50);
        apups.remove(z);
      }
      break;
    }
  }
  for ( WreckingBall ball : balls) {
    if (ball.wallCollisionCheck()) {
      ball.inPlay = false;
      ballsInPlay -= 1;
      ballKilled = true;
      if (ballsInPlay != 0) {
        score -= 100/ballsInPlay;
      } else {
        score -= 100;
      }
      if (score < 0) {
        score = 0;
      }
    }
    paddle.detectBall(ball);
    ball.capVel(diff);
    ball.update();
    ball.displayBall();
  }
  for (int i = 0; i < balls.size(); i++) {
    WreckingBall b = balls.get(i);
    if (ballKilled) {
      if (!b.inPlay) {
        balls.remove(i);
        ballKilled = false;
      }
    }
  }
  if (ballsInPlay <= 0) {
    lives -= 1;
    balls = new ArrayList<WreckingBall>(1);
    balls.add(0, new WreckingBall(size, (int)random(0, width), (int)random(0, height/2)));
    ballsInPlay = 1;
    bricks = new ArrayList<Brick>(1);
    spups = new ArrayList<PowerUps>(1);
    apups = new ArrayList<PowerUps>(1);
    switch(diff) {
    case 5:
      paddle.pWidth = 105;
      break;
    case 10:
      paddle.pWidth = 95;
      break;
    case 20:
      paddle.pWidth = 75;
      break;
    }
    paddle.speed = 7.5;
    paddle.myColor = color(255, 50, 50);
    if (lives <= 0) {
      gameState = 0;
    }
  }

  break;

case 2: //Difficulty Select state
  drawDiffMenu();
  break;
}
}

//Function for drawing menu. Everytime the menu is drawing, we change the starting position and velocity vectors for our ball. 
//Then we begin to draw our menu, which simply consists of play and quit for now. 
void drawMenu() {
  textSize(55);
  fill(0);
  text("Brick Breaker!", 120, 100);
  stroke(84, 219, 114);
  fill(18, 139, 45);
  rectMode(CENTER);
  rect(width/2, height/2, 300, 100);
  fill(255);
  text("Play!", width/2 - 60, height/2 + 20);
  stroke(219, 84, 84);
  fill(255, 84, 45);
  rect(width/2, height/2 + 150, 300, 100);
  fill(0);
  text("Quit", width/2 - 60, height/2 +170);
  fill(255, 255, 10);
  rect(width/2, height/2 + 300, 300, 100);
  fill(0);
  text("Difficulty", width/2 - 115, height/2+320);
  if (mouseOver(0) || mouseOver(1) || mouseOver(2)) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}

void drawDiffMenu() {
  textSize(55);
  stroke(84, 219, 114);
  fill(18, 139, 45);
  rectMode(CENTER);
  rect(width/2, height/2, 300, 100);
  fill(0);
  text("Easy", width/2 - 60, height/2 + 20);
  stroke(219, 84, 84);
  fill(255, 255, 10);
  rect(width/2, height/2 + 150, 300, 100);
  fill(0);
  text("Medium", width/2 - 100, height/2 +170);
  fill(255, 84, 45);
  rect(width/2, height/2 + 300, 300, 100);
  fill(0);
  text("Hard", width/2 - 60, height/2+320);
  if (mouseOver(0) || mouseOver(1) || mouseOver(2)) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}

void keyPressed() {
  final int x = keyCode;
  if (x == 'P' || x == 'p') {
    if (looping) {
      noLoop();
      textSize(55);
      fill(0);
      text("Game Paused!", 120, 100);
      stroke(84, 219, 114);
      fill(18, 139, 45);
      rectMode(CENTER);
      rect(width/2, height/2, 300, 100);
      fill(255);
      text("Play!", width/2 - 60, height/2 + 20);
      stroke(219, 84, 84);
      fill(255, 84, 45);
      rect(width/2, height/2 + 150, 300, 100);
      fill(0);
      text("Quit", width/2 - 60, height/2 +170);
    } else {
      loop();
    }
  }
}

void responsiveKeyPress() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      paddle.pressedLeft();
    } else if (keyCode == RIGHT) {
      paddle.pressedRight();
    }
  }
  key = 0;
}



//Overridden to make menu interaction easier. 
void mouseClicked() {
  switch(gameState) {
  case 0:
    if (mouseOver(0)) {
      gameState = 1;
    } else if (mouseOver(1)) {
      exit();
    } else if (mouseOver(2)) {
      gameState = 2;
    }
    break;

  case 1:
    gameState = 0;
    break;

  case 2:
    if (mouseOver(0)) {
      diff = 5;
      gameState = 0;
    } else if (mouseOver(1)) {
      diff = 10;
      gameState = 0;
    } else if (mouseOver(2)) {
      diff = 20;
      gameState = 0;
    }
  }
}

//Using an ID (which is completely arbitrary) and a game state, we can use mouseOver to detect if our mouse is over a certain region, and gameState.
//This holds all the bound checks for mouse clicking, making implentation look neat. 
boolean mouseOver(int id) {
  switch(id) {
  case 0: //Play Button
    return ((mouseX > 150 && mouseX < 450) && (mouseY > 350 && mouseY < 450));
  case 1: //Quit button
    return ((mouseX > 150 && mouseX < 450) && (mouseY > 500 && mouseY < 600));
  case 2: //Difficulty Button
    return ((mouseX > 150 && mouseX < 450) && (mouseY > 650 && mouseY < 750));
  }
  return false;
}