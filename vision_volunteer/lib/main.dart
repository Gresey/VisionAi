import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _ipAddress;

  @override
  void initState() {
    super.initState();
    _getIpAddress();
  }

  Future<void> _getIpAddress() async {
    final NetworkInfo networkInfo = NetworkInfo();
    final String? ipAddress = await networkInfo.getWifiIP();
    setState(() {
      _ipAddress = ipAddress;
    });
    print('User IP Address: $_ipAddress');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Cairo",
      ),
      home: MyHomePage(
        title: 'Drishti Volunteer App',
        ipAddress: _ipAddress,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
