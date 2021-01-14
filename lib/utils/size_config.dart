import 'package:flutter/material.dart';

getSize(taille, type, resp) {
  double size = 0;
  if (type == "width") {
    size = MediaQuery.of(resp).size.width * (taille / 375);
  } else {
    size = MediaQuery.of(resp).size.height * (taille / 667);
  }
  return size;
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}
