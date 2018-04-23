class Timer {
  float startTime;
  float now;
  float totalTime;
  
  Timer(){
    startTime = 0;
    totalTime = 0;
  }

  void update(){
    totalTime = ((millis()/1000)) - startTime;
  }
  
  ArrayList<Integer> getTime(){
    ArrayList<Integer> time = new ArrayList<Integer>();
    time.add(0, (int)totalTime/60);
    time.add(1, (int)totalTime%60);
    return time;
  }
  
  void startTimer(){
    startTime = millis()/1000;
  }
  
  void resetTimer(){
    startTime = 0;
    totalTime = 0;
  }
}