import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../models/user_profile.dart';
import '../home/personalized_home_screen.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({super.key});

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  UserPurpose? selectedPurpose;

  final List<_PurposeItem> purposes = [
    _PurposeItem(
      purpose: UserPurpose.fitness,
      title: 'Fitness',
      subtitle: 'Running, exercise & outdoor activities',
      icon: Icons.fitness_center,
    ),
    _PurposeItem(
      purpose: UserPurpose.travel,
      title: 'Travel',
      subtitle: 'Trips, journeys & travel conditions',
      icon: Icons.flight,
    ),
    _PurposeItem(
      purpose: UserPurpose.farming,
      title: 'Farming',
      subtitle: 'Crops, irrigation & field activities',
      icon: Icons.agriculture,
    ),
    _PurposeItem(
      purpose: UserPurpose.health,
      title: 'Health',
      subtitle: 'AQI, UV, pollen & humidity',
      icon: Icons.favorite,
    ),
    _PurposeItem(
      purpose: UserPurpose.surfing,
      title: 'Surfing',
      subtitle: 'Waves, wind & water conditions',
      icon: Icons.surfing,
    ),
    _PurposeItem(
      purpose: UserPurpose.eventPlanner,
      title: 'Event Planner',
      subtitle: 'Outdoor events & weather forecasts',
      icon: Icons.celebration,
    ),
  ];

  void _continue() {
    if (selectedPurpose == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select what you need weather for'),
        ),
      );
      return;
    }

    AppState.instance.setPurpose(selectedPurpose!);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PersonalizedHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1976D2),
                          Color(0xFF43A047),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'What do you need weather for?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17212B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Choose your primary purpose. '
                    'Mausam will personalize your experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Purpose list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                itemCount: purposes.length,
                itemBuilder: (context, index) {
                  final item = purposes[index];
                  final isSelected =
                      selectedPurpose == item.purpose;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPurpose = item.purpose;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1976D2)
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE3F2FD)
                                  : const Color(0xFFF1F5F9),
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            child: Icon(
                              item.icon,
                              size: 28,
                              color: isSelected
                                  ? const Color(0xFF1976D2)
                                  : Colors.black54,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? const Color(0xFF1976D2)
                                : Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurposeItem {
  final UserPurpose purpose;
  final String title;
  final String subtitle;
  final IconData icon;

  const _PurposeItem({
    required this.purpose,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}