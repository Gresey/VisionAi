import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:volunteerappdrishti/pages/widgets/video_call.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  @override
  void initState() {
    super.initState();
    _startServer();
  }

  Future<void> _startServer() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
    await for (var request in server) {
      if (request.method == 'POST' &&
          request.uri.path == '/push_notification') {
        var content = await utf8.decodeStream(request);
        var data = jsonDecode(content);
        _showConfirmationDialog(data['ipAddress']);
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Not Found');
        await request.response.close();
      }
    }
  }

  void _showConfirmationDialog(String ipAddress) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Incoming Connection'),
        content: Text('Do you want to connect to IP address: $ipAddress?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VideoConnectScreen(ipAddress: ipAddress)),
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/Volunteer.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //   },
              //   child: Text('Go to Another Screen'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
