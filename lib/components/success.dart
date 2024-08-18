import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showSuccessToast(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    backgroundColor: const Color.fromARGB(255, 8, 150, 43),
    textColor: Colors.white,
    fontSize: 16.0,
    
  );
}
