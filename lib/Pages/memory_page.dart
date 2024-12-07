import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:few_sunsets_apart/Widgets/memory_card.dart';
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
            FloatingActionButton.extended(
              onPressed: () => {
                Navigator.pushReplacementNamed(context, '/addMemory'),
              },
              label: const Text("Add memories"),
              icon: const Icon(Icons.add),
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

              },
              onDeleteMemory: () {
                _dataFetcher.deleteMemory(UserData.id, data['createdAt']);
              },
              onEditMemory: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
