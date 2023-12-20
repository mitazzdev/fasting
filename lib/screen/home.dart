import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/db_helper.dart';
import '../model/user.dart';
import '../utils/widgets/custom.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.isDark,
    required this.toggleTheme,
  });

  final String title;
  final bool isDark;
  final VoidCallback toggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> userLists = [];
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  late int nextRamadan;
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController txt = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController misseDayCtrl = TextEditingController();
  TextEditingController makeupDayCtrl = TextEditingController();

  int calNextRamdan() {
    DateTime today = DateTime.now();
    DateTime nextRamdan = DateTime(2024, 3, 10);

    Duration difference = nextRamdan.difference(today);
    int daysDifference = difference.inDays;

    print('Days between today and March 10, 2024: $daysDifference days');
    return daysDifference;
  }

  Future<void> _incrementUser() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ctAlertDialog(
          nameCtrl: nameCtrl,
          misseDayCtrl: misseDayCtrl,
          makeupDayCtrl: makeupDayCtrl,
        );
      },
    );

    // Ensure that the text fields are not empty before creating a new user
    if (nameCtrl.text.isNotEmpty &&
        misseDayCtrl.text.isNotEmpty &&
        makeupDayCtrl.text.isNotEmpty) {
      User newUser = User(
        id: 0,
        name: nameCtrl.text,
        makeupDay: int.parse(makeupDayCtrl.text),
        missedFast: int.parse(misseDayCtrl.text),
      );

      // Add the new user to Firestore
      await _firestore.collection('users').add(newUser.toMap());

      // Clear the text controllers
      nameCtrl.clear();
      misseDayCtrl.clear();
      makeupDayCtrl.clear();

      // Reload the users from Firestore
      _loadUsers();
    }
  }

  Future<void> _loadUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      List<User> loadedUsers = querySnapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      print("Users from database: $loadedUsers");

      setState(() {
        userLists = loadedUsers;
      });
    } catch (e) {
      print("Error loading users: $e");
    }
  }

  // Edit functionality
  Future<void> _editUser(int index) async {
    User existingUser = userLists[index];

    // Set the text for the text controllers
    nameCtrl.text = existingUser.name;
    misseDayCtrl.text = existingUser.missedFast.toString();
    makeupDayCtrl.text = existingUser.makeupDay.toString();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ctAlertDialog(
          nameCtrl: nameCtrl,
          misseDayCtrl: misseDayCtrl,
          makeupDayCtrl: makeupDayCtrl,
        );
      },
    );

    // Ensure that the text fields are not empty before updating the user
    if (nameCtrl.text.isNotEmpty &&
        misseDayCtrl.text.isNotEmpty &&
        makeupDayCtrl.text.isNotEmpty) {
      User updatedUser = User(
        id: existingUser.id,
        name: nameCtrl.text,
        makeupDay: int.parse(makeupDayCtrl.text),
        missedFast: int.parse(misseDayCtrl.text),
      );

      // Update the user in Firestore
      await _firestore
          .collection('users')
          .doc(existingUser.id)
          .update(updatedUser.toMap());

      // Clear the text controllers
      nameCtrl.clear();
      misseDayCtrl.clear();
      makeupDayCtrl.clear();

      // Reload the users from Firestore
      _loadUsers();
    }
  }

  // Delete functionality
  Future<void> _deleteUser(int index) async {
    User userToDelete = userLists[index];

    // Delete the user from Firestore
    await _firestore.collection('users').doc(userToDelete.id).delete();

    // Reload the users from Firestore
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
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Color.fromARGB(255, 187, 179, 113),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Countdown to Ramadan: ',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$nextRamadan days',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 224, 148),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ReorderableListView.builder(
                    itemCount: userLists.length,
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final User item = userLists.removeAt(oldIndex);
                        userLists.insert(newIndex, item);
                        List<User> newUserList = userLists;
                        _reOrderData(newUserList);
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      User currentUser = userLists[index];
                      int makeupDay = currentUser.makeupDay;
                      int missedDay = currentUser.missedFast;
                      double makeupPercent =
                          missedDay != 0 ? makeupDay / missedDay : 1;
                      bool isDone = missedDay <= makeupDay ? true : false;

                      return Slidable(
                        key: Key(currentUser.id.toString()),
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Card(
                          child: isDone
                              ? ListTile(
                                  contentPadding: EdgeInsets.all(8),
                                  title: Text(currentUser.name),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          minHeight: 10,
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          value: makeupPercent,
                                          semanticsLabel:
                                              'Linear progress indicator',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Center(
                                          child: Text('$makeupDay/$missedDay'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: SizedBox(
                                    width: 70,
                                    child: FittedBox(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                                        // minRadius: 1,
                                      ),
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            print('decreased');
                                            setState(() {
                                              if (makeupDay >= 1) {
                                                makeupDay--;
                                              }
                                              _updateMakeUpDay(
                                                  index, makeupDay);
                                              print(makeupDay);
                                            });
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListTile(
                                  contentPadding: EdgeInsets.all(8),
                                  title: Text(currentUser.name),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          minHeight: 10,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          value: makeupPercent,
                                          semanticsLabel:
                                              'Linear progress indicator',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Center(
                                          child: Text('$makeupDay/$missedDay'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: SizedBox(
                                    width: 70,
                                    child: FittedBox(
                                      child: CircleAvatar(
                                        backgroundColor: makeupDay == 0
                                            ? Color.fromARGB(255, 238, 172, 167)
                                            : null,
                                        child: Text('${missedDay - makeupDay}'),
                                        // minRadius: 1,
                                      ),
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            print('decreased');
                                            setState(() {
                                              if (makeupDay >= 1) {
                                                makeupDay--;
                                              }
                                              _updateMakeUpDay(
                                                  index, makeupDay);
                                              print(makeupDay);
                                            });
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            print('increased');
                                            setState(() {
                                              makeupDay++;
                                              _updateMakeUpDay(
                                                  index, makeupDay);
                                              print(makeupDay);

                                              // Check if makeupDay reaches a certain condition
                                              if (makeupDay == missedDay) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Congratulations ${currentUser.name} 🥳  \nYou have successfully completed the task!',
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                  webShowClose: true,
                                                  webBgColor: "#e74c3c",
                                                  webPosition: "right",
                                                );
                                                print('After showToast');
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => _confirmDelete(context, index),
                          ),
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.blue,
                            icon: Icons.edit,
                            onTap: () => _editUser(index),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         // Call this method when you want to delete all data
              //         _deleteAllData();
              //         print('deleted all');
              //       });
              //     },
              //     child: Text('delete all'))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementUser,
        tooltip: 'Increment',
        child: const Icon(Icons.person_add_rounded),
      ),
    );
  }
}
