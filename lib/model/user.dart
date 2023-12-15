import 'package:flutter/material.dart';

class User {
  final int id;
  String name;
  int missedFast;
  int makeupDay;

  User({
    required this.id,
    required this.name,
    required this.missedFast,
    required this.makeupDay,
  });

  // Factory constructor to create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      missedFast: map['missedDay'],
      makeupDay: map['makeupDay'],
    );
  }

  @override
  String toString() {
    return 'User{name: $name, missedFast: $missedFast, makeupDay: $makeupDay}';
  }

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'missedFast': missedFast,
      'makeupDay': makeupDay,
    };
  }
}
