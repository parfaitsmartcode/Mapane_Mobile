import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier{

  Color  bottomBarColor ;
  bool widgetToDisplay;
  int currentIndex;

  BottomBarProvider(){
    this.bottomBarColor = Colors.white;
    this.widgetToDisplay = false;
    currentIndex = 1;
  }
  modifyIndex(int index){
    currentIndex = index;
    notifyListeners();
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