import '../models/user_profile.dart';

class UserPreferences {
  static UserPurpose? selectedPurpose;

  static void setPurpose(UserPurpose purpose) {
    selectedPurpose = purpose;
  }

  static UserPurpose? getPurpose() {
    return selectedPurpose;
  }
}