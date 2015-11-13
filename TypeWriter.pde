class TypeWriter {

  int counter;
  boolean turnOffTimer;
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  TypeWriter() {
    counter = 0;
    timerStart();
    turnOffTimer = false;
  }
  
  void reset() {
    counter = 0;
    turnOffTimer = false;
  }

  void display(String _message, int _x, int _y) { 
    fill(255);    
    int x = _x;

    if (counter == _message.length() - 1) {
      turnOffTimer = true;
    }

    if (timerIsFinished() && !turnOffTimer) {
      // myMessage[counter] = message.charAt(counter);
      x += textWidth(_message.charAt(counter));
      counter++;
      timerStart();
    }

    for (int i = 0; i < counter; i++) {
      text(_message.charAt(i), x, _y);
      // textWidth() spaces the characters out properly.
      x += textWidth(_message.charAt(i));
    }
  }

  // Starting the timer
  void timerStart() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
    // Add a human touch to it
    totalTime = round(random(100, 400));
  }

  // The function isFinished() returns true if the time set has passed. 
  // The work of the timer is farmed out to this method.
  boolean timerIsFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}
