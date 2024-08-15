// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final void Function(String status) onStatusSelected;

  const StatusButton({
    super.key, 
    required this.label,
    required this.isSelected,
    required this.onStatusSelected, required int count,
  });

  @override
  // ignore: library_private_types_in_public_api
  _StatusButtonState createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 9.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return widget.isSelected 
                  ? const Color.fromARGB(255, 248, 246, 120) // Selected color
                  : const Color.fromARGB(255, 255, 251, 251); // Default color
            },
          ),
          animationDuration: const Duration(milliseconds: 200), // Animation for color change
        ),
        onPressed: () {
          widget.onStatusSelected(widget.label);
        },
        child: Text(widget.label,style: const TextStyle(color: Colors.black),),
      ),
    );
  }
}
