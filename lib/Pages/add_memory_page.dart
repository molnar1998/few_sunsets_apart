import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Models/memory.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddMemoryPage extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final String memoryId;
  final int mYear;
  final int mMonth;
  final int mDay;
  final bool isEdit;

  const AddMemoryPage({
    super.key,
    this.title = "",
    this.description = "",
    this.imagePath = "",
    this.memoryId = "",
    this.mYear = 2023,
    this.mMonth = 05,
    this.mDay = 30,
    this.isEdit = false
  });

  @override
  State<StatefulWidget> createState() => AddMemoryPageState();

}

class AddMemoryPageState extends State<AddMemoryPage> {
  final storageRef = FirebaseStorage.instance.ref();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FilePickerResult? result;
  DateTime selectedDate = DateTime.now();
  String userID = UserData.id;
  String memID = "";

  Future<void> _pickPictures() async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png']
    );
  }

  Future<void> _saveMemory() async {
    if(widget.isEdit){
      var now = Timestamp.now();
      if(result != null) {
        var i = 0;
        for (var file in result!.files) {
          await FirebaseStorage.instance.ref("${widget.imagePath}/$i").putFile(File(file.path!));
          i++;
        }
      }
        Memory newMemory = Memory(
          imagePath: widget.imagePath,
          text: _descriptionController.text,
          title: _titleController.text,
          date: selectedDate,
          createdAt: now,
        );
        await _firestore
            .collection('memories').doc(userID)
            .collection('memory').doc(widget.memoryId).set(newMemory.toMap());

    } else {
      var now = Timestamp.now();
      memID = "$userID ${now.toDate().toString()}";
      if(result != null) {
        var i = 0;
        for (var file in result!.files) {
          await FirebaseStorage.instance.ref("memories/$memID/$i").putFile(File(file.path!));
          i++;
        }
      }
        Memory newMemory = Memory(
          imagePath: "memories/$memID/",
          text: _descriptionController.text,
          title: _titleController.text,
          date: selectedDate,
          createdAt: now,
        );

        await _firestore
            .collection('memories').doc(userID)
            .collection('memory').add(newMemory.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isEdit){
      _titleController = TextEditingController(text: widget.title);
      _descriptionController = TextEditingController(text: widget.description);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Save your memory!"),
        actions: [
          Visibility(
            visible: !widget.isEdit,
            child: IconButton(
                onPressed: () =>
                {Navigator.pushReplacementNamed(context, '/memories')},
                icon: const Icon(Icons.arrow_back_ios_new)),
          )
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        _pickPictures();
                      },
                      label: Text("Add photos!"),
                      icon: Icon(Icons.photo),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter a title!';
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputDatePickerFormField(
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2999),
                  initialDate: DateTime(widget.mYear, widget.mMonth, widget.mDay),
                  onDateSubmitted: (time) {
                    setState(() {
                      selectedDate = time;
                    });
                  },
                  onDateSaved: (time) {
                    setState(() {
                      selectedDate = time;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter a description!';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                  autocorrect: true,
                  minLines: 1,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[900],
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _formKey.currentState?.save();
                  if(_formKey.currentState!.validate()){
                    _saveMemory().whenComplete(() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Memory created!'),
                          content: Text('Your ${_titleController.text} successfully created!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => {
                                Navigator.pop(context, 'Okay'),
                                Navigator.pushReplacementNamed(context, '/memories')
                              },
                              child: const Text('Okay'),
                            ),
                          ],
                        )
                      );
                    });
                  }
                },
                icon: const Icon(Icons.save),
                label: Text('Save this memory'.toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }

}