import 'package:flutter/material.dart';

class User {
  String name;
  int missedFast;
  int makeupDay;

  User({
    required this.name,
    required this.missedFast,
    required this.makeupDay,
  });

  // Factory constructor to create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      missedFast: map['missedDay'],
      makeupDay: map['makeupDay'],
    );
  }

  @override
  String toString() {
    return 'User{name: $name, missedFast: $missedFast, makeupDay: $makeupDay}';
  }
}
