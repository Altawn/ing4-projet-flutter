import 'package:flutter/material.dart';


class AppResponsive {
  static const double referenceWidth = 375.0;
  static const double referenceHeight = 812.0;

  static double _getScaleFactor(BuildContext context) {
    double widthScale = MediaQuery.of(context).size.width / referenceWidth;
    double heightScale = MediaQuery.of(context).size.height / referenceHeight;

    
    
    double factor = widthScale < heightScale ? widthScale : heightScale;
    return factor > 1.25 ? 1.25 : factor;
  }

  
  static double w(BuildContext context, double value) {
    return _getScaleFactor(context) * value;
  }

  
  static double h(BuildContext context, double value) {
    return _getScaleFactor(context) * value;
  }

  
  static double sp(BuildContext context, double value) {
    return _getScaleFactor(context) * value;
  }
}
