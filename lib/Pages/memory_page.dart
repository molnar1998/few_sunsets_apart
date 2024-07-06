import 'package:flutter/material.dart';

class MemoriesPage extends StatefulWidget {
  const MemoriesPage({super.key});

  @override
  State<StatefulWidget> createState() => MemoriesPageState();
}

class MemoriesPageState extends State<MemoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () =>
                  {Navigator.pushReplacementNamed(context, '/home')},
              icon: const Icon(Icons.arrow_back_ios_new))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FloatingActionButton.extended(
              onPressed: () => {
                Navigator.pushReplacementNamed(context, '/addMemory'),
              },
              label: const Text("Add memories"),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
