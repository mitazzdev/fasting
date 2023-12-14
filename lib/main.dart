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
      },
    );
    setState(() {
      user = User(
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
        return AlertDialog(
          title: Text('Edit Card List'),
          content: ctTextField(
            label: 'Name',
            nameCtrl: nameCtrl,
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
    int id = index + 1; // Assuming the id is the index + 1 (adjust as needed)
    print(id);
    await _databaseHelper.deleteUser(id);
    _loadUsers();
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
              TextField(
                controller: txt,
              ),
              Container(
                height: 600,
                child: ListView.builder(
                  itemCount: userLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    User currentUser = userLists[index];
                    return Card(
                      child: ListTile(
                        title: Text(currentUser.name),
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
              )
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
