

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
    return MaterialApp(
        title: 'FinFight',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
         ),
        home: MyHomePage(title: 'FinFig!'),
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
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.black)),
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
              title: Text(entry['name'], style: TextStyle(
                fontSize: 20
              )),
            )),
            const SizedBox(height: 24),
            InviteTransition(),
            const SizedBox(height: 24),
            LeaderboardTransition(),
            const SizedBox(height: 24),
            JustifyTransition(),
            /*const Text(
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
            ),*/
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
        padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ), 
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.blue)
        ),
      icon: Icon(Icons.add, size: 36),
      label: Text(
        "Invite your Friends",
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)
        ),
      onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InvitePeople())
        );
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
        padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ), 
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.yellow)
        ),
      icon: Icon(Icons.emoji_events, size: 36),
      label: Text(
        "See Leaderboards",
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)
        ),
      onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyLeaderboard())
        );
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
        padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ), 
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.lightGreen)
        ),
      icon: Icon(Icons.edit_note, size: 36),
      label: Text(
        "Justify Purchases",
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)
        ),
      onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JustifyPurchase())
        );
      },
    );
  }
}

class InvitePeople extends StatefulWidget {
  @override
  State<InvitePeople> createState() => _InvitePeople();
}

class _InvitePeople extends State<InvitePeople> {
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
        title: Center(
          child: Text("Justify Purchases", 
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Invite your friends!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Finfig is more fun with friends. Make great purchasing decisions together!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _justificationController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ), 
                ),
                backgroundColor: WidgetStatePropertyAll(Colors.red)
                ),
              icon: Icon(Icons.email_sharp, size: 36),
              label: Text(
                "Send Email",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)
                ),
              onPressed: _invitePerson,
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
                leading: IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_sharp)),
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

class JustifyPurchase extends StatefulWidget {
  @override
  State<JustifyPurchase> createState() => _JustifyPurchase();
}

final TextEditingController _justificationController = TextEditingController();

class _JustifyPurchase extends State<JustifyPurchase> {
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
        title: Center(
          child: Text("Justify Purchases", 
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }
}
