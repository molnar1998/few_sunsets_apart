import 'package:flutter/material.dart';

import '../Data/nav_bar.dart';
import '../Data/page_control.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _enableNotifications = true;
  bool _darkModeEnabled = false;
  int currentPageIndex = PageControl.page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Notifications'),
              trailing: Switch(
                value: _enableNotifications,
                onChanged: (value) {
                  setState(() {
                    _enableNotifications = value;
                  });
                },
              ),
            ),
            const Divider(),

            const Text(
              'Appearance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            const Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                // Navigate to password change screen
              },
            ),
            const Divider(),

            // Add more settings options as needed
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
