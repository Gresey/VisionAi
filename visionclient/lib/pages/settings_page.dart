import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top layer: User avatar and user details
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/avatar.jpg'),
                ),
                SizedBox(height: 8),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'JohnDoe',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DeviceStatusContainer(
                    icon: Icons.speaker_group_outlined,
                    heading: 'Device Name',
                    subheading: 'Drishti',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DeviceStatusContainer(
                    icon: Icons.wifi,
                    heading: 'IP Address',
                    subheading: "127.0.0.1",
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DeviceStatusContainer(
                    icon: Icons.link,
                    heading: 'Status',
                    subheading: 'Connected',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DeviceStatusContainer(
                    icon: Icons.battery_5_bar_sharp,
                    heading: 'Battery',
                    subheading: '100%',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class DeviceStatusContainer extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String subheading;

  const DeviceStatusContainer({
    required this.icon,
    required this.heading,
    required this.subheading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(subheading),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              icon,
              size: 30,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
