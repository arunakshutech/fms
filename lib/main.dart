import 'package:flutter/material.dart';
import './routes/manage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteManager(); // Use RouteManager for routing
  }
}
