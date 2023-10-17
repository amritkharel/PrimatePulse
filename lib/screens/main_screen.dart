import 'package:final_app/screens/detail_screen.dart';
import 'package:final_app/screens/home_screen.dart';
import 'package:final_app/screens/home_screen_test.dart';
import 'package:final_app/screens/login_screen.dart';
import 'package:final_app/screens/profile.dart';
import 'package:final_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'favorite_screen_futurebuilder.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const id = "main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isFavoriteView = false;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreenTest(isFavoriteView: false),
    const FavoriteScreenFutureBuilder(),
    //DetailScreen(),
    const ProfileViewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[100],
        onTap: (index) {
          setState(() {
            _selectedIndex= index;
            isFavoriteView = index==1;
          });
        },
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            activeIcon: Icon(Icons.favorite_border_outlined),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
