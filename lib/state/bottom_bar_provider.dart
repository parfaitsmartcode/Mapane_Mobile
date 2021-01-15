import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier{

  Color  bottomBarColor ;

  BottomBarProvider(){
    this.bottomBarColor = Colors.white.withOpacity(0.3);
  }

  modifyColor(Color newColor){
    this.bottomBarColor = newColor;
    notifyListeners();
  }
}