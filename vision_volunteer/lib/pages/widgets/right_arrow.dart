import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RightArrowDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String text = '';

    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 10,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
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
                // Uri.parse('http://192.168.127.246:8080/right-arrow'),

                Uri.parse('http://192.168.50.246:8080/right-arrow'),
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
