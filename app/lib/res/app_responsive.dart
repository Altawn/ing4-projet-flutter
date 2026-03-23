import 'package:flutter/material.dart';

/// Helper to make dimensions responsive based on a reference screen size (iPhone X: 375x812).
class AppResponsive {
  static const double referenceWidth = 375.0;
  static const double referenceHeight = 812.0;

  static double _getScaleFactor(BuildContext context) {
    double widthScale = MediaQuery.of(context).size.width / referenceWidth;
    double heightScale = MediaQuery.of(context).size.height / referenceHeight;

    // On tablets (like iPad), we don't want the UI to be massive.
    // We use the smaller scale and cap it.
    double factor = widthScale < heightScale ? widthScale : heightScale;
    return factor > 1.25 ? 1.25 : factor;
  }

  /// Returns a width adjusted to the current screen width.
  static double w(BuildContext context, double value) {
    return _getScaleFactor(context) * value;
  }

  /// Returns a height adjusted to the current screen height.
  static double h(BuildContext context, double value) {
    return _getScaleFactor(context) * value;
  }

  /// Returns a responsive font size.
  static double sp(BuildContext context, double value) {
    return _getScaleFactor(context) * value;
  }
}
