import 'package:flutter/material.dart';

class CategoryStateProvider extends ChangeNotifier{

  String cate = "";

  modifyCat(String newCat){
    this.cate = cate;
    notifyListeners();
  }
}