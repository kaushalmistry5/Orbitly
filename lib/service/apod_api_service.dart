import 'dart:convert';
import 'package:http/http.dart' as http;

class ApodApiService {
  Future<Map<String, dynamic>> fetchApod() async {
    final url = Uri.parse(
      'https://images-api.nasa.gov/search'
          '?q=nebula galaxy jwst hubble mars'
          '&media_type=image',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load NASA images');
    }

    return json.decode(response.body);
  }
}