import 'map_screen.dart';
import 'package:flutter/material.dart';
import 'settings_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  final screens = [
    MapScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          indicatorColor: Colors.grey[400],
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.black,
              ),
              label: 'Home',
              selectedIcon: Icon(
                Icons.home_filled,
                color: Colors.black,
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ),
              label: 'Settings',
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
