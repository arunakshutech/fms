import 'dart:convert';  // For JSON encoding and decoding
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // For displaying toast messages
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vibration/vibration.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();  // Added semicolon

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
    // Check if the device can vibrate
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100); // Trigger vibration
    }
      // No toast is shown
    } catch (e) {
      print('your mobile didnt have vibration ');
    }

    final Map<String, dynamic> payload = {
      "filterdata": {
        "userName": email,
        "password": password,
        "appCode": 7,
        "fcmId": "",
        "deviceUniqueId": "[object Object]",
        "deviceManufacturer": "[object Object]",
        "deviceModel": "V2153",
        "deviceOS": "Android",
        "deviceOSVerison": "14",
        "serverName": "Select Customer",
        "isEncrypted": 1
      },
      "requst": "post/json/authenticate"
    };

    try {
      final response = await _dio.post(
        'http://46.137.253.200:4000/loginUserAuth',
        data: jsonEncode(payload),  // Ensures the payload is encoded as JSON
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['status']) {
          String message = responseData['message'];
          _showSuccessToast(message);

          String userdata = jsonEncode(responseData['data']);
          await _secureStorage.write(key: 'userdata', value: userdata);
          print('data stored in securelocal storage');

          widget.onLoginSuccess();
        } else {
          String message = responseData['message'];
          _showErrorToast(message);
        }
      } else {
        _showErrorToast('Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showErrorToast('An error occurred. Please try again.');
      debugPrint('Login Error: $e');
    }
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: const Color.fromARGB(255, 0, 179, 45),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const StaticBlurredBackground(),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                backgroundBlendMode: BlendMode.overlay,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/logo.png', width: 150.0, height: 150.0),
                  const SizedBox(height: 20.0),
                  _buildGlassTextField('Email', controller: _emailController),
                  const SizedBox(height: 10.0),
                  _buildGlassTextField('Password', controller: _passwordController, obscureText: true),
                  const SizedBox(height: 20.0),
                  _buildGlassyButton('Login', _login),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(183, 0, 0, 0),
    );
  }

  Widget _buildGlassTextField(String hintText, {required TextEditingController controller, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }

  Widget _buildGlassyButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 90.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(1),
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class StaticBlurredBackground extends StatelessWidget {
  const StaticBlurredBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 10.0),
        child: Container(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
        ),
      ),
    );
  }
}
