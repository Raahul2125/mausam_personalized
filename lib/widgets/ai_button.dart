import 'package:flutter/material.dart';

class AIFloatingButton extends StatelessWidget {
  const AIFloatingButton({super.key});

  void _showAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 25),

              const CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(
                  Icons.auto_awesome,
                  size: 32,
                  color: Color(0xFF1976D2),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Mausam Saathi',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'How can I help you?',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 25),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: const Color(0xFFF5F9FF),
                leading: const CircleAvatar(
                  child: Icon(Icons.mic),
                ),
                title: const Text(
                  'Voice Assistant',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Ask using your voice',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Voice Assistant will be connected in Stage 5.',
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: const Color(0xFFF5F9FF),
                leading: const CircleAvatar(
                  child: Icon(Icons.chat),
                ),
                title: const Text(
                  'AI Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Chat with Mausam Saathi',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'AI Chat will be connected in Stage 5.',
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'mausam_ai_button',
      onPressed: () => _showAssistant(context),
      backgroundColor: const Color(0xFF6A1B9A),
      foregroundColor: Colors.white,
      child: const Icon(Icons.auto_awesome),
    );
  }
}