import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

// Define the Vehicle class
class Vehicle {
  final String vehicleNumber;
  final String status;

  Vehicle({
    required this.vehicleNumber,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    String status = 'Unknown'; // Default status

    if (json['isRunning'] == 1) {
      status = 'Running';
    } else if (json['isStopped'] == 1) {
      status = 'Stopped';
    } else if (json['isNRD'] == 1) {
      status = 'NRD';
    } else if (json['isUntracked'] == 1) {
      status = 'Untracked';
    }

    return Vehicle(
      vehicleNumber: json['vehicleNumber'] ?? 'Unknown',
      status: status,
    );
  }
}

// Fetch Vehicle List from API
Future<List<Vehicle>> fetchVehicleList() async {
  final dio = Dio();
  final url = 'http://52.186.104.146:8086/FMSLiteServices/fmslite/V2/post/json/getVehicleTrackingDetails';
  final payload = {
    "userId": "3104",
    "transporterId": "null",
    "page": "100",
    "vehicleId": "null",
    "isEncrypted": 1
  };

  try {
    final response = await dio.post(
      url,
      data: json.encode(payload),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final List<dynamic> vehicleData = data['data'];
      return vehicleData.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  } catch (e) {
    throw Exception('Failed to load vehicles: $e');
  }
}

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
