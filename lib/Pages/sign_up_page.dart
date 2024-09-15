import 'package:few_sunsets_apart/Auth/email_sign_in.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:flutter/material.dart';


class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EmailPasswordAuth _emailPasswordAuth = EmailPasswordAuth();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       body: Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               Colors.blue.shade800,
               Colors.orange.shade800,
             ],
           ),
         ),
         child: Center(
           child: Form(
             key: _formKey,
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               TextFormField(
                 validator: (value) {
                   if(value == null || value.isEmpty){
                     return 'Please enter a username!';
                   }
                   return null;
                 },
                 controller: _usernameController,
                 decoration: const InputDecoration(
                   labelText: 'Username',
                   border: OutlineInputBorder(),
                 ),
               ),
               const SizedBox(height: 10),
               TextFormField(
                 validator: (value) {
                   if (value == null || value.isEmpty){
                     return 'Please enter your email!';
                   }
                   return null;
                 },
                 controller: _emailController,
                 decoration: const InputDecoration(
                   labelText: 'Email',
                   border: OutlineInputBorder(),
                 ),
               ),
               const SizedBox(height: 10),
               TextFormField(
                 validator: (value) {
                   if(value == null || value.isEmpty){
                     return 'Please enter your password!';
                   }
                   return null;
                 },
                 controller: _passwordController,
                 obscureText: true,
                 decoration: const InputDecoration(
                   labelText: 'Password',
                   border: OutlineInputBorder(),
                 ),
               ),
               const SizedBox(height: 10),
               TextFormField(
                 validator: (value) {
                   if(value == null || value.isEmpty){
                     return 'Please enter your password again!';
                   } else if (value != _passwordController.text){
                     return 'The passwords are not matching';
                   }
                   return null;
                 },
                 obscureText: true,
                 decoration: const InputDecoration(
                   labelText: 'Password again',
                   border: OutlineInputBorder(),
                 ),
               ),
               const SizedBox(height: 10),
               ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                   minimumSize: const Size(500, 50),
                   foregroundColor: Colors.red[900],
                   backgroundColor: Colors.white,
                   textStyle: const TextStyle(
                     fontSize: 18, fontWeight: FontWeight.bold),
                   ),
                 onPressed: () {
                   if(_formKey.currentState!.validate()) {
                     UserData.updateName(_usernameController.text);
                     _emailPasswordAuth.signUp(context, _emailController.text, _passwordController.text).then((value) {
                       if (value != null) {
                         Navigator.pushReplacementNamed(context, '/login');
                       }
                     });
                   }
                 },
                 icon: const Icon(Icons.account_circle),
                 label: Text('Sign Up'.toUpperCase()),
               ),
               const SizedBox(height: 10),
               ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                   minimumSize: const Size(500, 50),
                   foregroundColor: Colors.white,
                   backgroundColor: Colors.brown[800],
                   textStyle: const TextStyle(
                     fontSize: 18, fontWeight: FontWeight.bold),
                   ),
                 onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                 label: const Text('Login'),
                 icon: const Icon(Icons.email_outlined),
               ),
             ],
            ),
           ),
         ),
       ),
      ),
    );
  }

}