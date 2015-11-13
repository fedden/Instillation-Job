class BetterTypeWriter {
  Timer trimer, grimer, primer;
  int counter;
  int counter2;
  String message;
  boolean finished;
  float w = 0;    // Accumulate width of chars
  int i = 0;      // Count through chars
  int rememberSpace = 0; // Remember where the last space was
  int lines = 0;

  BetterTypeWriter() {
    counter = 0;
    counter2 = 0;
    finished = false;

    trimer = new Timer(0);
    grimer = new Timer(0);
    if (!noWait) {
      primer = new Timer(600);
    } else {
      primer = new Timer(0);
    }
    trimer.start();
    grimer.start();
    textAlign(CENTER);
  }

  void reset() {
    counter = 0;
    //trimer.start();
  }

  void typeWriter(String _message, int _textSize, float _minSpeed, float _maxSpeed, float _blinkSpeed, int _x, int _y, int _xSize, int _ySize, color _col) {
    fill(_col);
    message = writeText(_message, _minSpeed, map(sin(millis()/1000), 0, 1, _minSpeed, _maxSpeed));
    textSize(_textSize);
    textAlign(CENTER);
    textFont(regularFont60);
    text(message, width/2, _y, _xSize, _ySize);
    //int i = wordWrap(_message, 11*_xSize, counter);
    //println(i);
    //blinkCursor(_blinkSpeed, 0.5*textWidth(message) + _x, _y+i*_textSize + 0.5*_textSize, _textSize);
  }

  void loadText(String _message, int _xPos, float _yPos) {
    textFont(regularFont42);
    noStroke();
    fill(0);
    String stop = "...";
    float x = _xPos + textWidth(_message)/2;


    //timer shit
    if (primer.isFinished()) {
      if (counter2 > 2) {
        counter2 = 0;
      } else {
        counter2++;
      }
      //println("counter = " + counter);
      primer.start();
    }
    text(_message, _xPos, _yPos);
    textAlign(LEFT);
    text(stop.substring(0, counter2), x, _yPos);
    textAlign(CENTER);
  }

  void blinkCursor(float _speed, float _x, float _y, int _ySize) {
    if (!finished) {
      line(_x + 1, _y - 0.5 * _ySize - 2, _x + 1, _y + 0.5 * _ySize + 2);
    } else {
      if (grimer.isFinished()) {
        line(_x + 1, _y - 0.5 * _ySize - 2, _x + 1, _y + 0.5 * _ySize + 2);
        grimer.start();
      }
    }
  }

  String writeText(String _text, float _minSpeed, float _maxSpeed) {    
    //timer shit
    if (trimer.isFinished()) {
      int r = counter + 1;

      if (r > _text.length() - 1) {
        r = _text.length() - 1;
      }

      if (_text.charAt(r) == ' ') {

        trimer.totalTime = 370;
        //println("YOOOOO SPACE");
      } else {
        //if debug mode not on
        if (!noWait) {

          trimer.totalTime = round(random(_minSpeed, _maxSpeed));
        } else {

          trimer.totalTime = 0;
        }
      }
      //println(counter);

//      //fixxinggggg some bug
//      if (userConvNumber == 0 && consecutive) {
//        counter = _text.length();
//      } else {
//        counter++;
//      }
      counter++;
      trimer.start();
    }

    //use counter to create sub string of counter-length from string arg
    if (counter < _text.length()) {
      finished = false;
      //println("typeWriter is NOT finished!");
      return _text.substring(0, counter);
    } else {
      finished = true;
      //println("typeWriter is finished!");
      return _text;
    }
  }
}

