class Paddle {
  float x;
  float y;
  float pWidth;
  float pHeight;
  color myColor;
  float accel;
  float speed;
  int direction;
  final int pLEFT=1;
  final int pRIGHT=2;
  final int pNONE=0;

  Paddle() {
    this(width/2, height-20, 95, 15);
  }

  Paddle(float _x, float _y, float _width, float _height) {
    x=_x;
    y=_y;
    pWidth=_width;
    pHeight=_height; 
    myColor=color(255, 50, 50); 
    speed=7.5;
    direction=pNONE;
    accel = 5;
  }

  void display() {
    fill(myColor);
    stroke(0);
    strokeWeight(2);
    rect(x, y, pWidth, pHeight);
    switch(direction) {
      case(pNONE):
      break;
      case(pLEFT):
      break;
      case(pRIGHT):
      break;
    }
  }
  void pressedLeft() {
    if (x - (pWidth/1.8)>0) {
      x=x-speed;
      direction=pLEFT;
    }
  }
  void pressedRight() {
    if (x+(pWidth/1.8)<width) {
      x=x+speed;
      direction=pRIGHT;
    }
  }
  
  boolean detectBall(WreckingBall ball){
    float xLoc = ball.getxLoc(), yLoc = ball.getyLoc();
    
    if((yLoc + 10 >= y - pHeight/2.0) && (yLoc <= y) && (xLoc + 10 >= x - pWidth/2.0) && (xLoc - 10 <= x + pWidth/2.0)){
      float bounce = xLoc - x;
      while(bounce > 5 || bounce < -5){
        bounce = bounce/10.0;
      }
      ball.paddleInvertY();
      ball.modXVel(-1*bounce);
      return true;
    }
  return false;
  }
}