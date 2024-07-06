import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMemoryPage extends StatefulWidget {
  const AddMemoryPage({super.key});

  @override
  State<StatefulWidget> createState() => AddMemoryPageState();

}

class AddMemoryPageState extends State<AddMemoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () =>
              {Navigator.pushReplacementNamed(context, '/memories')},
              icon: const Icon(Icons.arrow_back_ios_new))
        ],
      ),
    );
  }

}