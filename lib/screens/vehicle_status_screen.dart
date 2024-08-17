import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../widgets/VehicleStatusFilter.dart';
import '../components/vehicle_card.dart'; // Import the new widget

class VehicleStatusScreen extends StatefulWidget {
  const VehicleStatusScreen({super.key});

  @override
  VehicleStatusScreenState createState() => VehicleStatusScreenState();
}

class VehicleStatusScreenState extends State<VehicleStatusScreen>
    with AutomaticKeepAliveClientMixin<VehicleStatusScreen> {
  Map<String, int> statusCounts = {};
  String selectedStatus = 'All';
  List<Vehicle> vehicleList = [];
  List<Vehicle> allVehicles = []; // Cached list of all vehicles

  @override
  void initState() {
    super.initState();
    loadVehicleCounts();
    loadVehicleList();
  }

  Future<void> loadVehicleCounts() async {
    try {
      Map<String, int> counts = await fetchVehicleCounts();
      setState(() {
        statusCounts = counts;
      });
    } catch (e) {
      print('Error loading vehicle counts: $e');
    }
  }

  Future<void> loadVehicleList() async {
    try {
      List<Vehicle> vehicles = await fetchVehicleList();
      setState(() {
        allVehicles = vehicles; // Cache the list
        vehicleList = vehicles; // Initially display all vehicles
      });
    } catch (e) {
      print('Error loading vehicle list: $e');
    }
  }

  void onStatusSelected(String status) {
    setState(() {
      selectedStatus = status;
      filterVehicleList();
    });
  }

  void filterVehicleList() {
    setState(() {
      if (selectedStatus == 'All') {
        vehicleList = allVehicles;
      } else {
        vehicleList = allVehicles
            .where((vehicle) => vehicle.status == selectedStatus)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required when using AutomaticKeepAliveClientMixin
    return Column(
      children: [
        VehicleStatusFilter(
          onStatusSelected: onStatusSelected,
          selectedStatus: selectedStatus,
          statusCounts: statusCounts,
        ),
        Expanded(
          child: vehicleList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: vehicleList.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicleList[index];
                    return VehicleCard(
                      vehicleNumber: vehicle.vehicleNumber,
                      status: vehicle.status,
                      lastUpdate: 'Last update info', // Replace with actual data
                      lastLocation: 'Last location info', // Replace with actual data
                      todaysStops: 'Stops info', // Replace with actual data
                      todaysKm: 'KM info', // Replace with actual data
                      batteryStatus: 'Battery info', // Replace with actual data
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true; // Keeps the state alive
}
