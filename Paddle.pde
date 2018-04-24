class Paddle {
  float x;
  float y;
  float pWidth;
  float pHeight;
  color myColor;
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
    
    if((yLoc + 10 >= y - pHeight/1.65) && (yLoc <= y) && (xLoc + 10 >= x - pWidth/1.85) && (xLoc - 10 <= x + pWidth/1.85)){
      float bounce = xLoc - x;
      if(bounce >= 0){
        ball.modXVel(abs(bounce)/10.0, 1);
      }else if(bounce < 0){
        ball.modXVel(abs(bounce)/10.0, 0);
      }
      ball.paddleInvertY();
      return true;
    }else if((xLoc + 10 >= x - pWidth/1.9) && (xLoc <= x) && (yLoc >= y - pHeight/1.7) && (yLoc <= y + pHeight/1.7)){
      ball.invertXVel();
    } else if ((xLoc - 10 <= x + pWidth/1.9) && (xLoc >= x) && (yLoc >= y-pHeight/1.7) && (yLoc <= y + pHeight/1.7)){
      ball.invertXVel();
    }
  return false;
  }
}