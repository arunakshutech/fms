import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './screens/login_screen.dart';
import 'screens/home_screen.dart';

class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'FMS Lite 1.0.0',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout from this device'),
            onTap: () async {
              await _showLogoutDialog(context, false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout from all devices'),
            onTap: () async {
              await _showLogoutDialog(context, true);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, bool isLogoutFromAll) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: Text(isLogoutFromAll
              ? 'Are you sure you want to logout from all devices?'
              : 'Are you sure you want to logout from this device?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _logout(isLogoutFromAll, context);
              },
            ),
          ],
        );
      },
    );
  }

Future<void> _logout(bool isLogoutFromAll, BuildContext context) async {
  const storage = FlutterSecureStorage();

  // Retrieve userdata JSON from secure storage
  String? userdataJson = await storage.read(key: 'userdata');

  if (userdataJson != null && userdataJson.isNotEmpty) {
    try {
      // Deserialize the JSON string into a Map
      Map<String, dynamic> userdata = jsonDecode(userdataJson);

      // Access userId, appCode, and loginHistoryId from the userdata map
      int? userId = userdata['userId'];
      int? appCode = userdata['appCode'];
      int? loginHistoryId = userdata['loginHistoryId'];

      // Check if loginHistoryId is available
      if (loginHistoryId == null && !isLogoutFromAll) {
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login history ID not found.')),
          );
        }
        return;
      }

      // Prepare the payload
      String payload = jsonEncode({
        "filterdata": jsonEncode({
          "userId": userId,
          "appCode": appCode,
          "loginHistoryId": isLogoutFromAll ? -1 : loginHistoryId
        }),
        "requst": "post/json/user/logout"
      });

      String apiUrl = 'http://46.137.253.200:4000/callOut';

      // Make the API call
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          await storage.deleteAll(); // Clear secure storage on logout
          if (mounted) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(onLoginSuccess: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }),
              ),
            );
          }
        } else {
          if (mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Logout failed')),
            );
          }
        }
      } else {
        if (mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to communicate with server.')),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  } else {
    if (mounted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not found.')),
      );
    }
  }
}
}