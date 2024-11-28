import 'dart:convert'; // For JSON decoding
import 'dart:io';
import 'package:http/http.dart' as http;

class VisaApiService {
  final String baseUrl;

  VisaApiService(this.baseUrl);

  /**Future<List<dynamic>> fetchVisaData(String keyword) async {
    final url = Uri.parse('$baseUrl');

    try {
      final response = await http.get(
          url,
          headers: {
            'x-rapidapi-key': '992459bb68msh45021d66ac0e19bp1f3315jsn3a55c9945658',
            'x-rapidapi-host': 'visa-list.p.rapidapi.com'
      }
      );
      if (response.statusCode == 200) {
        // Decode JSON response
        final data = json.decode(response.body);
        return data['results']; // Adjust this based on API response format
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      return [];
    }
  }**/

  Future<List<dynamic>> fetchVisaRequirements() async {
    final url = Uri.parse('https://scrape.abstractapi.com/v1/');
    final headers = {
      'api_key': 'ae68fe88ebec45caa33e204338bb7c8a',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        // Decode the JSON and return the 'results' list or appropriate field
        final data = json.decode(response.body);
        return data; // Adjust based on API response structure
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
