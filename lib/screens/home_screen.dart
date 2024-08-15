import 'package:flutter/material.dart';
import 'package:fmslite/components/vehicle_search_delegate.dart';
import '../components/custom_tab_indicator.dart';
import '../components/vehicle_view.dart';  // Import your VehicleStatusScreen
import '../animated_drawer.dart';  // Import your Animated Drawer
 // Import your search delegate

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<VehicleStatusScreenState> vehicleStatusScreenKey1 = GlobalKey<VehicleStatusScreenState>();
  final GlobalKey<VehicleStatusScreenState> vehicleStatusScreenKey2 = GlobalKey<VehicleStatusScreenState>();

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

  void _refreshData() {
    vehicleStatusScreenKey1.currentState?.loadVehicleCounts();
    vehicleStatusScreenKey1.currentState?.loadVehicleList();
    vehicleStatusScreenKey1.currentState?.filterVehicleList();
    
    vehicleStatusScreenKey2.currentState?.loadVehicleCounts();
    vehicleStatusScreenKey2.currentState?.loadVehicleList();
    vehicleStatusScreenKey2.currentState?.filterVehicleList();
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: VehicleSearchDelegate(),  // Use your custom search delegate
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,  // Trigger the search bar
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 157, 222, 255),
      ),
      drawer: const AnimatedDrawer(),  // Include your animated drawer here
      body: TabBarView(
        controller: _tabController,
        children: [
          VehicleStatusScreen(key: vehicleStatusScreenKey1),  // Assign key to maintain state
          VehicleStatusScreen(key: vehicleStatusScreenKey2),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,  // Trigger the refresh
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 143, 189, 253),  // Set the background color
        height: 60.0,            // Set the height
        child: TabBar(
          indicator: RoundedTabIndicator(
            color: Colors.white, // Indicator color
            radius: 10.0,        // Radius for the rounded effect
          ),
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list, size: 24),text: 'List'), // Adjust icon size if needed
            Tab(icon: Icon(Icons.map, size: 24),text: 'Map'),  // Adjust icon size if needed
          ],
        ),
      ),
    );
  }
}
