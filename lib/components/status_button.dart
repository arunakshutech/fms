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
    // Determine button color based on label
    Color buttonColor;
    Color textColor;

    switch (label.toLowerCase()) {
      case 'all':
        buttonColor = Colors.blue;
        textColor = Colors.white;
        break;
      case 'stopped':
        buttonColor = Colors.red;
        textColor = Colors.white;
        break;
      case 'nrd':
        buttonColor = Colors.grey;
        textColor = Colors.white;
        break;
      case 'running':
        buttonColor = const Color.fromARGB(255, 4, 127, 0);
        textColor = Colors.white;
        break;
      case 'untracked':
        buttonColor = const Color.fromARGB(255, 255, 230, 3);
        textColor = Colors.black;
        break;
      default:
        buttonColor = Colors.grey[300]!; // Default color if label doesn't match any case
        textColor = Colors.black;
    }

    return GestureDetector(
      onTap: () => onStatusSelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? buttonColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            '$label (${count > 0 ? count : ''})',
            style: TextStyle(
              color: isSelected ? textColor : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
