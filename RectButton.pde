class RectButton {

  int x, y; //x y pos
  int sizeX, sizeY; //self explanatory
  color basecolor, highlightcolor; //base colour is when mouse !isOver and vice versa for highlight colour
  int base_red, base_green, base_blue, base_alpha, high_red, high_green, high_blue, high_alpha;
  color currentcolor; //what colour is the button currently?=
  boolean pressed = false; //set to true when pressed
  boolean locked = true;
  String name;
  Timer transitionTimer1;

  RectButton(int ix, int iy, int isizeX, int isizeY, color icolor, color ihighlight, String _name) {
    transitionTimer1 = new Timer(800);
    x = ix;
    y = iy;
    sizeX = isizeX;  
    sizeY = isizeY;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;   
    name = _name;
  }

  //change the colour here
  void update() {
    base_red = int(red(basecolor));
    base_green = int(green(basecolor));
    base_blue = int(blue(basecolor));
    high_red  = int(red(highlightcolor));
    high_green  = int(green(highlightcolor));
    high_blue  = int(blue(highlightcolor));
    base_alpha = int(alpha(basecolor));
    high_alpha = int(alpha(highlightcolor));
    if (pressed()) {
      if (!transitionTimer1.isFinished()) {
        float current_red = transitionTimer1.timedLerp(base_red, high_red);
        float current_green = transitionTimer1.timedLerp(base_green, high_green);
        float current_blue = transitionTimer1.timedLerp(base_blue, high_blue);
        float current_alpha = transitionTimer1.timedLerp(base_alpha, high_alpha);
        currentcolor = color(current_red, current_green, current_blue, current_alpha);
      } else { 
        currentcolor = highlightcolor;
      }
    } else {
      transitionTimer1.start();
      currentcolor = basecolor;
    }
  }

  boolean overRect(int _x, int _y, int _width, int _height) {
    if (locked) {
      return false;
    } else {
      if (mouseX >= _x - _width/2 && mouseX <= _x+_width/2 && mouseY >= _y  - _height/2 && mouseY <= _y+_height/2) {
        return true;
      } else {
        return false;
      }
    }
  }

  boolean pressed() {
    if (locked) {
      return false;
    } else {
      if (overRect(x, y, sizeX, sizeY)) {
        //println(name + " was pressed");
        return true;
      } else {
        return false;
      }
    }
  }

  void display() {
    if (!timerLock) {
      locked = false;
    }
    update();
    noStroke();
    fill(currentcolor);
    rect(x, y, sizeX, sizeY);
  }
}

