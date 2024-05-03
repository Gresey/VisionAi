import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckpointDialog extends StatefulWidget {
  @override
  _CheckpointDialogState createState() => _CheckpointDialogState();
}

class _CheckpointDialogState extends State<CheckpointDialog> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 10,
      shadowColor: Colors.grey, // Set the shadow color
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Rounded corners for the dialog
      ),
      title: Text("Checkpoint Dialog"),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Enter data'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            String data = _controller.text;
            if (data.isNotEmpty) {
              await _sendDataToServer(data);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter data')),
              );
            }
          },
          child: Text('Done'),
        ),
      ],
    );
  }

  Future<void> _sendDataToServer(String data) async {
    //  var url = Uri.parse('http://192.168.127.246:8080/checkpoint');
    var url = Uri.parse('http://192.168.50.246:8080/checkpoint');
    var response = await http.post(
      url,
      body: {'data': data},
    );

    if (response.statusCode == 200) {
      // Successfully sent data to the server
      print('Data sent successfully!');
    } else {
      // Failed to send data to the server
      print('Failed to send data');
    }
  }
}
