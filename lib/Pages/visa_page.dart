import 'package:flutter/material.dart';

import '../Data/apitest.dart';

class VisaPage extends StatelessWidget {
  final VisaApiService apiService = VisaApiService("https://visa-list.p.rapidapi.com/api/public/countries?limit=25");

  VisaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visa Information')),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchVisaRequirements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No results found.'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(item['title']), // Adjust field name as per API response
                  subtitle: Text(item['description']), // Adjust as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
