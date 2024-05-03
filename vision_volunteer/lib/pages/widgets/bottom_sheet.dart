import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class BottomModalSheet extends StatefulWidget {
  final String userInfoText;

  const BottomModalSheet({Key? key, required this.userInfoText})
      : super(key: key);

  @override
  _BottomModalSheetState createState() => _BottomModalSheetState();
}

class _BottomModalSheetState extends State<BottomModalSheet> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
  }

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: await _getAudioFilePath());
  }

  Future<String> _getAudioFilePath() async {
    final downloadsDirectory = await getExternalStorageDirectory();
    return '${downloadsDirectory!.path}/audio.mp4';
  }

  Future<String> stop() async {
    if (!isRecorderReady) return '';
    final path = await recorder.stopRecorder();
    return path ?? '';
  }

  Future<void> sendAudioToServer(String filePath) async {
    final url = 'http://192.168.50.103:5000/volunteer_audio'; //pi address

    final file = File(filePath);
    if (!file.existsSync()) {
      print('File not found');
      return;
    }

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add the audio file to the request
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: 'audio.mp4',
      ),
    );

    // Send the request
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Audio sent successfully');
    } else {
      print('Failed to send audio: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.userInfoText,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (recorder.isRecording) {
                final filePath = await stop();
                if (filePath.isNotEmpty) {
                  await sendAudioToServer(filePath);
                }
              } else {
                await record();
              }
            },
            child: Icon(
              recorder.isRecording ? Icons.stop : Icons.mic,
              size: 80,
            ),
          ),
        ],
      ),
    );
  }
}
