import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'widgets/qr_code_widget.dart';
import 'home_page.dart';

class IpAddress extends ChangeNotifier {
  String? ipAddress;

  void setIpAddress(String ip) {
    ipAddress = ip;
    notifyListeners();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HttpServer? server;

  @override
  void initState() {
    super.initState();
    startServer();
  }

  void startServer() async {
    server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      8080,
    );

    print('Server listening on port ${server!.port}');

    await for (HttpRequest request in server!) {
      if (request.method == 'POST' && request.uri.path == '/login') {
        String ipAddress = await utf8.decodeStream(request);
        await server!.close();

        print(ipAddress);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: 'Drishti',
                  )),
        );

        Provider.of<IpAddress>(context, listen: false).setIpAddress(ipAddress);

        request.response
          ..statusCode = HttpStatus.ok
          ..write('Login successful!')
          ..close();
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('Not Found')
          ..close();
      }
    }
  }

  @override
  void dispose() {
    server?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Drishti',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            Text(
              'innovate for good',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20),
            QrCodeWidget(),
            SizedBox(height: 20),
            Text(
              'Scan the QR with your glasses to continue',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
