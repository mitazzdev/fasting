import 'package:flutter/material.dart';

import 'db_helper.dart';
import 'model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false; // Move isDark into the state
  MaterialColor color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: isDark
              ? ColorScheme.fromSeed(
                  seedColor: color, brightness: Brightness.dark)
              : ColorScheme.fromSeed(
                  seedColor: color, brightness: Brightness.light)),
      home: MyHomePage(
        title: 'Fasing Tracking',
        isDark: isDark,
        toggleTheme: () {
          // Use setState to trigger a rebuild when the theme changes
          setState(() {
            isDark = !isDark;
            print(isDark);
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.isDark,
      required this.toggleTheme});

  final String title;
  final bool isDark;
  final VoidCallback toggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List userLists = [];
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late User user;

  TextEditingController txt = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController misseDayCtrl = TextEditingController();
  TextEditingController makeupDayCtrl = TextEditingController();

  void _incrementUser() async {
    String newText = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ctAlertDialog(
            nameCtrl: nameCtrl,
            misseDayCtrl: misseDayCtrl,
            makeupDayCtrl: makeupDayCtrl);
      },
    );
    setState(() {
      user = User(
          id: 0,
          name: nameCtrl.text,
          makeupDay: int.parse(makeupDayCtrl.text),
          missedFast: int.parse(misseDayCtrl.text));
    });

    await _databaseHelper.insertUser(user);
    print('inserted');
    print(user);
    List<User> loadedUsers = await _databaseHelper.getUser();

    print("Users from database: $loadedUsers");
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    try {
      List<User> loadedUsers = await _databaseHelper.getUser();

      print("Users from database: $loadedUsers");

      setState(() {
        userLists = loadedUsers;
      });
    } catch (e) {
      print("Error loading users: $e");
    }
  }

// Edit functionality
  void _editCardList(int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ctAlertDialog(
            nameCtrl: nameCtrl,
            misseDayCtrl: misseDayCtrl,
            makeupDayCtrl: makeupDayCtrl);
      },
    );

    if (user.name.isNotEmpty) {
      int id = index + 1; // Assuming the id is the index + 1 (adjust as needed)
      await _databaseHelper.updateUser(id, user);
      _loadUsers();
    }
  }

  // Delete functionality
  void _deleteCardList(int index) async {
    User userToDelete = userLists[index]; // Get the User object from the list
    int userId = userToDelete.id; // Get the actual ID from the User object
    print(userId);

    await _databaseHelper.deleteUser(userId);
    _loadUsers();
  }

  Future<void> _deleteAllData() async {
    await _databaseHelper.deleteAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: widget.toggleTheme, // Use the toggleTheme callback
            icon: widget.isDark
                ? const Icon(Icons.sunny)
                : const Icon(Icons.dark_mode),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('hey '),
              Container(
                height: 600,
                decoration: BoxDecoration(color: Colors.amber),
                child: ListView.builder(
                  itemCount: userLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(userLists.length);
                    User currentUser = userLists[index];
                    int makeupDay = currentUser.makeupDay;
                    int missedDay = currentUser.missedFast;
                    double makeupPercent = makeupDay / missedDay * 100;
                    return Card(
                      child: ListTile(
                        title: Text(currentUser.name),
                        subtitle: LinearProgressIndicator(
                          value: makeupPercent,
                          semanticsLabel: 'Linear progress indicator',
                        ),
                        leading: CircleAvatar(
                            child: Text('${missedDay - makeupDay}')),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editCardList(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteCardList(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Call this method when you want to delete all data
                      _deleteAllData();
                      print('deleted all');
                    });
                  },
                  child: Text('delete all'))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementUser,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ctAlertDialog extends StatelessWidget {
  const ctAlertDialog({
    super.key,
    required this.nameCtrl,
    required this.misseDayCtrl,
    required this.makeupDayCtrl,
  });

  final TextEditingController nameCtrl;
  final TextEditingController misseDayCtrl;
  final TextEditingController makeupDayCtrl;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new user'),
      content: Column(
        children: [
          ctTextField(label: 'Name', nameCtrl: nameCtrl),
          ctTextField(label: 'Missed Day', nameCtrl: misseDayCtrl),
          ctTextField(label: 'Make up day', nameCtrl: makeupDayCtrl),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Save'),
        ),
      ],
    );
  }
}

class ctTextField extends StatelessWidget {
  const ctTextField({
    super.key,
    required this.nameCtrl,
    required this.label,
  });

  final TextEditingController nameCtrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: label,
        ),
        controller: nameCtrl,
      ),
    );
  }
}
