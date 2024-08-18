import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String vehicleNumber;
  final String status;
  final String lastUpdate;
  final String lastLocation;
  final String todaysStops;
  final String todaysKm;
  final String batteryStatus;

  const VehicleCard({
    required this.vehicleNumber,
    required this.status,
    required this.lastUpdate,
    required this.lastLocation,
    required this.todaysStops,
    required this.todaysKm,
    required this.batteryStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 220, 232, 255),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Icon and Status Row
            Row(
              children: [
                const Icon(
                  Icons.directions_car, // Vehicle icon
                  size: 40,
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Vehicle No: $vehicleNumber',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusButton(status),
              ],
            ),
            const SizedBox(height: 16),
            // Data Table
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FixedColumnWidth(150.0),
                1: FlexColumnWidth(),
              },
              children: [
                _buildTableRow('Last Update', lastUpdate),
                _buildTableRow('Last Location', lastLocation),
                _buildTableRow("Today's Stops", todaysStops),
                _buildTableRow("Today's KM", todaysKm),
              ],
            ),
            const SizedBox(height: 16.0),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.battery_charging_full_rounded,
                    size: 30.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // Battery status icon action
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.warning_amber_rounded,
                    size: 30.0,
                  ),
                  onPressed: () {
                    // Show full-screen bottom sheet on details icon click
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => _buildBottomSheet(context),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_pin,
                    size: 30.0,
                  ),
                  onPressed: () {
                    // Map icon action
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    size: 30.0,
                  ),
                  onPressed: () {
                    // Share icon action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the status button
  Widget _buildStatusButton(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Running':
        backgroundColor = const Color.fromARGB(255, 62, 152, 65);
        textColor = Colors.white;
        break;
      case 'Stopped':
        backgroundColor = const Color.fromARGB(255, 255, 106, 95);
        textColor = Colors.white;
        break;
      case 'NRD':
        backgroundColor = const Color.fromARGB(255, 62, 62, 62);
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 3.0),
      ),
      onPressed: () {
        // Status button action
      },
      child: Text(
        status,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Method to build the bottom sheet
  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 1.0,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                'Vehicle Details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FixedColumnWidth(150.0),
                  1: FlexColumnWidth(),
                },
                children: [
                  _buildTableRow('Vehicle Number', vehicleNumber),
                  _buildTableRow('Status', status),
                  _buildTableRow('Last Update', lastUpdate),
                  _buildTableRow('Last Location', lastLocation),
                  _buildTableRow("Today's Stops", todaysStops),
                  _buildTableRow("Today's KM", todaysKm),
                  _buildTableRow('Battery Status', batteryStatus),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to create a table row
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
