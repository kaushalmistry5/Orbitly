import 'dart:convert';
import 'package:http/http.dart' as http;

class ApodApiService {
  Future<Map<String, dynamic>> fetchApod() async {
    final uri = Uri.https(
      'images-api.nasa.gov',
      '/search',
      {
        'q': 'mars', // start with ONE keyword
        'media_type': 'image',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load NASA images');
    }

    return json.decode(response.body);
  }
}