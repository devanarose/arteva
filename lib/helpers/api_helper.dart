import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIHelper {
  static const String baseUrl = 'https://admin.abemart.in/api';

  static Future<Map<String, dynamic>> guestApi() async {
    final url = Uri.parse('$baseUrl/guest');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final token = jsonData['data']['token'];
        final name = jsonData['data']['name'];
        final userId = jsonData['data']['user_id'];

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('access_token', token);
        await prefs.setString('name', name);
        await prefs.setBool('isGuest', true);
        await prefs.setInt('user_id', int.parse("$userId"));

        return {
          'status': true,
          'message': 'Guest login successful',
          // 'token': token,
          // 'user_id': userId,
          // 'name': name,
        };
      } else {
        return {
          'status': false,
          'message': 'Guest login failed: ${response.body}',
        };
      }
    } catch (e) {
      print(e);
      return {
        'status': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}