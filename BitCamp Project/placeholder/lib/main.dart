import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget (Stateless as it only sets up theme and home)
class MyApp extends StatelessWidget { // Changed to StatelessWidget as state was unused
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed the unused GestureDetector
    return MaterialApp(
      title: 'FinFight',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Set MyLeaderboard directly as the home screen
      home: const MyLeaderboard(), // Added const
    );
  }
}

// --- MyHomePage and _MyHomePageState have been removed as they were unused ---


// Leaderboard screen widget
class MyLeaderboard extends StatefulWidget {
  // Added standard const constructor
  const MyLeaderboard({super.key});

  @override
  // Renamed State class to follow convention
  State<MyLeaderboard> createState() => _MyLeaderboardState();
}

// State for the Leaderboard screen
class _MyLeaderboardState extends State<MyLeaderboard> {
  // Leaderboard data remains the same
  final List<Map<String, dynamic>> co2Leaderboard = [
    {'name': 'Sena', 'co2Cost': 50}, // Key is 'co2Cost'
    {'name': 'Scott', 'co2Cost': 100},
    {'name': 'Lupita', 'co2Cost': 90},
  ];

  final List<Map<String, dynamic>> pointsLeaderboard = [
    {'name': 'Sena', 'points': 100},
    {'name': 'Scott', 'points': 400},
    {'name': 'Lupita', 'points': 300},
  ];

  final List<Map<String, dynamic>> costEffectiveLeaderboard = [
    {'name': 'Sena', 'ratio': 10.5},
    {'name': 'Scott', 'ratio': 9.2},
    {'name': 'Lupita', 'ratio': 8.8},
  ];

  @override
  Widget build(BuildContext context) {
    // DefaultTabController provides the controller for TabBar and TabBarView
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // TODO: Implement back navigation if needed
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_sharp),
          ),
          backgroundColor: Colors.green,
          title: const Center(child: Text("Leaderboards")), // Added const
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Implement help action
              },
              icon: const Icon(Icons.help),
            ), // Added const
          ],
          // Removed bottom property as TabBar is now in bottomNavigationBar
        ),
        // Place TabBar in bottomNavigationBar for conventional placement
        bottomNavigationBar: const TabBar(
          padding: EdgeInsets.only(bottom: 20, top: 10), // Adjusted padding
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(icon: Icon(Icons.savings_rounded)), // Points/Savings
            Tab(icon: Icon(Icons.eco)), // Changed icon to better match CO2
            Tab(icon: Icon(Icons.lightbulb)), // Cost Effectiveness
          ],
        ),
        body: TabBarView(
          // Removed the explicit controller, it uses DefaultTabController's controller
          children: [
            _buildPointsTable(), // First tab content
            _buildCO2Table(), // Second tab content
            _buildCostEffectiveTable(), // Third tab content
          ],
        ),
      ),
    );
  }

  // Helper method to build the Points leaderboard table
  Widget _buildPointsTable() {
    // Sort in descending order (highest points first)
    pointsLeaderboard.sort((a, b) => (b['points'] as num).compareTo(a['points'] as num));
    return ListView(
      children: pointsLeaderboard.map((entry) {
        return ListTile(
          leading: const Icon(Icons.star), // Added const
          title: Text(entry['name']?.toString() ?? ''), // Handle potential null name
          trailing: Text('${entry['points']?.toString() ?? ''} pts'), // Handle potential null points
        );
      }).toList(),
    );
  }

  // Helper method to build the CO2 leaderboard table
  Widget _buildCO2Table() {
    // Sort in ascending order (lowest CO2 cost is better)
    co2Leaderboard.sort((a, b) => (a['co2Cost'] as num).compareTo(b['co2Cost'] as num));
    return ListView(
      children: co2Leaderboard.map((entry) {
        return ListTile(
          leading: const Icon(Icons.eco), // Added const
          title: Text(entry['name']?.toString() ?? ''), // Handle potential null name
          // Corrected the key from 'co2Saved' to 'co2Cost'
          trailing: Text('${entry['co2Cost']?.toString() ?? ''} kg CO₂'), // Handle potential null co2Cost
        );
      }).toList(),
    );
  }

  // Helper method to build the Cost-Effective leaderboard table
  Widget _buildCostEffectiveTable() {
    // Sort in descending order (highest ratio is better)
    costEffectiveLeaderboard.sort((a, b) => (b['ratio'] as num).compareTo(a['ratio'] as num));

    return ListView(
      children: costEffectiveLeaderboard.map((entry) {
        return ListTile(
          leading: const Icon(Icons.attach_money), // Added const
          title: Text(entry['name']?.toString() ?? ''), // Handle potential null name
          subtitle: const Text("Savings-to-spending ratio"), // Added const
          trailing: Text((entry['ratio'] as num).toStringAsFixed(2)), // Handle potential null ratio
        );
      }).toList(),
    );
  }
}