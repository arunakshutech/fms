import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../widgets/VehicleStatusFilter.dart';

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
    filterVehicleList();
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
                    return ListTile(
                      title: Text(vehicle.name),
                      subtitle: Text('Status: ${vehicle.status}'),
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

// Define the Vehicle class if not already defined
class Vehicle {
  final String name;
  final String status;

  Vehicle({required this.name, required this.status});
}

// Example fetchVehicleList function
Future<List<Vehicle>> fetchVehicleList() async {
  // Simulate network delay
  return [
    Vehicle(name: 'Vehicle 1', status: 'Running'),
    Vehicle(name: 'Vehicle 2', status: 'Stopped'),
    Vehicle(name: 'Vehicle 3', status: 'Stopped'),
    Vehicle(name: 'Vehicle 4', status: 'Stopped'),
    Vehicle(name: 'Vehicle 5', status: 'NRD'),
    Vehicle(name: 'Vehicle 6', status: 'NRD'),
    Vehicle(name: 'Vehicle 7', status: 'Untracked'),
    Vehicle(name: 'Vehicle 8', status: 'Untracked'),
    Vehicle(name: 'Vehicle o', status: 'NRD'),

    // Add more vehicles
  ];
}
