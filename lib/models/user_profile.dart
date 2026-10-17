enum UserPurpose {
  fitness,
  travel,
  farming,
  health,
  surfing,
  eventPlanner,
}


class UserProfile {
  final String name;
  final String location;
  final UserPurpose purpose;

  const UserProfile({
    required this.name,
    required this.location,
    required this.purpose,
  });

  UserProfile copyWith({
    String? name,
    String? location,
    UserPurpose? purpose,
  }) {
    return UserProfile(
      name: name ?? this.name,
      location: location ?? this.location,
      purpose: purpose ?? this.purpose,
    );
  }
}