//ripped this from shiffman hope no-one minds ;------)

class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }

  // The function isFinished() returns true if the time set has passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }

  float timedLerp(int _start, int _end) {
    //how much time has passed?
    int passedTime = millis() - savedTime;
    //progress from 0 to 1
    float amount = map(passedTime, 0, totalTime, 0.0, 1.0);
    float a = lerp(_start, _end, amount);
    return a;
  }
}
