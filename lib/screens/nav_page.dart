import "package:flutter/material.dart";
import 'package:mapane/custom/widgets/navigation.dart';

class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  static int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true, // very important as noted
        backgroundColor: Colors.red,
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
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
        ), // here you make use of the transparent bar.
        body: Container(),
    );
  }
}
