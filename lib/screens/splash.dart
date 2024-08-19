// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _colorTween = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_controller);

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
  // Step 1: Retrieve userdata from secure storage
  String? userdataJson = await _secureStorage.read(key: 'userdata');

  if (userdataJson != null && userdataJson.isNotEmpty) {
    try {
      // Step 2: Deserialize the JSON string into a Map
      Map<String, dynamic> userdata = jsonDecode(userdataJson);
      
      // Step 3: Access loginHistoryId from the userdata map
      int? loginHistoryId = userdata['loginHistoryId'];
      
      print('Login History ID: $loginHistoryId');

      if (loginHistoryId != null) {
        // Proceed with checking if the user is logged in
        final Map<String, dynamic> payload = {
          "filterdata": {
            "loginHistoryId": loginHistoryId,
          },
          "requst": "post/json/user/isUserLoggedIn"
        };

        try {
          final response = await _dio.post(
            'http://46.137.253.200:4000/checkLog',
            data: jsonEncode(payload),
            options: Options(
              headers: {'Content-Type': 'application/json'},
            ),
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = response.data;
            print(responseData);
            if (responseData['status'] && responseData['data']['isUserLoggedIn'] == 1) {
              if (!mounted) return;
              // User is logged in, navigate to home screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else {
              if (!mounted) return;
              // User is not logged in, navigate to login screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                })),
              );
            }
          } else {
            if (!mounted) return;
            // If there is an issue, navigate to login screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              })),
            );
          }
        } catch (e) {
          if (!mounted) return;
          // Handle the error, and navigate to login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            })),
          );
        }
      } else {
        if (!mounted) return;
        // If loginHistoryId is not found, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          })),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Handle JSON parsing error
      print('Error parsing userdata JSON: $e');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        })),
      );
    }
  } else {
    if (!mounted) return;
    // If userdata is not found or empty, navigate to login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      })),
    );
  }
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_colorTween.value!, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpringAnimationLogo(),
              const SizedBox(height: 20, width: 30),
              const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0), // Loading progress bar
            ],
          ),
        ),
      ),
    );
  }
}

class SpringAnimationLogo extends StatefulWidget {
  @override
  _SpringAnimationLogoState createState() => _SpringAnimationLogoState();
}

class _SpringAnimationLogoState extends State<SpringAnimationLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _logoAnimation,
      child: Image.asset('assets/logo.png', width: 250.0, height: 100.0), // Replace with your logo path
    );
  }
}
