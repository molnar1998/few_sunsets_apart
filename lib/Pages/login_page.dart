import 'package:flutter/material.dart';
import '../Auth/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color _getGradientColor() {
    // Calculate gradient colors based on the current time
    final now = DateTime.now();
    final hour = now.hour;

    // Define your custom color transitions here
    if (hour >= 6 && hour < 12) {
      // Morning gradient (e.g., blue to yellow)
      return Colors.blue;
    } else if (hour >= 12 && hour < 18) {
      // Afternoon gradient (e.g., yellow to orange)
      return Colors.yellow;
    } else {
      // Evening gradient (e.g., orange to purple)
      return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Few Sunsets Apart Login'),
          backgroundColor: _getGradientColor(), // Dynamic color
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [_getGradientColor(), Colors.red], // Gradient colors
            ),
          ),
          child: Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 10,
              color: Colors.white.withOpacity(0.2),
              surfaceTintColor: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Unlock Our Journey',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Your Heart\'s Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Secret Key to My Heart',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        GoogleSignInHelper ().signInWithGoogle();
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in with Google'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.red, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Handle other login methods (e.g., email/password)
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: const Text('Other login options'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
