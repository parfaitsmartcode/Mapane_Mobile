import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/screens/home_page.dart';
import 'package:mapane/screens/monCompte.dart';
import 'package:mapane/screens/welcome_map.dart';


class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });
  static final Widget svg = SvgPicture.asset(
      Assets.historyIcon,
  );
  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: WelcomeMap(),
      icon: Icon(
        Icons.navigation_outlined,
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
      page: MonCompte(),
      icon: Icon(Icons.account_circle_outlined,
        size: 40.0,
      ),
      title: CircleAvatar(
        radius: 3.0,
      ),
    ),
  ];
}