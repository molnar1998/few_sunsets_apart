import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:flutter/material.dart';

import '../Data/user_data.dart';

class EmotionPage extends StatefulWidget {
  const EmotionPage({super.key});

  @override
  State<StatefulWidget> createState() => EmotionPageState();
}

class EmotionPageState extends State<EmotionPage> {
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  double _sleepySliderValue = 20;
  double _hungrySliderValue = 20;
  double _angrySliderValue = 20;
  double _boredSliderValue = 20;
  String mood = "lib/Assets/Emotions/Happy.png";
  String moodStatus = "Happy";
  Color bgColor = Colors.green;

 void _emotionCheck(){
   if(_angrySliderValue == 100 || ((_angrySliderValue > (_sleepySliderValue + _hungrySliderValue + _boredSliderValue)) && _angrySliderValue > 20)){
     mood = "lib/Assets/Emotions/Angry.png";
     bgColor = Colors.red;
     UserData.updateMood("Angry");
     UserData.updateMoodPic(mood);
   } else if (((_sleepySliderValue == 100 && _hungrySliderValue != 100 && _boredSliderValue != 100) && (_hungrySliderValue < 60 && _angrySliderValue < 60 && _boredSliderValue < 60)) || ((_sleepySliderValue > (_hungrySliderValue + _angrySliderValue + _boredSliderValue)) && _sleepySliderValue > 20)) {
     mood = "lib/Assets/Emotions/Sleepy.png";
     bgColor = Colors.blue;
     UserData.updateMood("Sleepy");
     UserData.updateMoodPic(mood);
   } else if (((_hungrySliderValue == 100 && _sleepySliderValue != 100 && _boredSliderValue != 100) && (_sleepySliderValue < 60 && _angrySliderValue < 60 && _boredSliderValue < 60)) || ((_hungrySliderValue > (_angrySliderValue + _sleepySliderValue + _boredSliderValue)) && _hungrySliderValue > 20)){
     mood = "lib/Assets/Emotions/Hungry.png";
     bgColor = Colors.orange.shade400;
     UserData.updateMood("Hungry");
     UserData.updateMoodPic(mood);
   } else if (((_boredSliderValue == 100 && _sleepySliderValue != 100 && _hungrySliderValue != 100) && (_sleepySliderValue < 60 && _angrySliderValue < 60 && _hungrySliderValue <60)) ||((_boredSliderValue > (_angrySliderValue + _hungrySliderValue + _sleepySliderValue)) && _boredSliderValue > 20)) {
     mood = "lib/Assets/Emotions/Bored.png";
     bgColor = Colors.grey;
     UserData.updateMood("Bored");
     UserData.updateMoodPic(mood);
   } else if ((_sleepySliderValue + _hungrySliderValue + _angrySliderValue + _boredSliderValue) >= 160 && (_sleepySliderValue + _hungrySliderValue + _angrySliderValue + _boredSliderValue) < 220) {
     mood = "lib/Assets/Emotions/Annoyed.png";
     bgColor = Colors.yellow;
     UserData.updateMood("Annoyed");
     UserData.updateMoodPic(mood);
   } else if ((_sleepySliderValue + _hungrySliderValue + _angrySliderValue + _boredSliderValue) >= 220 && (_sleepySliderValue + _hungrySliderValue + _angrySliderValue + _boredSliderValue) < 300){
     mood = "lib/Assets/Emotions/Sad.png";
     bgColor = Colors.blue.shade800;
     UserData.updateMood("Sad");
     UserData.updateMoodPic(mood);
   } else if ((_sleepySliderValue + _hungrySliderValue + _angrySliderValue + _boredSliderValue) >= 300) {
     mood = "lib/Assets/Emotions/Frustrated.png";
     bgColor = Colors.blue.shade900;
     UserData.updateMood("Frustrated");
     UserData.updateMoodPic(mood);
   } else {
     mood = "lib/Assets/Emotions/Happy.png";
     bgColor = Colors.green;
     UserData.updateMood("Happy");
     UserData.updateMoodPic(mood);
   }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emotion"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
                _dataFetcher.saveData(UserData.id, "mood", UserData.mood);
                _dataFetcher.saveData(UserData.id, "mood_pic", UserData.moodPic);
              },
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: bgColor,
                child: Image.asset(mood),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Sleepy: "),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Slider(
                        value: _sleepySliderValue,
                        max: 100,
                        min: 0,
                        divisions: 5,
                        label: _sleepySliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _sleepySliderValue = value;
                            _emotionCheck();
                          });
                        }),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Hungry: "),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Slider(
                        value: _hungrySliderValue,
                        max: 100,
                        min: 0,
                        divisions: 5,
                        label: _hungrySliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _hungrySliderValue = value;
                            _emotionCheck();
                          });
                        }),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Angry: "),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Slider(
                        value: _angrySliderValue,
                        max: 100,
                        min: 0,
                        divisions: 5,
                        label: _angrySliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _angrySliderValue = value;
                            _emotionCheck();
                          });
                        }),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Bored: "),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Slider(
                        value: _boredSliderValue,
                        max: 100,
                        min: 0,
                        divisions: 5,
                        label: _boredSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _boredSliderValue = value;
                            _emotionCheck();
                          });
                        }),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
