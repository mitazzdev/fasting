class User {
  String name;
  int missedFast;
  int makeupDay;

  User({
    required this.name,
    required this.missedFast,
    required this.makeupDay,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String? ?? '',
      missedFast: (map['missedDay'] as int?) ?? 0,
      makeupDay: (map['makeupDay'] as int?) ?? 0,
    );
  }

  @override
  String toString() {
    return 'User{name: $name, missedFast: $missedFast, makeupDay: $makeupDay}';
  }

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'missedFast': missedFast,
      'makeupDay': makeupDay,
    };
  }
}
