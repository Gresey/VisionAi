import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets/checkpoint.dart';
import 'widgets/down_arrow.dart';
import 'widgets/left_arrow.dart';
import 'widgets/right_arrow.dart';
import 'widgets/upper_arrow.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Set<Marker> _markers = {};
  TextEditingController _textInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
      if (currentLocation != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
              zoom: 10,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _showPinBottomSheet(LatLng position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Indoor Navigation',
                      style: TextStyle(
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('You dropped a pin at: $position'),
                    SizedBox(height: 20),

                    // Remote-like arrows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Ink(
                              decoration: ShapeDecoration(
                                color: Colors.blueGrey.shade100,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                splashRadius: 30,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpperArrowDialog();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Ink(
                              decoration: ShapeDecoration(
                                color: Colors.blueGrey.shade100,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                splashRadius: 30,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return LeftArrowDialog();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              height: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CheckpointDialog();
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.flag,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Ink(
                              decoration: ShapeDecoration(
                                color: Colors.blueGrey.shade100,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                splashRadius: 30,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RightArrowDialog();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Ink(
                              decoration: ShapeDecoration(
                                color: Colors.blueGrey.shade100,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                splashRadius: 30,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DownArrowDialog();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _sendCoordinatesToBackend(
                            position.latitude, position.longitude);
                      },
                      child: Text(
                        'Send Coordinates',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 10,
        ),
        myLocationEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: (LatLng position) {
          setState(() {
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId(position.toString()),
                position: position,
              ),
            );
          });
          _showPinBottomSheet(position);
        },
        markers: _markers,
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black.withOpacity(0.7),
    textColor: Colors.white,
  );
}

Future<void> sendDirections(List<Map<String, dynamic>> data) async {
  //var url = Uri.parse('http://192.168.95.246:8080/directions');

  var url = Uri.parse('http://192.168.50.246:8080/directions');
  var jsonData = jsonEncode(data);

  try {
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      showToast('Data sent successfully');
      print('Data sent successfully');
    } else {
      showToast('Failed to send successfully');
      print('Failed to send data. Server returned ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending data: $e');
  }
}

void _sendCoordinatesToBackend(double latitude, double longitude) async {
  //var url = Uri.parse('http://192.168.127.246:8080/send-coordinates');

  var url = Uri.parse('http://192.168.50.246:8080/send-coordinates');

  var response = await http.post(
    url,
    body: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    },
  );

  if (response.statusCode == 200) {
    print('Coordinates sent successfully!');
  } else {
    print('Failed to send coordinates');
  }
}
