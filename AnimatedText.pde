class AnimatedText {

  int xspacing = 1;   // How far apart should each horizontal location be spaced
  int w;              // Width of entire wave

  float theta = 0.0;  // Start angle at 0
  float amplitude = 10.0;  // Height of wave
  float period = 5.0;  // How many pixels before the wave repeats
  float dx;  // Value for incrementing X, a function of period and xspacing
  float[] yvalues;  // Using an array to store height values for the wave

  AnimatedText() {
    w = width+16;
    dx = (TWO_PI / period) * xspacing;
    yvalues = new float[w/xspacing];
  }

  void display(String _message, int _xPos, float _yPos) {
    calcWave();
    renderWave(_message, _xPos, _yPos);
  }

  void calcWave() {
    // Increment theta (try different values for 'angular velocity' here
    theta += 0.1;

    // For every x value, calculate a y value with sine function
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      yvalues[i] = map(sin(x), -1.0, 1.0, 0.0, 1.0)*amplitude;
      x+=dx;
    }
  }

  void renderWave(String _message, int _xPos, float _yPos) {
    textFont(regularFont42);
    noStroke();
    fill(0);
    String stop = "...";
    float x = _xPos + textWidth(_message)/2;
    
    text(_message, _xPos, _yPos);
    for (int i = 0; i < stop.length (); i++) {

      text(stop.charAt(i), x + 5, _yPos-yvalues[i]);

      // textWidth() spaces the characters out properly.
      x += textWidth(stop.charAt(i));
    }
  }
}
