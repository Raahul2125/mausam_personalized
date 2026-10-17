import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  UserProfile _user = const UserProfile(
    name: 'Rahul',
    location: 'Bengaluru',
    purpose: UserPurpose.health,
  );

  UserProfile get user => _user;

  void setPurpose(UserPurpose purpose) {
    _user = _user.copyWith(
      purpose: purpose,
    );

    notifyListeners();
  }

  void setLocation(String location) {
    _user = _user.copyWith(
      location: location,
    );

    notifyListeners();
  }

  void setName(String name) {
    _user = _user.copyWith(
      name: name,
    );

    notifyListeners();
  }
}