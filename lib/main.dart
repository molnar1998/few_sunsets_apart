import 'package:few_sunsets_apart/Data/firebase_messaging_service.dart';
import 'package:few_sunsets_apart/Pages/add_memory_page.dart';
import 'package:few_sunsets_apart/Pages/calendar_page.dart';
import 'package:few_sunsets_apart/Pages/emotion_page.dart';
import 'package:few_sunsets_apart/Pages/loading_page.dart';
import 'package:few_sunsets_apart/Pages/memory_page.dart';
import 'package:few_sunsets_apart/Pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Pages/home_page.dart';
import 'Pages/login_page.dart';
import 'Pages/messages_page.dart';
import 'Pages/profile_page.dart';
import 'Pages/settings_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  FirebaseMessagingService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //Check if the user is logged in
    final User? user = FirebaseAuth.instance.currentUser;
    String initialRoute = user != null ? '/loading' : '/login';

    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: initialRoute, // Set the initial route
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/setting': (context) => const SettingPage(),
        '/message' : (context) => const MessagePage(),
        '/profile' : (context) => const ProfilePage(),
        '/calendar' : (context) => const CalendarPage(),
        '/emotion' : (context) => const EmotionPage(),
        '/memories' : (context) => const MemoriesPage(),
        '/addMemory' : (context) => const AddMemoryPage(),
        '/signUp' : (context) => const SignUpPage(),
        '/loading' : (context) => const LoadingPage(homePage: HomePage()),
      },
    );
  }
}