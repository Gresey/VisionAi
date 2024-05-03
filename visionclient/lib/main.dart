import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IpAddress>(
          create: (_) => IpAddress(),
        ),
      ],
      child: MaterialApp(
        home: LoginPage(),
      ),
    );
  }
}
