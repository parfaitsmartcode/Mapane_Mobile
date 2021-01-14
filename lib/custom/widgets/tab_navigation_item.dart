import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mapane/screens/home_page.dart';


class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: HomePage(),
      icon: Icon(Icons.explore,
        size: 40.0,
      ),
      title: CircleAvatar(
        radius: 3.0,
      ),
    ),
    TabNavigationItem(
      page: HomePage(),
      icon: Icon(
          Icons.explore,
        size: 40.0,
      ),
      title: CircleAvatar(
        radius: 3.0,
      ),
    ),
    TabNavigationItem(
      page: HomePage(),
      icon: Icon(Icons.account_circle_outlined,
        size: 40.0,
      ),
      title: CircleAvatar(
        radius: 3.0,
      ),
    ),
  ];
}