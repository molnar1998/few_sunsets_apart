import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewMemories extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath; // Optional folder path

  const ViewMemories({
    Key? key,
    this.title = "No Title",
    this.description = "No Description",
    this.imagePath = "", // Default to an empty string
  }) : super(key: key);

  Future<List<String>> _fetchImagesFromFolder(String path) async {
    if (path.isEmpty) return []; // Return empty list if no path provided

    final ref = FirebaseStorage.instance.ref(path);
    final listResult = await ref.listAll();

    // Get URLs for each item in the folder
    return Future.wait(listResult.items.map((item) => item.getDownloadURL()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<String>>(
                future: _fetchImagesFromFolder(imagePath),
                builder: (context, snapshot) {
                  if (imagePath.isEmpty) {
                    return Center(
                      child: Text("No images available for this memory."),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error loading images"),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No images available in this memory."),
                    );
                  } else {
                    final imageUrls = snapshot.data!;
                    return SizedBox(
                      height: 400,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                                width: 300,
                                height: 200,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
