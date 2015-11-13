class Spring {

  float M, K, D, R, ps, vs, as, f;

  Spring(boolean _fromTheRight, boolean _fromTheTop, int _size) {
    // Spring simulation constants
    M = 10.8;   // Mass
    K = 0.1;   // Spring constant
    D = 0.92;  // Damping

    // Spring simulation variables
    if (_fromTheRight) {
      ps = width + _size; // Start Position
    } else if (_fromTheTop) {
      ps = height + _size; // Start Position
    } else {
      ps = -_size;        // Start Position
    }
    vs = 0.0;  // Velocity
    as = 0;    // Acceleration
    f = 0;     // Force
  }

  PVector horizontalSpring(float _xRest, float _yPosition) {
    PVector destination = new PVector(updateSpring(_xRest), _yPosition);
    return destination;
  }

  PVector verticalSpring(float _xPosition, float _yRest) {
    PVector destination = new PVector(_xPosition, updateSpring(_yRest));
    return destination;
  }

  float updateSpring(float _rest) {
    // Update the spring position
    f = -K * (ps - _rest);    // f=-ky
    as = f / M;           // Set the acceleration, f=ma == a=f/m
    vs = D * (vs + as);   // Set the velocity
    ps = ps + vs;         // Updated position

    if (abs(vs) <= 0.1) {
      vs = 0.0;
    }
    return ps;
  }
}
