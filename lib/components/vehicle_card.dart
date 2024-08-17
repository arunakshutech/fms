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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Icon and Status Column
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.directions_car, // Vehicle icon
                  size: 40,
                  color: Colors.blue,
                ),
                SizedBox(height: 8),
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == 'Running' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            // Vehicle Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle: $vehicleNumber',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Last Update: $lastUpdate'),
                  SizedBox(height: 4),
                  Text('Last Location: $lastLocation'),
                  SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Today's Stops: $todaysStops"),
                      Text("Today's KM: $todaysKm"),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.battery_6_bar_outlined),
                            onPressed: () {
                              // Details icon action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.details),
                            onPressed: () {
                              // Details icon action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.map),
                            onPressed: () {
                              // Map icon action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              // Share icon action
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
