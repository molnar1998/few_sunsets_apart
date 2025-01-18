import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/themNotifier.dart';
import '../Data/user_data.dart';
import '../Widgets/nav_bar.dart';
import '../Data/page_control.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _enableNotifications = true;
  bool _darkModeEnabled = UserData.darkMode;
  int currentPageIndex = PageControl.page;

  @override
  initState() {
    super.initState();
  }

  Future<void> _darkMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _darkModeEnabled);
    UserData.updateDarkMode(_darkModeEnabled);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
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
                    _darkMode();
                    themeNotifier.toggleTheme();
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
