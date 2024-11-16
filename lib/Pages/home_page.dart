import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

import '../Auth/google_sign_in.dart';
import '../Data/counter.dart';
import '../Data/firebase_servicev2.dart';
import '../Data/nav_bar.dart';
import '../Data/page_control.dart';
import '../Data/user_data.dart';

/// Used for Background Updates using Workmanager Plugin
@pragma("vm:entry-point")
void callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) {
    final now = DateTime.now();
    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        'Updated from Background',
      ),
      HomeWidget.saveWidgetData(
        'message',
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      ),
    ]).then((value) async {
      Future.wait<bool?>([
        HomeWidget.updateWidget(
          name: 'MissCounterWidgetProvider',
          iOSName: 'MissCounterWidget',
        ),
        if (Platform.isAndroid)
          HomeWidget.updateWidget(
            qualifiedAndroidName:
            'com.example.few_sunsets_apart.MissCounterWidgetProvider',
          ),
      ]);
      return !value.contains(false);
    });
  });
}

/// Called when Doing Background Work initiated from Widget
@pragma("vm:entry-point")
Future<void> interactiveCallback(Uri? data) async {
  if (data?.host == 'titleclicked') {
    final greetings = [
      'Hello',
      'Hallo',
      'Bonjour',
      'Hola',
      'Ciao',
      '哈洛',
      '안녕하세요',
      'xin chào',
    ];
    final selectedGreeting = greetings[Random().nextInt(greetings.length)];
    await HomeWidget.setAppGroupId('com.example.few_sunsets_apart');
    await HomeWidget.saveWidgetData<String>('title', selectedGreeting);
    await HomeWidget.updateWidget(
      name: 'HomeWidgetExampleProvider',
      iOSName: 'HomeWidgetExample',
    );
    if (Platform.isAndroid) {
      await HomeWidget.updateWidget(
        qualifiedAndroidName:
        'com.example.few_sunsets_apart.MissCounterWidgetProvider',
      );
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentPageIndex = PageControl.page;
  Counter counter = Counter();
  var missCounter = 0;
  var partnerName = "";
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  final GoogleSignInHelper _googleSignIn = GoogleSignInHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId('com.example.few_sunsets_apart');
    HomeWidget.registerInteractivityCallback(interactiveCallback);
  }

  Future _sendData(String c) async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('appwidget_text', c),
        HomeWidget.renderFlutterWidget(
          const Icon(
            Icons.flutter_dash,
            size: 200,
          ),
          logicalSize: const Size(200, 200),
          key: 'dashIcon',
        ),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future _updateWidget() async {
    try {
      return Future.wait([
        HomeWidget.updateWidget(
          name: 'MissCounterWidgetProvider',
          iOSName: 'MissCounterWidget',
        ),
        if (Platform.isAndroid)
          HomeWidget.updateWidget(
            qualifiedAndroidName:
            'com.example.few_sunsets_apart.MissCounterWidgetProvider',
          ),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> _sendAndUpdate(String c) async {
    await _sendData(c);
    await _updateWidget();
  }

  Future<void> _getInstalledWidgets() async {
    try {
      final widgets = await HomeWidget.getInstalledWidgets();
      if (!mounted) return;

      String getText(HomeWidgetInfo widget) {
        if (Platform.isIOS) {
          return 'iOS Family: ${widget.iOSFamily}, iOS Kind: ${widget.iOSKind}';
        } else {
          return 'Android Widget id: ${widget.androidWidgetId}, '
              'Android Class Name: ${widget.androidClassName}, '
              'Android Label: ${widget.androidLabel}';
        }
      }

      await showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text('Installed Widgets'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Number of widgets: ${widgets.length}'),
              const Divider(),
              for (final widget in widgets)
                Text(
                  getText(widget),
                ),
            ],
          ),
        ),
      );
    } on PlatformException catch (exception) {
      debugPrint('Error getting widget information. $exception');
    }
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var displayName = UserData.name;
    var formattedDate = DateFormat('MMMM dd, yyyy').format(now);
    counter.initCounter();
    int c = counter.getCounter();

    if(UserData.loveCheck == true){
      _dataFetcher.retrieveData(UserData.id, 'partner_id').then((value) {
        if (value != null) {
          print('myLoveID: $value');
          UserData.updateMyLoveID(value);
          _dataFetcher.retrieveData(UserData.myLoveID, 'user_name').then((value) {
            if (value != null) {
              print('First Name: $value');
              UserData.updateMyLoveName(value);
            } else {
              print('First name not found.');
            }
          });
          _dataFetcher.retrieveData(UserData.myLoveID, 'miss_counter').then((value) {
            if (value != null) {
              print('First Name: $value');
              UserData.updateMyLoveMissMe(value);
            } else {
              print('First name not found.');
            }
          });
        } else {
          print('myLoveID not found.');
          UserData.updateLoveCheck(false);
        }
      });
      partnerName = UserData.partnerName;
      missCounter = UserData.missCounter;
      _dataFetcher.retrieveData(UserData.id, "mood_pic").then((value) {
        setState(() {
          UserData.updateMoodPic(value);
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      appBar: AppBar(
        toolbarHeight: 250,
        title:  Text(
          "👋Hi $displayName,",
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(-30, 80),
            child: const CircleAvatar(
              backgroundImage: AssetImage(
                  "lib/Assets/Images/3.png"), // Replace with your image
              radius: 40, // Adjust the size as needed
            ),
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'profile') {
                Navigator.pushReplacementNamed(context, '/profile');
              } else if (value == 'logout') {
                UserData.clearData();
                _googleSignIn.handleSignOut(context);
                _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        titleTextStyle:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        backgroundColor: Colors.orange[100], // Make the app bar transparent
        elevation: 0, // Remove the shadow
      ),
      body: Container(
        color: Colors.orange[50],
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/memories');
                    },
                    heroTag: "btn1",
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo_size_select_actual_outlined,size: 100,),
                        SizedBox(height: 4), // Adjust the spacing as needed
                        Text('Memories'),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/calendar');
                    },
                    heroTag: "btn2",
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_month,size: 100,),
                        SizedBox(height: 4), // Adjust the spacing as needed
                        Text('Calendar'),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/emotion');
                    },
                    heroTag: "btn3",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(UserData.moodPic),
                        SizedBox(height: 4), // Adjust the spacing as needed
                        Text('Emotion'),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        counter.incrementCounter();
                        c = counter.getCounter();
                        _sendAndUpdate(c.toString());
                        //_getInstalledWidgets();
                        debugPrint("Pressed!");
                      });
                    },
                    heroTag: "btn4",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('$partnerName miss me $missCounter times :3', textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        const Icon(Icons.favorite,size: 100,),
                        const SizedBox(height: 4), // Adjust the spacing as needed
                        Text('I miss you $c'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
