double inverselerp(double a, double b, double v) {
  return (v - a) / (b - a);
}

enum Extrapolate {
  /// Will extend the range linearly.
  extend,

  /// Will clamp the input value to the range.
  clamp,

  /// Will return the input value if the input value is out of range.
  identity,
}

double interpolate(
  double value, {
  required List<double> inputRange,
  required List<double> outputRange,
  Extrapolate? extrapolate,
  Extrapolate? extrapolateLeft,
  Extrapolate? extrapolateRight,
}) {
  assert(inputRange.length >= 2);
  assert(inputRange.length == outputRange.length);
  assert(inputRange.isNotEmpty);

  if (value < inputRange.first) {
    if (_getExtrapolate(extrapolate, left: extrapolateLeft) ==
        Extrapolate.identity) {
      return value;
    }

    if (_getExtrapolate(extrapolate, left: extrapolateLeft) ==
        Extrapolate.clamp) {
      return outputRange.first;
    }

    if (inputRange[1] - inputRange[0] == 0) {
      return outputRange[0];
    }

    return outputRange[0] +
        (value - inputRange[0]) /
            (inputRange[1] - inputRange[0]) *
            (outputRange[1] - outputRange[0]);
  }

  if (value > inputRange.last) {
    if (_getExtrapolate(extrapolate, right: extrapolateRight) ==
        Extrapolate.identity) {
      return value;
    }

    if (_getExtrapolate(extrapolate, right: extrapolateRight) ==
        Extrapolate.clamp) {
      return outputRange.last;
    }

    if (outputRange[outputRange.length - 1] -
            outputRange[outputRange.length - 2] ==
        0) {
      return outputRange[outputRange.length - 1];
    }

    return outputRange[outputRange.length - 1] +
        (value - inputRange[inputRange.length - 1]) /
            (inputRange[inputRange.length - 1] -
                inputRange[inputRange.length - 2]) *
            (outputRange[outputRange.length - 1] -
                outputRange[outputRange.length - 2]);
  }

  for (int i = 0; i < inputRange.length - 1; i++) {
    if (inputRange[i] <= value && value < inputRange[i + 1]) {
      if (outputRange[i + 1] - outputRange[i] == 0) {
        return outputRange[i];
      }

      return outputRange[i] +
          (value - inputRange[i]) /
              (inputRange[i + 1] - inputRange[i]) *
              (outputRange[i + 1] - outputRange[i]);
    }
  }

  return 0.0;
}

Extrapolate _getExtrapolate(
  Extrapolate? extrapolate, {
  Extrapolate? left,
  Extrapolate? right,
}) {
  if (extrapolate != null) {
    return extrapolate;
  }

  if (left != null) {
    return left;
  }

  if (right != null) {
    return right;
  }

  return Extrapolate.extend;
}
