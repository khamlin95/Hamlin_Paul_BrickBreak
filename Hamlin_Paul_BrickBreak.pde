/**
 * Authors: John Paul, Kyle Hamlin
 * Contains all code for brick break
 **/

import processing.sound.*;

int FR = 100, lives = 5, gameState = 0, size = 20, ballsInPlay = 0, score = 0;
PImage back = new PImage();
SoundFile s0;
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
  rectMode(CORNER);
  size(600, 800);
  frameRate(FR);
  noStroke();
  s0 = new SoundFile(this, "PumpedKicks.mp3");
  s0.loop();
  paddle = new Paddle();
}

//Handles displaying our game and background. 
void draw()
{
  background(back);
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
    if (random(-0.01, bricks.size()) < time.getTime().get(0)) {
      int diff = (int) random(1, time.getTime().get(1)+2);
      bricks.add(new Brick(diff, (int)random(30, width - 30), (int)random(35, (2*height)/3)));
    }
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == LEFT) {
          paddle.pressedLeft();
        } else if (keyCode == RIGHT) {
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
        paddle.pWidth = 1000;
        if (p.getUpTime().getTime().get(1) >= 10) {
          paddle.pWidth = 95;
          apups.remove(z);
        }
        break;
      case 3:
        paddle.speed = 5;
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
      ball.capVel();
      ball.update();
      ball.displayBall();
    }
    for (int i = 0; i < balls.size(); i++) {
      WreckingBall b = balls.get(i);
      if (ballKilled) {
        if (!b.inPlay) {
          balls.remove(i);
        }
        ballKilled = false;
      }
    }
    if (ballsInPlay <= 0) {
      lives -= 1;
      balls.add(0, new WreckingBall(size, (int)random(0, width), (int)random(0, height/2)));
      ballsInPlay = 1;
      bricks = new ArrayList<Brick>(1);
      spups = new ArrayList<PowerUps>(1);
      apups = new ArrayList<PowerUps>(1);
      paddle.pWidth = 95;
      paddle.speed = 7.5;
      paddle.myColor = color(255, 50, 50);
      if (lives <= 0) {
        gameState = 0;
      }
    }

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
  if (mouseOver(0) || mouseOver(1)) {
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
    }
    break;

  case 1:
    gameState = 0;
    break;
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
  }
  return false;
}