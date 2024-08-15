import 'package:flutter/material.dart';
import '../components/bubble_tab_indicator.dart'; // Import your custom tab indicator
import '../components/vehicle_search_delegate.dart';
import '../components/vehicle_view.dart';
import '../animated_drawer.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  void _onStatusSelected(String status) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu, size: 30.0),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Center(
            child: Text('Dashboard', style: TextStyle(fontFamily: 'roboto')),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: VehicleSearchDelegate());
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(85.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: const Color.fromARGB(255, 255, 255, 255),
            child: TabBar(
              controller: _tabController,
              indicator: BubbleTabIndicator(color: const Color.fromARGB(255, 255, 255, 255)), // Use the custom bubble indicator
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'List'),
                Tab(icon: Icon(Icons.location_pin), text: 'Map'),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 144, 132, 255),
      ),
      drawer: const AnimatedDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
           const VehicleStatusScreen(),
           const VehicleStatusScreen(),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 145, 166, 226),
    );
  }
}
