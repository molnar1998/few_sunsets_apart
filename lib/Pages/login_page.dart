import 'package:flutter/material.dart';
import '../Auth/email_sign_in.dart';
import '../Auth/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignInHelper _googleSignIn = GoogleSignInHelper();
  bool _showTextFields = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 200,
            title: null, // Remove the default title
            centerTitle: true, // Center the title horizontally
            backgroundColor: Colors.blue[800], // Make the AppBar transparent
            elevation: 0, // Remove the shadow
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0), // Adjust the spacing
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "24/7",
                        style: TextStyle(color: Colors.brown[800],fontSize: 72, fontWeight: FontWeight.bold)
                      ),
                      const TextSpan(
                        text: "",
                        style: TextStyle(color: Colors.black,fontSize: 72, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // Start color at the top
              end: Alignment.bottomCenter, // End color at the bottom
              colors: [
                Colors.blue.shade800, // Top color
                Colors.orange.shade800, // Bottom color
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Your company/organization/app name
                Image.asset("lib/Assets/Images/2.png"),
                const SizedBox(height: 20),
                // Email input field
                Visibility(
                    visible: _showTextFields,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Password input field
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    )
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(500, 50),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.brown[800],
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      _showTextFields = !_showTextFields;
                    });
                  },
                  label: Text('Login with Email'.toUpperCase()),
                  icon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 20),
                // Sign-in button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[900],
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _googleSignIn.signInWithGoogle().then((value) {
                      if (value != null) {
                      // If login is successful, navigate to the home page.
                      Navigator.pushReplacementNamed(context, '/home');
                      } else {
                      // Handle unsuccessful login (optional).
                      }
                    });
                  },
                  icon: const Icon(Icons.email_outlined),
                  label: Text('Login with Gmail'.toUpperCase()),
                ),
                const SizedBox(height: 10),
                // Other options (e.g., forgot password, social login)
                TextButton(
                  onPressed: () {

                  },
                  child: const Text('Forgot Password?'),
                ),
                // Social login buttons (e.g., Facebook, Google)
                // Add icons and functionality as needed
              ],
            ),
          ),
        )
      ),
    );
  }
}
