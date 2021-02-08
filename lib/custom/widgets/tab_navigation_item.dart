import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/custom/icons/my_flutter_app_icons.dart';
import 'package:mapane/screens/home_page.dart';
import 'package:mapane/screens/monCompte.dart';
import 'package:mapane/screens/welcome_map.dart';
import 'package:mapane/screens/monCompte.dart';
import 'package:mapane/utils/hexcolor.dart';


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
      MyFlutterApp.history_icon,
        size: 40.0,
      ),
      title: CircleAvatar(
        backgroundColor: HexColor("#A7BACB"),
        radius: 3.0,
      ),
    ),
    TabNavigationItem(
      page: HomePage(),
      icon: Icon(
          MyFlutterApp.map_icon,
        size: 40.0,
      ),
      title: CircleAvatar(
        backgroundColor: HexColor("#A7BACB"),
        radius: 3.0,
      ),
    ),
    TabNavigationItem(
      page: MonCompte(),
      icon: Icon(MyFlutterApp.profile_icon,
        size: 40.0,
      ),
      title: CircleAvatar(
        backgroundColor: HexColor("#A7BACB"),
        radius: 3.0,
      ),
    ),
  ];
}