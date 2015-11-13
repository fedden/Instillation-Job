class LoadingGraphic {

  int cx;
  int cy;
  int numberOfCircles;
  int radius;
  int thickness;
  int range;
  int speed;
  float alpha;

  LoadingGraphic() {
    numberOfCircles = 255;  
    thickness = round(height*0.02571428571429);
    radius = round(width*0.05952380952381);
    alpha = 0.3;
    range = 1;
    speed = 5; // less is faster
  }

  void display(int _cx, int _cy, color _colour) {
    noStroke();

    
    float t = frameCount/speed;

    pushMatrix();
    translate(_cx, _cy);
    for (int i = 1; i <= numberOfCircles; i++) {    
      fill(red(_colour), green(_colour), blue(_colour), i*alpha);
      float angle = i * TWO_PI / numberOfCircles;
      float x = cos(angle) * radius;
      float y = sin(angle) * radius;
      pushMatrix();
      //translate(x, y);
      rotate(t);
      ellipse(x, y, thickness, thickness);
      popMatrix();
    } 
    popMatrix();
  }
}
