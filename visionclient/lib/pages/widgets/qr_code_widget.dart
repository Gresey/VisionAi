import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:network_info_plus/network_info_plus.dart';

class QrCodeWidget extends StatefulWidget {
  @override
  _QrCodeWidgetState createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  String ipAddress = 'Fetching IP...';

  @override
  void initState() {
    super.initState();
    _getIpAddress();
  }

  Future<void> _getIpAddress() async {
    try {
      await Permission.location.request();
      final info = NetworkInfo();
      String? ipAddressResult = await info.getWifiIP();
      setState(() {
        ipAddress = ipAddressResult!;
      });
    } catch (e) {
      print('Error getting IP address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(
            data: ipAddress,
            version: QrVersions.auto,
            size: 200.0,
          ),
          SizedBox(height: 20),
          // Text('Your IP Address: $ipAddress'),
        ],
      ),
    );
  }
}

