import 'package:flutter/material.dart';
import '../Service/api_service.dart'; // Ensure this import matches your actual API service file
import '../widgets/VehicleStatusFilter.dart'; // Import the VehicleStatusFilter widget

class VehicleStatusScreen extends StatefulWidget {
  const VehicleStatusScreen({super.key});

  @override
  _VehicleStatusScreenState createState() => _VehicleStatusScreenState();
}

class _VehicleStatusScreenState extends State<VehicleStatusScreen> {
  Map<String, int> _statusCounts = {};
  String _selectedStatus = 'All';
  List<Vehicle> _vehicleList = [];

  @override
  void initState() {
    super.initState();
    _loadVehicleCounts();
    _loadVehicleList();
  }

  Future<void> _loadVehicleCounts() async {
    try {
      Map<String, int> counts = await fetchVehicleCounts();
      setState(() {
        _statusCounts = counts;
      });
    } catch (e) {
      print('Error loading vehicle counts: $e');
    }
  }

  Future<void> _loadVehicleList() async {
    try {
      List<Vehicle> vehicles = await fetchVehicleList();
      setState(() {
        _vehicleList = vehicles;
      });
    } catch (e) {
      print('Error loading vehicle list: $e');
    }
  }

  void _onStatusSelected(String status) {
    setState(() {
      _selectedStatus = status;
      _filterVehicleList();
    });
  }

  void _filterVehicleList() {
    // Implement filtering logic based on _selectedStatus
    // For example, filtering out vehicles based on status
    // Note: You might need to adjust this logic based on how your data is structured

    // Sample filtering logic
    if (_selectedStatus == 'All') {
      _loadVehicleList(); // Reload all vehicles
    } else {
      // Filter based on status
      // Replace with actual filtering logic as needed
      _vehicleList = _vehicleList.where((vehicle) => vehicle.status == _selectedStatus).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VehicleStatusFilter(
          onStatusSelected: _onStatusSelected,
          selectedStatus: _selectedStatus,
          statusCounts: _statusCounts,
        ),
        Expanded(
          child: _vehicleList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _vehicleList.length,
                  itemBuilder: (context, index) {
                    final vehicle = _vehicleList[index];
                    return ListTile(
                      title: Text(vehicle.name),
                      subtitle: Text('Status: ${vehicle.status}'),
                      // Add more details or widgets as needed
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Define a Vehicle class if not already defined
class Vehicle {
  final String name;
  final String status;

  Vehicle({required this.name, required this.status});
}

// Example fetchVehicleList function
Future<List<Vehicle>> fetchVehicleList() async {
  // Replace this with actual API call to fetch vehicles
  // Simulating fetching data
  await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  return [
    Vehicle(name: 'Vehicle 1', status: 'Running'),
    Vehicle(name: 'Vehicle 2', status: 'Stopped'),git 
    // Add more vehicles
  ];