import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final Future<void> Function() onInit;
  final Widget homePage;

  const LoadingPage({
    Key? key,
    required this.onInit,
    required this.homePage,
  }) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  double _progressValue = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Simulate async tasks and update progress
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(Duration(milliseconds: 10));
        setState(() {
          _progressValue = i / 100;
        });
      }

      // Perform your async tasks here
      await widget.onInit();
    } catch (e) {
      // Handle errors here
      print('Error during initialization: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(value: _progressValue),
            SizedBox(height: 20),
            Text('Loading... $_progressValue%'),
          ],
        ),
      ),
    );
  }
}