class Brick{
int hits;
int w,h,r,g,b;
PVector position;

  Brick(int tier, int x, int y){
  hits = tier;
  position = new PVector(x, y);
  w = 60;
  h = 20;
  r = tier*20;
  g = tier*20;
  b = tier*10;
  }
  
  void displayBrick(){
    fill(r,g,b);
    rect(position.x, position.y, w, h);
  }

  ArrayList<Integer> getHitBox(){
    ArrayList<Integer> bounds = new ArrayList<Integer>();
    bounds.add(0, ((int)position.x - 30));
    bounds.add(1, ((int)position.x + 30));
    bounds.add(2, ((int)position.y - 10));
    bounds.add(3, ((int)position.y + 10));
    return bounds;
  }
  
  int ballCollisionCheck(WreckingBall ball){
    float xLoc = ball.getxLoc(), yLoc = ball.getyLoc();
    
    if((xLoc + 10 >= position.x - w/1.6) && (xLoc <= position.x) && (yLoc >= position.y - h/1.7) && (yLoc <= position.y + h/1.7)){
      hits -= 1;
      return 0;
    } else if ((xLoc - 10 <= position.x + w/1.6) && (xLoc >= position.x) && (yLoc >= position.y-h/1.7) && (yLoc <= position.y + h/1.7)){
      hits -= 1;
      return 2;
    }else if((yLoc + 10 >= position.y - h/1.69) && (yLoc <= position.y) && (xLoc + 10 >= position.x - w/1.9) && (xLoc - 10 <= position.x + w/1.9)){
      hits -= 1;
      return 1;
    }else if((yLoc - 10 <= position.y + h/1.69) && (yLoc >= position.y) && (xLoc +10 >= position.x - w/1.9) && (xLoc -10 <= position.x + w/1.9)){
      hits -= 1;
      return 3;
    }else{
      return -1;
    }
  }
  
  int getHits(){
    return hits;
  }
  
  void updateColor(){
  r = hits*40;
  g = hits*40;
  b = hits*20;
  }
  
  void capDifficulty(int diff){
    if(hits > diff){
      hits = diff;
    }
    if(hits == 20){
      hits = 7;
    }
    if(hits == 10){
      hits = 6;
    }
  }
}