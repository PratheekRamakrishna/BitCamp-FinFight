import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialApp(
        title: 'FinFight',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
         ),
        home: MyLeaderboard(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Dave', 'Points': 500},
    {'name': 'Eve', 'Points': 400},
    {'name': 'Frank', 'Points': 300},
    {'name': 'Grace', 'Points': 200},
    {'name': 'Heidi', 'Points': 100},
    {'name': 'Ivan', 'Points': 50},
  ];
  final TextEditingController _justificationController = TextEditingController();


  void _submitJustification() {
    String reason = _justificationController.text;
    if (reason.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submitted: $reason")),
      );
      _justificationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Leaderboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ..._leaderboard.map((entry) => ListTile(
              leading: const Icon(Icons.emoji_events),
              title: Text(entry['name']),
              trailing: Text('\$${entry['savings']}'),
            )),
            const SizedBox(height: 24),
            const Text(
              "Justify Your Expense 🧾",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _justificationController,
              decoration: const InputDecoration(
                labelText: 'Why did you spend this money?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitJustification,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 24),
            Text(
              'Your score: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      
    );
  }
}

class MyLeaderboard extends StatefulWidget {
  @override
  State<MyLeaderboard> createState() => _MyLeaderboard();
}

class _MyLeaderboard extends State<MyLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: 
            Scaffold(
              appBar: AppBar(
                leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_sharp)),
                backgroundColor: Colors.green,
                title: Center(child: Text("Leaderboards")),
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.help)),
                ],
              ),
              bottomNavigationBar: const TabBar(
                padding: EdgeInsets.only(bottom: 30),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(icon: Icon(Icons.savings_rounded)),
                  Tab(icon: Icon(Icons.smoke_free)),
                  Tab(icon: Icon(Icons.lightbulb))
                ],
              ),
            ),
          );
  }
}
