

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        leading: Icon(Icons.monetization_on),
        title: Center(
          child: Text(widget.title, 
            style: GoogleFonts.merriweatherSans(
              textStyle: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tutorial())
            );
          }, icon: Icon(Icons.help)),
        ],
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
  const InvitePeople({super.key});

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
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tutorial())
            );
          }, icon: Icon(Icons.help)),
        ],
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
  const MyLeaderboard({super.key});

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
                  IconButton(onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tutorial())
                    );
                  }, icon: Icon(Icons.help)),
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
  const JustifyPurchase({super.key});

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
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tutorial())
            );
          }, icon: Icon(Icons.help)),
        ],
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

class Tutorial extends StatefulWidget {
  const Tutorial ({super.key});

  @override
  State<Tutorial> createState() => _Tutorial();
}

class _Tutorial extends State<Tutorial> {

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("FinFig", 
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
            )
          ),
          body: Padding(
          padding: EdgeInsets.all(32),
          
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text("Welcome to Finfig!",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 30
                  )
                ),
              )
            ),
            const SizedBox(height: 8),
            Text("Short for Financial Fighter, we help you and your friends "
              "compete to make better purchases without revealing financial details.",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 14
                  )
                ),
            ),
            const SizedBox(height: 8),
            Text("We upload your transactions to an AI using Capital One's API, which makes you justify them and submit receipts."
                "This gives you an opportunity to reflect on your purchase history and cut on impulsive purchases.",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 14
                  )
                ),
            ),
            const SizedBox(height: 8),
            Text("There are three different categories you can compete with your friends in every week! ",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 14
                  )
                ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.savings_rounded),
              title: Text("Make the fewest frivolous purchases for the week.",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 16
                  )
                ),
             ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.smoke_free_sharp),
              title: Text("Reduce your carbon emissions! The products you purchase all leave a carbon footprint.",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 16
                  )
                ),
             ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.lightbulb_sharp),
              title: Text("Beat the price of Walmart with your purchases! Can you make the best deals?",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 16
                  )
                ),
             ),
            ),
            const SizedBox(height: 16),
            Text("So keep your receipts handy! Make fun of your friends! Let's play...",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 16
                  )
                ),
            ),
            const SizedBox(height: 8),
          Center(
            child: Text("Finfig!",
                style: GoogleFonts.merriweatherSans(
                  textStyle: TextStyle(
                    fontSize: 30
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

