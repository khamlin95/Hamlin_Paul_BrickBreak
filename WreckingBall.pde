class WreckingBall {
  int size, hitCoolD;
  PVector vel, loc;
  boolean inPlay;

  WreckingBall(int S, int x, int y) {
    size = S;
    vel = new PVector();
    vel.x = random(1.5, 3.5);
    vel.y = random(1.5, 3.5);
    loc = new PVector();
    loc.x = x;
    loc.y = y;
    inPlay = true;
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
    fill(0, 0, 0);
    ellipse(loc.x, loc.y, size, size);
  }

  //Updates ball position.
  void update() {
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

  void modXVel(float c) {
    vel.x *= c;
    if (vel.x > 5) {
      vel.x = 5;
    } else if (vel.x < -5) {
      vel.x = -5;
    }
  }

  void invertYVel() {
    if (hitCoolD == 0) {
      vel.y *= -1;
      if (vel.y > 6) {
        vel.y = 6;
      } else if (vel.y < -6) {
        vel.y = -6;
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

  void capVel() {
    if (vel.x > 7) {
      vel.x = 7;
    } else if (vel.x < -7) {
      vel.x = -7;
    }
    if (vel.y > 7) {
      vel.y = 7;
    } else if (vel.y < -7) {
      vel.y = -7;
    }
  }

  void coolDown() {
    if (hitCoolD > 0) {
      hitCoolD --;
    }
  }
}