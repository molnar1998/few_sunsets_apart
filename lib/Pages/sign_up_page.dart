import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:few_sunsets_apart/Auth/email_sign_in.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:safe_text/safe_text.dart';


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
  final regex = RegExp(r'^[a-zA-Z0-9._]{3,15}$');
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[A-Z])[A-Za-z\d@$!%*?&]{8,}$');
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  Timer? _debounce;
  String? _usernameError;
  String? _emailError;
  bool _isPasswordVisible = true;
  String? _passwordError;
  String? _rePasswordError;

  void _onUsernameChanged(String value) {
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _usernameError = null;// Reset error while typing
    });

    _debounce = Timer(Duration(milliseconds: 500), () async {
      if(value.isEmpty){
        setState(() {
          _usernameError = 'Username cannot be empty!';
        });
        return;
      } else if(!regex.hasMatch(value)){
        setState(() {
          _usernameError = 'Username must be 3-15 characters long\nand can only contains letters, numbers, dots, and underscores';
        });
        return;
      } else if(value.startsWith('.') || value.startsWith('_') || value.endsWith('.') || value.endsWith('_')) {
        setState(() {
          _usernameError = 'Username cannot start or end with a dot or underscore';
        });
        return;
      } else if(value.contains('..') || value.contains('__')){
        setState(() {
          _usernameError =  'Username cannot contain consecutive dots or underscores';
        });
        return;
      } else if(SafeText.filterText(text: value, useDefaultWords: true) != value){
        // If SafeText modifies the username, it contains bad words
        setState(() {
          _usernameError = "Username contains inappropriate language";
        });
        return;
      }

      try{
        bool isAvailable = await _dataFetcher.checkUserNameAvailability(value);
        if(!isAvailable) {
          setState(() {
            _usernameError = "Username is already taken";
          });
          return;
        }
      }catch (e){
        setState(() {
          _usernameError = "Error checking username availability!";
        });
        return;
      }
    });
  }

  void _onEmailChanged(String value) {
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _emailError = null; // Reset error while typing
    });

    _debounce = Timer(Duration(milliseconds: 500), () async {
      if(value.isEmpty){
        setState(() {
          _emailError = 'Email cannot be empty!';
        });
        return;
      } else if(!emailRegex.hasMatch(value)){
        setState(() {
          _emailError = 'Invalid email format!';
        });
        return;
      } else if(!EmailValidator.validate(value)){
        setState(() {
          _emailError = 'The email is invalid!';
        });
        return;
      }
    });
  }

  void _onPasswordChanged(String value) {
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _passwordError = null; // Reset error while typing
    });

    _debounce = Timer(Duration(milliseconds: 500), () async {
      if(value.isEmpty){
        setState(() {
          _passwordError = 'Password cannot be empty!';
        });
        return;
      } else if(!passwordRegex.hasMatch(value)){
        setState(() {
          _passwordError = 'Password must be at least 8 characters long,\ncontain at least one uppercase letter,\none number.';
        });
        return;
      }
    });
  }

  void _onRePasswordChanged(String value) {
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _rePasswordError = null; // Reset error while typing
    });

    _debounce = Timer(Duration(milliseconds: 500), () async {
      if(value.isEmpty){
        setState(() {
          _rePasswordError = 'Please enter your password again!';
        });
        return;
      } else if(value != _passwordController.text){
        setState(() {
          _rePasswordError = 'The passwords are not matching';
        });
        return;
      }
    });
  }

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
                 decoration: InputDecoration(
                   labelText: 'Username',
                   errorText: _usernameError,
                   border: OutlineInputBorder(),
                 ),
                 onChanged: _onUsernameChanged,
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
                 decoration: InputDecoration(
                   labelText: 'Email',
                   errorText: _emailError,
                   border: OutlineInputBorder(),
                 ),
                 onChanged: _onEmailChanged,
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
                 obscureText: _isPasswordVisible,
                 decoration: InputDecoration(
                   labelText: 'Password',
                   errorText: _passwordError,
                   suffixIcon: IconButton(
                     icon: Icon(
                         _isPasswordVisible ? Icons.visibility : Icons.visibility_off
                     ),
                     onPressed: () {
                       setState(() {
                         _isPasswordVisible = !_isPasswordVisible;
                       });
                     },
                   ),
                   border: OutlineInputBorder(),
                 ),
                 onChanged: _onPasswordChanged,
               ),
               const SizedBox(height: 10),
               TextFormField(
                 validator: (value) {
                   if(value == null || value.isEmpty){
                     return 'Please enter your password again!';
                   }
                   return null;
                 },
                 obscureText: _isPasswordVisible,
                 decoration: InputDecoration(
                   labelText: 'Password again',
                   errorText: _rePasswordError,
                   border: OutlineInputBorder(),
                 ),
                 onChanged: _onRePasswordChanged,
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
                   if(_formKey.currentState!.validate() && _emailError == null && _usernameError == null && _passwordError == null && _rePasswordError == null) {
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