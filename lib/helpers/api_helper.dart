import 'dart:convert';
import 'package:http/http.dart' as http;


class APIHelper {
  
  static Future<Map<String, dynamic>> loginApi(String username,
      String password) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        return {
          'status': true,
          'message': 'Login successful',
          'token': jsonData['accessToken'],
          'user': jsonData,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'status': false,
          'message': error['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}

