import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool crashDetectionEnabled = false;
  bool callEmergencyServices = false;
  bool shareLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Page')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/crash_icon1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Car Crash Detection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('Crash Detection'),
                subtitle: const Text('Enable car crash detection'),
                value: crashDetectionEnabled,
                onChanged: (bool value) {
                  setState(() {
                    crashDetectionEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Call Emergency Services'),
                subtitle: const Text('Device will attempt to call 108'),
                value: callEmergencyServices,
                onChanged: (bool value) {
                  setState(() {
                    callEmergencyServices = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Emergency Contact Sharing'),
                subtitle: const Text('Share location with selected contacts'),
                value: shareLocation,
                onChanged: (bool value) {
                  setState(() {
                    shareLocation = value;
                  });
                },
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DemoPage()),
                    );
                  },
                  child: const Text('Try Demo'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddContactPage()),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int countdown = 10;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        showEmergencyMessage();
      }
    });
  }

  void stopCountdown() {
    timer?.cancel();
    Navigator.pop(context); // Close the Demo UI
  }

  void showEmergencyMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Services'),
        content: const Text('Calling 108 and sharing location...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Crash Detected!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('$countdown', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: stopCountdown,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                backgroundColor: Colors.red,
              ),
              child: const Text('STOP'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> contacts = [];

  void _addContact() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        contacts.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contact')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Enter Contact Name'),
          ),
          ElevatedButton(onPressed: _addContact, child: const Text('Save Contact')),
        ],
      ),
    );
  }
}
