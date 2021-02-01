import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier{

  Color  bottomBarColor ;
  bool widgetToDisplay;

  BottomBarProvider(){
    this.bottomBarColor = Colors.white.withOpacity(0.3);
    this.widgetToDisplay = false;
  }

  modifyColor(Color newColor){
    this.bottomBarColor = newColor;
    notifyListeners();
  }

  setWidget(bool settings){
    this.widgetToDisplay = settings;
    notifyListeners();
  }
}