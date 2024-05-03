import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'bottom_sheet.dart';

class VideoConnectScreen extends StatefulWidget {
  final String ipAddress; // Add ipAddress parameter

  const VideoConnectScreen({Key? key, required this.ipAddress})
      : super(key: key);

  @override
  State<VideoConnectScreen> createState() => _VideoConnectScreenState();
}

class _VideoConnectScreenState extends State<VideoConnectScreen> {
  late WebSocketChannel _channel;
  bool _isConnected = false;
  late Timer _timer;
  String _userLocation = '';
  LatLng? _markerPosition;
  Set<Marker> _markers = {};

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _connect();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _getLocation();
    });
  }

  @override
  void dispose() {
    _disconnect();
    _timer.cancel();
    super.dispose();
  }

  void _connect() {
    _channel =
        IOWebSocketChannel.connect(Uri.parse("ws://${widget.ipAddress}:3050"));
    setState(() {
      _isConnected = true;
    });
  }

  void _disconnect() {
    _channel.sink.close();
    setState(() {
      _isConnected = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _getLocation() async {
    try {
      // final response = await http.get(Uri.parse(
      //     "http://192.168.95.67:8080/get_location")); //backend this machine
      final response = await http.get(Uri.parse(
          "http://192.168.50.246:8080/get_location")); //backend this machine

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double latitude = double.parse(data['latitude'].toString());
        double longitude = double.parse(data['longitude'].toString());
        setState(() {
          _userLocation = 'Latitude: $latitude, Longitude: $longitude';
          _markerPosition = LatLng(latitude, longitude);
          _markers.clear();
          _markers.add(Marker(
            markerId: MarkerId('user_location'),
            position: _markerPosition!,
          ));
        });
      } else {
        throw Exception('Failed to fetch location');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _openModalSheet(BuildContext context) async {
    try {
      // final response =
      //     await http.get(Uri.parse("http://192.168.95.67:8080/user_info"));
      final response =
          await http.get(Uri.parse("http://192.168.50.246:8080/user_info"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String userInfoText = data['text'];

        // Show the bottom modal sheet with the fetched text
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BottomModalSheet(userInfoText: userInfoText);
          },
        );
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch user info'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Live Video"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openModalSheet(context);
          },
          child: Icon(Icons.info),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: _isConnected
                      ? StreamBuilder(
                          stream: _channel.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                  child: const CircularProgressIndicator());
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return const Center(
                                child: Text("Connection Closed !"),
                              );
                            }
                            //? Working for single frames
                            return Image.memory(
                              Uint8List.fromList(
                                base64Decode(
                                  (snapshot.data.toString()),
                                ),
                              ),
                              gaplessPlayback: true,
                            );
                          },
                        )
                      : const Text("Initiate Connection"),
                ),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _markerPosition ?? _center,
                      zoom: 1.0,
                    ),
                    markers: _markers,
                  ),
                ),
                Text(_userLocation),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
