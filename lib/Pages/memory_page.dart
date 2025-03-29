import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:few_sunsets_apart/Pages/add_memory_page.dart';
import 'package:few_sunsets_apart/Pages/view_memories.dart';
import 'package:few_sunsets_apart/Widgets/memory_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MemoriesPage extends StatefulWidget {
  const MemoriesPage({super.key});

  @override
  State<StatefulWidget> createState() => MemoriesPageState();
}

class MemoriesPageState extends State<MemoriesPage> {
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () =>
                  {Navigator.pushReplacementNamed(context, '/home')},
              icon: const Icon(Icons.arrow_back_ios_new))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton.icon(
                      onPressed: () => {
                        Navigator.pushReplacementNamed(context, '/addMemory'),
                      },
                      label: const Text("Add memories"),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton.icon(
                      onPressed: () => {
                        Navigator.pushReplacementNamed(context, '/sharedMemory'),
                      },
                      label: const Text("Shared memories"),
                      icon: const Icon(Icons.share),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: _buildMemoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryList() {
    return StreamBuilder(
        stream: _dataFetcher.getMemories(UserData.id),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text('Loading..');
          }

          return ListView(
            children: snapshot.data!.docs.
            map((document) => _buildMemoryItem(document)).toList(),
          );
        },
    );
  }

  //build memory item
  Widget _buildMemoryItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MemoryCard(
              title: data['title'],
              text: data['text'],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ViewMemories(
                        title: data['title'],
                        description: data['text'],
                        imagePath: data['imagePath'],
                      )
                  )
                );
              },
              onDeleteMemory: () async {
                _dataFetcher.deleteMemory(UserData.id, data['createdAt']);
                var pictures = await FirebaseStorage.instance.ref(data['imagePath']).list();
                for(var picture in pictures.items){
                  picture.delete();
                }
              },
              onEditMemory: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AddMemoryPage(
                        title: data['title'],
                        description: data['text'],
                        imagePath: data['imagePath'],
                        memoryId: document.id,
                        mYear: data['date'].toDate().year,
                        mMonth: data['date'].toDate().month,
                        mDay: data['date'].toDate().day,
                        selectedFriends: (data['friends'] as List<dynamic>?)?.cast<String>() ?? [],
                        createdAt: data['createdAt'],
                        isEdit: true,
                      )
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
