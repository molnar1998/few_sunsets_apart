import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Auth/email_sign_in.dart';
import '../Auth/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignInHelper _googleSignIn = GoogleSignInHelper();
  final EmailPasswordAuth _emailPasswordAuth = EmailPasswordAuth();
  final _formKey = GlobalKey<FormState>();
  bool _showTextFields = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.canAccess();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
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
                      TextSpan(text: "24/7", style: TextStyle(color: Colors.brown[800], fontSize: 72, fontWeight: FontWeight.bold)),
                      const TextSpan(text: "", style: TextStyle(color: Colors.black, fontSize: 72, fontWeight: FontWeight.bold)),
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
                  Expanded(child: Image.asset("lib/Assets/Images/2.png")),
                  const SizedBox(height: 20),
                  // Email input field
                  Visibility(
                      visible: _showTextFields,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (value){
                                if(value!.isEmpty) {
                                  return "Please enter your email address!";
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Password input field
                            TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value){
                                if(value!.isEmpty) {
                                  return "Please enter your password!";
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(500, 50),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.brown[800],
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_showTextFields == false) {
                        setState(() {
                          _showTextFields = !_showTextFields;
                        });
                      } else {
                        if(_formKey.currentState!.validate()){
                          _emailPasswordAuth.signInWithEmailAndPassword(_emailController.text, _passwordController.text).then((value) {
                            if (value != null && value.user!.emailVerified) {
                              Navigator.pushReplacementNamed(context, '/loading');
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Confirm your e-mail!'),
                                    content: Text('Please before login confirm your e-mail!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Okay'),
                                        child: const Text('Okay'),
                                      ),
                                      TextButton(
                                        onPressed: () async => {
                                          await value?.user!.sendEmailVerification().whenComplete(() {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: const Text('Confirm your e-mail!'),
                                                  content: Text('A conformation e-mail is sent to your e-mail address!'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, 'Okay'),
                                                      child: const Text('Okay'),
                                                    ),
                                                  ],
                                                ));
                                          }),
                                        },
                                        child: const Text('Resend'),
                                      )
                                    ],
                                  )
                              );
                            }
                          });
                        }
                      }
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
                      UserData.clearData();
                      _googleSignIn.signInWithGoogle().then((value) {
                        // If login is successful, navigate to the home page.
                        if(value != null){
                          Navigator.pushReplacementNamed(context, '/loading');
                        }
                      });
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: Text('Login with Gmail'.toUpperCase()),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(500, 50),
                      foregroundColor: Colors.red[900],
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signUp');
                    },
                    icon: const Icon(Icons.account_circle),
                    label: Text('Sign Up'.toUpperCase()),
                  ),
                  const SizedBox(height: 10),
                  // Other options (e.g., forgot password, social login)
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                  // Social login buttons (e.g., Facebook, Google)
                  // Add icons and functionality as needed
                ],
              ),
            ),
          )),
    );
  }
}
