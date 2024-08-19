import 'package:flutter/material.dart';
import 'package:fmslite/components/vehicle_search_delegate.dart';
import 'package:vibration/vibration.dart';
import '../components/custom_tab_indicator.dart';
import 'VehicleMapScreen.dart';
import 'vehicle_status_screen.dart'; // Import your VehicleStatusScreen
// Import your VehicleMapScreen
import '../animated_drawer.dart'; // Import your Animated Drawer
import '../components/success.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<VehicleStatusScreenState> vehicleStatusScreenKey1 =
      GlobalKey<VehicleStatusScreenState>();

  final List<Map<String, dynamic>> vehiclesData = [
    {
      "vehicleId": 264208,
      "vehicleNumber": "HR55AN9004",
      "latitude": 28.30452,
      "longitude": 76.875795,
      "lastLocation": "AT safexpress ncr-11 parking",
      // Add other details if necessary
    },
    // Add more vehicles here
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    try {
    // Check if the device can vibrate
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 90); // Trigger vibration
    }
    // No toast is shown
  } catch (e) {
    print('your mobile didnt have vibration ');
  }
    showSuccessToast('refreshed successfully');
    vehicleStatusScreenKey1.currentState?.loadVehicleCounts();
    vehicleStatusScreenKey1.currentState?.loadVehicleList();
    vehicleStatusScreenKey1.currentState?.filterVehicleList();
  }

  Future<void> _showSearch() async {
    try {
    // Check if the device can vibrate
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50); // Trigger vibration
    }
    // No toast is shown
  } catch (e) {
    print('your mobile didnt have vibration ');
  }
    showSearch(
      context: context,
      delegate: VehicleSearchDelegate(), // Use your custom search delegate
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        flexibleSpace: Container(
          
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:[Color.fromARGB(255, 206, 81, 255),Color.fromARGB(255, 104, 132, 255)], // Replace with your desired colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            
          ),
        ),
        leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, size: 35.0, color: Colors.white), // Customize the drawer icon here
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
        title: const Text('Dashboard',style: TextStyle(color:Color.fromARGB(223, 255, 255, 255),fontSize: 25.0, fontFamily: 'assets/Roboto-Bold.ttf' )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search,size: 35.0,color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: _showSearch, // Trigger the search bar
          ),
        ],
      ),
      drawer: const AnimatedDrawer(), // Include your animated drawer here
      body: TabBarView(
        controller: _tabController,
        children: [
          VehicleStatusScreen(
              key: vehicleStatusScreenKey1), // Assign key to maintain state
          VehicleMapScreen(vehiclesData: vehiclesData), // Show vehicles on the map
        ],
      ),
     floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF9333EA)], // Replace with your desired colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: _refreshData, // Trigger the refresh
          child: const Icon(Icons.refresh,color: Colors.white,),
          backgroundColor: Colors.transparent, // Set to transparent to show the gradient
          elevation: 0, // Remove shadow if needed
        ),
      ),

      bottomNavigationBar: Container(
         decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:[Color.fromARGB(255, 106, 129, 243),Color.fromARGB(255, 200, 144, 252)], // Replace with your desired colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
      
        height: 60.0, // Set the height
        child: TabBar(
          
          indicator: RoundedTabIndicator(
            color: Colors.white, // Indicator color
            radius: 10.0, // Radius for the rounded effect
          ),
          controller: _tabController,
          tabs: const [
            Tab(
                icon: Icon(Icons.list, size: 24),
                text: 'List'), // Adjust icon size if needed
            Tab(
                icon: Icon(Icons.map, size: 24),
                text: 'Map')          ],
        ),
      ),
    );
  }
}
