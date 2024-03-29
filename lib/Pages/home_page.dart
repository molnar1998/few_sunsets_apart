import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // Set your desired background color
        appBar: AppBar(
          title: const Text(
            'Few Sunsets Apart',
            style: TextStyle(color: Colors.black), // Customize title color
          ),
          backgroundColor: Colors.transparent, // Make the app bar transparent
          elevation: 0, // Remove the shadow
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/Assets/Images/3.jpg'),
              fit: BoxFit.cover, // Adjust this to your preference
            ),
          ),
        )
    );
  }
}