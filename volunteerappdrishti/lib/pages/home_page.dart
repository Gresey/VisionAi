import 'package:flutter/material.dart';
import 'package:volunteerappdrishti/pages/connect_page.dart';
import 'package:volunteerappdrishti/pages/mark_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, String? ipAddress})
      : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  final screens = [
    ConnectScreen(),
    MapScreen(),
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
                Icons.person_2_rounded,
                color: Colors.black,
              ),
              label: 'Connect',
              selectedIcon: Icon(
                Icons.person_2_rounded,
                color: Colors.black,
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              label: 'Map',
              selectedIcon: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
