class WreckingBall {
  int size, hitCoolD;
  PVector vel, loc;
  boolean inPlay, hitBack;

  WreckingBall(int S, int x, int y) {
    size = S;
    vel = new PVector();
    vel.x = random(.75, 1.75);
    vel.y = random(.75, 1.75);
    loc = new PVector();
    loc.x = x;
    loc.y = y;
    inPlay = true;
    hitBack = false;
  }

  //Checks for wall Collision with the ball. This was taken from Kyle's HW 7
  boolean wallCollisionCheck() {
    //Checks for wall collision 
    //taken from Kyle's HW 7
    if (loc.x > width-10) {
      loc.x = width-10;
      vel.x *= -1;
      bounceDecay();
    } else if (loc.x < 10) {
      loc.x = 10;
      vel.x *= -1;
      bounceDecay();
    } else if (loc.y > height+20) {
      //When the ball hits the bottom of the screen, the player loses a life, and a new ball is put in play.
      return true;
    } else if (loc.y < 10) {
      loc.y = 10;
      vel.y *= -1;
      bounceDecay();
    }
    return false;
  }

  //Draws the ball
  void displayBall() {
    stroke(100, 0, 0);
    fill(0, 255, 255);
    ellipse(loc.x, loc.y, size, size);
  }

  //Updates ball position.
  void update() {
    if (loc.y < 750) {
      hitBack = false;
    }
    loc.x += vel.x;
    loc.y += vel.y;
  }

  void destroyBall() {
    inPlay = false;
  }

  float getxLoc() {
    return loc.x;
  }

  float getyLoc() {
    return loc.y;
  }

  void invertXVel() {
    if (hitCoolD == 0) {
      vel.x *= -1;
      hitCoolD = 25;
    }
  }

  void modXVel(float c, int direction) {
    vel.x += 1;
    switch(direction) {
    case 0:
      if (vel.x < 0) {
        vel.x *= c;
      } else if (vel.x > 0) {
        vel.x *= (-1*c);
      }

      break;
    case 1:
      if (vel.x < 0) {
        vel.x *= (-1*c);
      } else if (vel.x > 0) {
        vel.x *= c;
      }
      break;
    }
    vel.x -= 1;
  }

  void invertYVel() {
    if (hitCoolD == 0) {
      vel.y *= -1;
      if (vel.y > 3) {
        vel.y = 3;
      } else if (vel.y < -3) {
        vel.y = -3;
      }
      hitCoolD = 25;
    }
  }

  void paddleInvertY() {
    vel.y *= -1;
    if (vel.y > 0) {
      vel.y += 1;
    } else if (vel.y < 0) {
      vel.y -= 1;
    }
  }

  void bounceDecay() {
    if (vel.x < -0.5) {
      vel.x += 0.07;
    } else if (vel.x > 0.5) {
      vel.x -= 0.07;
    }
    if (vel.y < -1.75) {
      vel.y += 0.07;
    } else if (vel.y > 1.75) {
      vel.y -= 0.07;
    }
  }

  void capVel(int diff, float time) {
    float temp = 0.001 * time;
    if(time <= 0){
      time = 1;
    }else{
      time += temp;
    }
    switch(diff) {
    case 5:
      if (vel.x > 2*time) {
        vel.x = 2*time;
      } else if (vel.x < -2*time) {
        vel.x = -2*time;
      }
      if (vel.y > 2*time) {
        vel.y = 2*time;
      } else if (vel.y < -2*time) {
        vel.y = -2*time;
      }
      break;
    case 10:
      if (vel.x > 3*time) {
        vel.x = 3*time;
      } else if (vel.x < -3*time) {
        vel.x = -3*time;
      }
      if (vel.y > 3*time) {
        vel.y = 3*time;
      } else if (vel.y < -3*time) {
        vel.y = -3*time;
      }
      break;
    case 20:
      if (vel.x > 4*time) {
        vel.x = 4*time;
      } else if (vel.x < -4*time) {
        vel.x = -4*time;
      }
      if (vel.y > 4*time) {
        vel.y = 4*time;
      } else if (vel.y < -4*time) {
        vel.y = -4*time;
      };
      break;
    }
  }

  void coolDown() {
    if (hitCoolD > 0) {
      hitCoolD --;
    }
  }
}