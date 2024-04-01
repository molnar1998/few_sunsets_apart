import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Auth/email_sign_in.dart';
import '../Data/user_data.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final EmailPasswordAuth emailSignIn = EmailPasswordAuth();
    final displayName = UserData.name;
    final formattedDate = DateFormat('MMMM dd, yyyy').format(now);

    return Scaffold(
        backgroundColor: Colors.white, // Set your desired background color
        appBar: AppBar(
          toolbarHeight: 200,
          actions: [
            PopupMenuButton<String>(
              offset: const Offset(-30, 80),
              child: const CircleAvatar(
                backgroundImage: AssetImage("lib/Assets/Images/3.png"), // Replace with your image
                radius: 40, // Adjust the size as needed
              ),
              onSelected: (value) {
                // Handle menu item selection
                if (value == 'settings') {
                  // Navigate to settings page
                  Navigator.pushNamed(context, '/settings');
                } else if (value == 'logout') {
                  emailSignIn.signOut(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Log Out'),
                  ),
                ];
              },
            ),
          ],
          titleTextStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          backgroundColor: Colors.lightBlue, // Make the app bar transparent
          elevation: 0, // Remove the shadow
        ),
        body: Column(
            children: [
              Text(formattedDate),
              Text("$displayName"),
              ElevatedButton.icon(onPressed: () { emailSignIn.signOut(context);}, icon: const Icon(Icons.accessible_forward), label: const Text("Log out"))
            ],
          ),
    );
  }
}