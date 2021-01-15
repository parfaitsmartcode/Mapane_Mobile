import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  static int _selectedIndex = 0;

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBar> {
  void _onItemTapped(int index) {
    setState(() {
      NavigationBar._selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: NavigationBar._selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Color(0x00ffffff),
        // transparent
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            title: Text('Level'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notification'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Achievments'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}