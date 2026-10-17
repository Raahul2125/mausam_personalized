import 'package:flutter/material.dart';

class AIButton extends StatelessWidget {
  const AIButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 6,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Mausam AI Assistant',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.mic),
                      ),
                      title: const Text('Voice Assistant'),
                      subtitle: const Text(
                        'Talk to Mausam',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.chat),
                      ),
                      title: const Text('Chat with Mausam'),
                      subtitle: const Text(
                        'Ask about your weather',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: const Icon(
        Icons.auto_awesome,
      ),
    );
  }
}