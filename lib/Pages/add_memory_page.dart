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
  final List<String> selectedFriends;
  final Timestamp createdAt;

  AddMemoryPage({
    super.key,
    this.title = "",
    this.description = "",
    this.imagePath = "",
    this.memoryId = "",
    this.mYear = 2023,
    this.mMonth = 05,
    this.mDay = 30,
    this.isEdit = false,
    List<String>? selectedFriends,
    Timestamp? createdAt,
  }) : selectedFriends = selectedFriends ?? [], createdAt = createdAt ?? Timestamp.now();

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
  List<String> removedFriends = [];

  Future<void> _pickPictures() async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png']
    );
  }

  void _showAddPeopleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Friends"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: UserData.friends.map((friend) {
                    bool isSelected = widget.selectedFriends.any((f) => f == friend.friendId);
                    return CheckboxListTile(
                      title: Text(friend.friendUId), // Access the name field
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            widget.selectedFriends.add(friend.friendId);
                            removedFriends.removeWhere((f) => f == friend.friendId);

                          } else {
                            widget.selectedFriends.removeWhere((f) => f == friend.friendId);
                            removedFriends.add(friend.friendId);
                          }
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
                    print("Selected Friends: $widget.selectedFriends");
                    Navigator.pop(context, widget.selectedFriends);
                  },
                  child: Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveMemory() async {
    if(widget.isEdit){
      var now = widget.createdAt;
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
          friends: widget.selectedFriends
        );
        await _firestore
            .collection('memories').doc(userID)
            .collection('memory').doc(widget.memoryId).set(newMemory.toMap());
        if(widget.selectedFriends.isNotEmpty){
          for(var friendID in widget.selectedFriends){
            // Check if the memory is already shared with the friend
            if(!await _firestore.collection('memories').doc(friendID).collection('shared_memory').where('memoryId', isEqualTo: widget.memoryId).get().then((value) => value.docs.isNotEmpty)){
              Map<String, dynamic> newSharedMemory = {'owner' : userID, 'memoryId' : widget.memoryId};
              await _firestore.collection('memories').doc(friendID).collection('shared_memory').add(newSharedMemory);
            }
          }
        }
        // Remove the memory from the old friends
        if(removedFriends.isNotEmpty){
          for(var friendID in removedFriends){
            await _firestore.collection('memories').doc(friendID).collection('shared_memory').where('memoryId', isEqualTo: widget.memoryId).get().then((value) {
              for(var doc in value.docs){
                doc.reference.delete();
              }
            });
          }
        }
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
          friends: widget.selectedFriends
        );

        await _firestore
            .collection('memories').doc(userID)
            .collection('memory').add(newMemory.toMap());
        if(widget.selectedFriends.isNotEmpty){
          for(var friendID in widget.selectedFriends){
            Map<String, dynamic> newSharedMemory = {'owner' : userID, 'memoryId' : memID};
            await _firestore.collection('memories').doc(friendID).collection('shared_memory').add(newSharedMemory);
          }
        }
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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _pickPictures();
                      },
                      label: Text("Add photos!"),
                      icon: Icon(Icons.photo),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddPeopleDialog(context);
                      },
                      label: Text("Add people!"),
                      icon: Icon(Icons.people),
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
                  setState(() {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Wait a moment!'),
                          content: Column(mainAxisSize: MainAxisSize.min,children: [Text("Wait a moment while we save your memory!"),CircularProgressIndicator()],),
                        )
                    );
                  });
                  if(_formKey.currentState!.validate()){
                    _saveMemory().whenComplete(() {
                      if(context.mounted){
                        Navigator.pop(context, 'Wait a moment!');
                        showDialog(
                          context: context,
                            barrierDismissible: false,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Memory created!'),
                            content: Text('Your ${_titleController.text} successfully created!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {
                                  Navigator.pop(context, 'Okay'),
                                  if(!widget.isEdit){
                                    Navigator.pushReplacementNamed(context, '/memories')
                                  }
                                },
                                child: const Text('Okay'),
                              ),
                            ],
                          )
                        );
                      }
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