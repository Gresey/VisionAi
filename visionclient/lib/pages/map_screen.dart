import 'dart:async';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMaps;
import 'package:lottie/lottie.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMaps.GoogleMapController mapController;
  LocationData? currentLocation;
  bool isLoading = true;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  Set<GoogleMaps.Marker> _markers = {}; 

  void _onMapCreated(GoogleMaps.GoogleMapController controller) {
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _startPeriodicPost();
  }

  void _getUserLocation() async {
    var location = Location();
    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
        _markers.add(
          GoogleMaps.Marker(
            markerId: GoogleMaps.MarkerId("userLocation"),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: GoogleMaps.InfoWindow(
              title: "You are here",
            ),
          ),
        );
        isLoading = false; 
      });
    } catch (e) {
      print("Error getting location: $e");
      isLoading = false; 
    }
  }

  void _startPeriodicPost() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      String ipAddress = Provider.of<IpAddress>(context, listen: false).ipAddress ?? 'localhost';
      if (currentLocation != null) {
        try {
          final response = await http.post(
            Uri.parse('http://$ipAddress:8080/user_location'),
            body: {
              'latitude': currentLocation!.latitude.toString(),
              'longitude': currentLocation!.longitude.toString(),
            },
          );
          if (response.statusCode == 200) {
            print('Location sent successfully');
          } else {
            print('Failed to send location');
          }
        } catch (e) {
          print('Error sending location: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                if (currentLocation != null)
                  GoogleMaps.GoogleMap(
                    mapType: GoogleMaps.MapType.satellite,
                    zoomControlsEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: GoogleMaps.CameraPosition(
                      target: LatLng(
                        currentLocation!.latitude ?? _center.latitude,
                        currentLocation!.longitude ?? _center.longitude,
                      ),
                      zoom: 14.0,
                    ),
                    markers: _markers,
                  ),
                if (isLoading)
                  Center(
                    child: Lottie.asset(
                      'assets/animations/location.json',
                      height: 200.0,
                      width: 200.0
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

