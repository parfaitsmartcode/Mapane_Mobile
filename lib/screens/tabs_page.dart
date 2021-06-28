import 'package:flutter/material.dart';
import 'package:mapane/custom/widgets/tab_navigation_item.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/state/place_provider.dart';
import 'package:provider/provider.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:flutter/services.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: context.watch<BottomBarProvider>().currentIndex,
          children: [
            for (final tabItem in TabNavigationItem.items) tabItem.page,
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          backgroundColor: context.watch<BottomBarProvider>().bottomBarColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: context.watch<BottomBarProvider>().currentIndex,
          onTap: (int index) {
            context.read<BottomBarProvider>().modifyIndex(index);
            if (index == 0) {
              context
                  .read<AlertProvider>()
                  .getAlertByUser("5ff34b88af0f1982ab03f3f9");
              context.read<AlertProvider>().getAlertByUserCat("All", 1,context.read<PlaceProvider>().userPlace.fold((l) => null, (r) => r.state).toString());
            }
          },
          items: [
            for (int i = 0; i < TabNavigationItem.items.length; i++)
              BottomNavigationBarItem(
                icon: TabNavigationItem.items[i].icon,
                title: context.watch<BottomBarProvider>().currentIndex == i
                    ? TabNavigationItem.items[i].title
                    : Container(),
              )
          ],
        ),
      ),
    );
  }
}
