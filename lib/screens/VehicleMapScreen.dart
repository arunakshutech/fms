import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleMapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> vehiclesData;

  VehicleMapScreen({required this.vehiclesData});

  @override
  _VehicleMapScreenState createState() => _VehicleMapScreenState();
}

class _VehicleMapScreenState extends State<VehicleMapScreen> {
  late GoogleMapController _mapController;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    for (var vehicle in widget.vehiclesData) {
      final marker = Marker(
        markerId: MarkerId(vehicle['vehicleId'].toString()),
        position: LatLng(vehicle['latitude'], vehicle['longitude']),
        infoWindow: InfoWindow(
          title: vehicle['vehicleNumber'],
          snippet: vehicle['lastLocation'],
        ),
      );
      _markers.add(marker);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.vehiclesData.isNotEmpty ? widget.vehiclesData[0]['latitude'] : 0.0,
            widget.vehiclesData.isNotEmpty ? widget.vehiclesData[0]['longitude'] : 0.0,
          ),
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }
}
