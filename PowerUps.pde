class PowerUps{
  int id, d;
  float fallRate;
  PVector loc;
  Timer time;
  
  PowerUps(float type){
    if(type < 50){
      id = 0; //Spawn new ball
    }else if(type >= 50 && type <= 70){
      id = 1; //Increase paddle width
    }else if(type > 70 && type <= 75) {
      id = 2; //Auto Bounce
    }else if(type > 75 && type <= 100){
      id = 3; //Paddle slow down
    }
  loc = new PVector(random(20, width - 20), -10);
  fallRate = 1;
  d = 20;
  time = new Timer();
  }

  void display(){
    switch(id){
      case 0:
      fill(50, 50,255);
      break;
      case 1:
      fill(50,255,50);
      break;
      case 2:
      fill(255,238,41);
      break;
      case 3:
      fill(255,0,0);
      break;
    }
    
    ellipse(loc.x, loc.y, d,d);
  }
  
  void fall(){
    loc.y += fallRate;
  }
  
  boolean detectPaddle(Paddle p){
    if((loc.y + 10 >= p.y - p.pHeight/2.0) && (loc.y <= p.y) && (loc.x + 10 >= p.x - p.pWidth/2.0) && (loc.x - 10 <= p.x + p.pWidth/2.0)){
      return true;
    }
    return false;
  }
  
  Timer getUpTime(){
    time.update();
    return time;
  }
  
  void startTimer(){
    time.startTimer();
  }

}