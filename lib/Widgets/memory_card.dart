import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onTap;
  final VoidCallback onEditMemory;
  final VoidCallback onDeleteMemory;

  const MemoryCard({
    super.key,
    required this.text,
    required this.title,
    required this.onTap,
    required this.onEditMemory,
    required this.onDeleteMemory,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(text),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onEditMemory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onDeleteMemory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}