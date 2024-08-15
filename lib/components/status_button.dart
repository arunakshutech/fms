import 'package:flutter/material.dart';

class StatusButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final void Function(String status) onStatusSelected;
  final int count;

  const StatusButton({
    super.key, 
    required this.label,
    required this.isSelected,
    required this.onStatusSelected,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onStatusSelected(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            '$label (${count > 0 ? count : ''})',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
