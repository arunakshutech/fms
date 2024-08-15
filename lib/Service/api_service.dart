import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

Future<Map<String, int>> fetchVehicleCounts() async {
  final Dio dio = Dio();

  // Retrieve userId from secure storage
  String? userdataJson = await _secureStorage.read(key: 'userdata');
  if (userdataJson == null || userdataJson.isEmpty) {
    throw Exception('User data not found');
  }

  Map<String, dynamic> userdata = jsonDecode(userdataJson);
  int userId = userdata['userId'];

  // API endpoint
  final String apiUrl = 'http://52.186.104.146:8085/FMSSmart/dashboard/post/json/getTransporterStatusDashbaordCounts';
  final Map<String, dynamic> payload = {'userId': userId};

  try {
    final Response response = await dio.post(apiUrl, data: payload);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print(data);
      if (data['status'] == 'success') {
        Map<String, int> counts = {
          'totalVehicles': data['data']['totalVehicles'] ?? 0,
          'runningVehicles': data['data']['runningVehicles'] ?? 0,
          'stoppedVehicles': data['data']['stoppedVehicles'] ?? 0,
          'nrdVehicles': data['data']['nrdVehicles'] ?? 0,
          'untrackedVehicles': data['data']['untrackedVehicles'] ?? 0,
        };
        return counts;
      } else {
        throw Exception('Failed to fetch data');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    print('Error fetching data: $e');
    throw e;
  }
}
