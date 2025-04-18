import 'dart:async';
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
import '../Widgets/nav_bar.dart';
import '../Data/page_control.dart';
import '../Data/user_data.dart';

/// Used for Background Updates using Workmanager Plugin
@pragma("vm:entry-point")
FutureOr<void> backgroundCallback(Uri? data) async {
  if (data?.host == 'titleclicked') {
    await HomeWidget.setAppGroupId('com.example.few_sunsets_apart');
    await HomeWidget.saveWidgetData<String>('appwidget_text', 'Success');
    await HomeWidget.updateWidget(
      name: 'MissCounterWidgetReceiver',
      iOSName: 'HomeWidgetExample',
    );
    if (Platform.isAndroid) {
      await HomeWidget.updateWidget(
        qualifiedAndroidName: 'com.example.few_sunsets_apart.MissCounterWidgetReceiver',
      );
    }
  }
}

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
          name: 'MissCounterWidgetReceiver',
          iOSName: 'MissCounterWidget',
        ),
        if (Platform.isAndroid)
          HomeWidget.updateWidget(
            qualifiedAndroidName: 'com.example.few_sunsets_apart.MissCounterWidgetReceiver',
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
    await HomeWidget.setAppGroupId('com.example.few_sunsets_apart');
    await HomeWidget.saveWidgetData<String>('appwidget_text', 'Success');
    await HomeWidget.updateWidget(
      name: 'MissCounterWidgetReceiver',
      iOSName: 'HomeWidgetExample',
    );
    if (Platform.isAndroid) {
      await HomeWidget.updateWidget(
        qualifiedAndroidName: 'com.example.few_sunsets_apart.MissCounterWidgetReceiver',
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
  String partnerName = "";
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  final GoogleSignInHelper _googleSignIn = GoogleSignInHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    counter.initCounter();
    getMissCounterValue();
    HomeWidget.setAppGroupId('com.example.few_sunsets_apart');
    HomeWidget.registerInteractivityCallback(interactiveCallback);
    HomeWidget.registerInteractivityCallback(backgroundCallback);
  }

  Future _sendData(String id, String data) async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>(id, data),
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
          name: 'MissCounterWidgetReceiver',
          iOSName: 'MissCounterWidget',
        ),
        if (Platform.isAndroid)
          HomeWidget.updateWidget(
            qualifiedAndroidName: 'com.example.few_sunsets_apart.MissCounterWidgetReceiver',
          ),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> _sendAndUpdate(String id, String data) async {
    await _sendData(id, data);
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

  void getMissCounterValue() {
    _dataFetcher.retrieveDataByUserName(UserData.partnerName, 'miss_counter').then((value) {
      if (value != null) {
        setState(() {
          UserData.missCounter = value[UserData.name] ?? 0;
        });
      }
    });
  }

  void getCounterValue() {
    _dataFetcher.retrieveData(UserData.id, 'miss_counter').then((value) {
      if (value != null) {
        setState(() {
          UserData.counter = value[UserData.partnerName] ?? 0;
          Counter.counter = UserData.counter;
          _sendAndUpdate('appwidget_text', Counter.counter.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var displayName = UserData.name;
    var formattedDate = DateFormat('MMMM dd, yyyy').format(now);
    //counter.initCounter();
    String? selectedFriend = "";

    if (UserData.partnerCheck == true) {
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
        if (value != null) {
          setState(() {
            UserData.updateMoodPic(value);
          });
        }
      });
    }
    // Select partner for sending hearts
    void showAddPeopleDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Select Friend"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: UserData.friends.map((friend) {
                      return RadioListTile(
                        title: Text(friend.friendUId),
                        value: friend.friendUId,
                        groupValue: selectedFriend,
                        onChanged: (String? value) {
                          setState(() {
                            selectedFriend = value;
                            print(selectedFriend);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog without saving
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        UserData.partnerName = selectedFriend!;
                        Navigator.pop(context, selectedFriend);
                        getMissCounterValue();
                        getCounterValue();
                        print("Selected Friends: $selectedFriend");
                      });
                    },
                    child: Text("Select"),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 250,
        title: Text(
          "👋Hi $displayName,",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(-30, 80),
            child: CircleAvatar(
              backgroundImage: UserData.profilePic == "lib/Assets/Images/3.png"
                  ? AssetImage("lib/Assets/Images/3.png")
                  : Image.network(UserData.profilePic).image, // Replace with your image
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
              } else if (value == 'visa') {
                Navigator.pushReplacementNamed(context, '/visa');
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
                const PopupMenuItem<String>(value: 'visa', child: Text('Visa info')),
              ];
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        titleTextStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        elevation: 0, // Remove the shadow
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
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
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/memories');
                  },
                  heroTag: "btn1",
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_size_select_actual_outlined,
                        size: 100,
                      ),
                      SizedBox(height: 4), // Adjust the spacing as needed
                      Text('Memories'),
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/calendar');
                  },
                  heroTag: "btn2",
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 100,
                      ),
                      SizedBox(height: 4), // Adjust the spacing as needed
                      Text('Calendar'),
                    ],
                  ),
                ),
                FloatingActionButton(
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
                InkWell(
                  splashColor: Colors.blue,
                  onLongPress: () {
                    showAddPeopleDialog(context);
                  },
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if (UserData.partnerName.isEmpty) {
                          showAddPeopleDialog(context);
                        } else {
                          counter.incrementCounter(UserData.partnerName);
                          _sendAndUpdate('appwidget_text', Counter.counter.toString());
                          //_getInstalledWidgets();
                        }
                      });
                    },
                    heroTag: "btn4",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${UserData.partnerName} miss me ${UserData.missCounter} times :3',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(
                          Icons.favorite,
                          size: 100,
                        ),
                        const SizedBox(height: 4), // Adjust the spacing as needed
                        Text('I miss you ${Counter.counter}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
