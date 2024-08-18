import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../components/vehicle_card.dart';

class VehicleSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
      future: _searchVehicles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No vehicles found.'));
        }

        final vehicles = snapshot.data!;

        return ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return VehicleCard(
              vehicleNumber: vehicle.vehicleNumber,
              status: vehicle.status,
              lastUpdate: vehicle.vehicleNumber, // Replace with actual data
              lastLocation: vehicle.lastLocation, // Replace with actual data
              todaysStops: 'Stops info', // Replace with actual data
              todaysKm: 'KM info', // Replace with actual data
              batteryStatus: 'Battery info', // Replace with actual data
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
      future: _searchVehicles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No vehicles found.'));
        }

        final vehicles = snapshot.data!;

        return ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return ListTile(
              title: Text(vehicle.vehicleNumber),
              onTap: () {
                query = vehicle.vehicleNumber;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }

  Future<List<Vehicle>> _searchVehicles(String query) async {
    try {
      // Fetch the full vehicle list
      List<Vehicle> allVehicles = await fetchVehicleList();

      // Filter the list based on the query
      return allVehicles
          .where((vehicle) => vehicle.vehicleNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching vehicles: $e');
      return [];
    }
  }
}
