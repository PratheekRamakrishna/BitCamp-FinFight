import 'package:flutter/material.dart';
import 'dart:io'; // For File class
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinFight',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FinFig!'),
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
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Dave'},
    {'name': 'Eve'},
    {'name': 'Frank'},
    {'name': 'Grace'},
    {'name': 'Heidi'},
    {'name': 'Ivan'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.black)),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Friends",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ..._leaderboard.map((entry) => ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(entry['name'],
                      style: const TextStyle(fontSize: 20)),
                )),
            const SizedBox(height: 24),
            const InviteTransition(),
            const SizedBox(height: 24),
            const LeaderboardTransition(),
            const SizedBox(height: 24),
            const JustifyTransition(),
          ],
        ),
      ),
    );
  }
}

class InviteTransition extends StatelessWidget {
  const InviteTransition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.blue)),
      icon: const Icon(Icons.add, size: 36),
      label: Text(
        "Invite your Friends",
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InvitePeople()));
      },
    );
  }
}

class LeaderboardTransition extends StatelessWidget {
  const LeaderboardTransition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.yellow)),
      icon: const Icon(Icons.emoji_events, size: 36),
      label: Text(
        "See Leaderboards",
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyLeaderboard()));
      },
    );
  }
}

class JustifyTransition extends StatelessWidget {
  const JustifyTransition({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.lightGreen)),
      icon: const Icon(Icons.edit_note, size: 36),
      label: Text(
        "Justify Purchases",
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => JustifyPurchase()));
      },
    );
  }
}

class InvitePeople extends StatefulWidget {
  @override
  State<InvitePeople> createState() => _InvitePeopleState();
}

class _InvitePeopleState extends State<InvitePeople> {
  final TextEditingController _justificationController = TextEditingController();
  void _invitePerson() {
    String reason = _justificationController.text;
    if (reason.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invited: $reason")),
      );
      _justificationController.clear();
    }
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Invite Friends")),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Invite your friends!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Finfig is more fun with friends. Make great purchasing decisions together!",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
            ),
            TextField(
              controller: _justificationController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _invitePerson,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class MyLeaderboard extends StatefulWidget {
  @override
  State<MyLeaderboard> createState() => _MyLeaderboardState();
}

class _MyLeaderboardState extends State<MyLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_sharp)),
          backgroundColor: Colors.green,
          title: const Center(child: Text("Leaderboards")),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.help)),
          ],
        ),
        bottomNavigationBar: const TabBar(
          padding: EdgeInsets.only(bottom: 30),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(icon: Icon(Icons.savings_rounded)),
            Tab(icon: Icon(Icons.smoke_free)),
            Tab(icon: Icon(Icons.lightbulb)),
          ],
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("Points Leaderboard")),
            Center(child: Text("CO2 Savings Leaderboard")),
            Center(child: Text("Cost Effectiveness Leaderboard")),
          ],
        ),
      ),
    );
  }
}

class JustifyPurchase extends StatefulWidget {
  @override
  State<JustifyPurchase> createState() => _JustifyPurchaseState();
}

class _JustifyPurchaseState extends State<JustifyPurchase> {
  final List<Map<String, dynamic>> _transactionData = [
    {'date': '2025-04-01', 'vendor': 'Amazon', 'price': 45.99},
    {'date': '2025-04-01', 'vendor': 'Local Grocer', 'price': 12.50},
    {'date': '2025-04-02', 'vendor': 'Target', 'price': 78.20},
    {'date': '2025-04-03', 'vendor': 'Etsy', 'price': 25.00},
   
  ];

  final List<Map<String, dynamic>> _justifiedTransactions = [];

  void _showJustificationDialog(int index) {
    TextEditingController justificationController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Justification'),
          content: TextField(
            controller: justificationController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Why was this purchase made?',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (justificationController.text.isNotEmpty) {
                  setState(() {
                    _justifiedTransactions.add(_transactionData[index]);
                    _transactionData.removeAt(index);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      // Rebuild the UI after the dialog is closed, in case the list changed
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Justify Purchases")),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_transactionData.isNotEmpty)
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(80),
                  3: FlexColumnWidth(), 
                  4: FixedColumnWidth(80), 

                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Colors.grey),
                    children: [
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Date',
                                  style: TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Vendor',
                                  style: TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Price',
                                  style: TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Justify',
                                  style: TextStyle(fontWeight: FontWeight.bold)))),
                       TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Receipt',
                                  style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  for (int i = 0; i < _transactionData.length; i++)
                    TableRow(
                      key: ValueKey(_transactionData[i]), // Important for correct state management
                      children: [
                        TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_transactionData[i]['date']))),
                        TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_transactionData[i]['vendor']))),
                        TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '\$${(_transactionData[i]['price'] as num).toStringAsFixed(2)}'))),
                        TableCell(
                          child: Center(
                            child: TextButton(
                              onPressed: () => _showJustificationDialog(i),
                              child: const Text('Add'),
                            ),
                          ),
                        ),
                         TableCell(
                          child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Take picture")),),
                         
                      ],
                    ),
                ],
              )
            else
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("No transactions left to justify."),
              ),
            
          ],
        ),
      ),
    );
  }
}