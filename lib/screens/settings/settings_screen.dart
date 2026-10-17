import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../models/user_profile.dart';
import '../home/personalized_home_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final user = AppState.instance.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Personalization',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Change what Mausam prioritizes for you.',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.location),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.auto_awesome),
                  ),
                  title: const Text(
                    'Current purpose',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    _purposeName(user.purpose),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _showPurposeSelector(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPurposeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: UserPurpose.values.map((purpose) {
              return ListTile(
                leading: Icon(_purposeIcon(purpose)),
                title: Text(_purposeName(purpose)),
                onTap: () {
                  AppState.instance.setPurpose(purpose);

                  Navigator.pop(context);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PersonalizedHomeScreen(),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _purposeName(UserPurpose purpose) {
    switch (purpose) {
      case UserPurpose.fitness:
        return 'Fitness';

      case UserPurpose.travel:
        return 'Travel';

      case UserPurpose.farming:
        return 'Farming';

      case UserPurpose.health:
        return 'Health';

      case UserPurpose.surfing:
        return 'Surfing';

      case UserPurpose.eventPlanner:
        return 'Events';
    }
  }

  IconData _purposeIcon(UserPurpose purpose) {
    switch (purpose) {
      case UserPurpose.fitness:
        return Icons.directions_run;

      case UserPurpose.travel:
        return Icons.flight;

      case UserPurpose.farming:
        return Icons.eco;

      case UserPurpose.health:
        return Icons.favorite;

      case UserPurpose.surfing:
        return Icons.surfing;

      case UserPurpose.eventPlanner:
        return Icons.celebration;
    }
  }
}