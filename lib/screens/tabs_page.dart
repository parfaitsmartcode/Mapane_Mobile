import 'package:flutter/material.dart';
import 'package:mapane/custom/widgets/tab_navigation_item.dart';


class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (int i=0; i<TabNavigationItem.items.length; i++)
            BottomNavigationBarItem(
              icon: TabNavigationItem.items[i].icon,
              title: _currentIndex == i  ? TabNavigationItem.items[i].title : Container(),
            )
        ],
      ),
    );
  }
}