import 'package:flutter/material.dart';
import '../components/status_button.dart';

class VehicleStatusFilter extends StatelessWidget {
  final void Function(String status) onStatusSelected;
  final String selectedStatus;
  final Map<String, int> statusCounts;

  const VehicleStatusFilter({
    super.key, 
    required this.onStatusSelected,
    required this.selectedStatus,
    required this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding:EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          StatusButton(
            label: 'All',
            isSelected: selectedStatus == 'All',
            onStatusSelected: onStatusSelected,
            count: statusCounts['totalVehicles'] ?? 0,
          ),
          StatusButton(
            label: 'Running',
            isSelected: selectedStatus == 'Running',
            onStatusSelected: onStatusSelected,
            count: statusCounts['runningVehicles'] ?? 0,
          ),
          StatusButton(
            label: 'Stopped',
            isSelected: selectedStatus == 'Stopped',
            onStatusSelected: onStatusSelected,
            count: statusCounts['stoppedVehicles'] ?? 0,
          ),
          StatusButton(
            label: 'NRD',
            isSelected: selectedStatus == 'NRD',
            onStatusSelected: onStatusSelected,
            count: statusCounts['nrdVehicles'] ?? 0,
          ),
          StatusButton(
            label: 'Untracked',
            isSelected: selectedStatus == 'Untracked',
            onStatusSelected: onStatusSelected,
            count: statusCounts['untrackedVehicles'] ?? 0,
          ),
        ],
      
      ),
    );
  }
}
