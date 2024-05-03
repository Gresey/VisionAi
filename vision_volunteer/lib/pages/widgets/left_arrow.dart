import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeftArrowDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String text = '';

    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 10,
      shadowColor: Colors.grey, // Set the shadow color
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Rounded corners for the dialog
      ),
      title: Text("Describe The Angle"),
      content: TextFormField(
        onChanged: (value) {
          text = value;
        },
        decoration: InputDecoration(
          labelText: 'Enter text',
        ),
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
            if (text.isNotEmpty) {
              var response = await http.post(
                //Uri.parse('http://192.168.127.246:8080/left-arrow'),

                Uri.parse('http://192.168.50.246:8080/left-arrow'),
                body: {'text': text},
              );

              print(response.body);
            }
            Navigator.of(context).pop();
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}
