import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  // User user = User(name: name, makeupDay: makeupDay, missedFast: missedFast)
  int _makeupDay = 0;

  int get makeupDay => _makeupDay;

  void increasetMakeupDay() {
    _makeupDay++;
    notifyListeners();
  }

  void decreaseMakeupDay() {
    _makeupDay--;
    notifyListeners();
  }
}
