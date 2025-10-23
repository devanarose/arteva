import 'dart:convert';
import 'package:erp_demo/models/banner_item.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIHelper {
  static const String baseUrl = 'https://admin.abemart.in/api';

  static Future<Map<String, dynamic>> guest() async {
    final url = Uri.parse('$baseUrl/guest');

    try {
      final response = await http.post(url);

      if (response.statusCode >= 200 && response.statusCode < 300) {
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

  static Future<Map<String, dynamic>> banner() async {
    final url = Uri.parse('$baseUrl/banners');
    try {
      final response = await http.get(url);
      print('API response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        final banners = jsonData.map((item) => {
          'banner_id': item['banner_id'],
          'banner_name': item['banner_name'],
          'banner_image': item['banner_image'],
          'banner_link': item['banner_link'],
          'banner_link_type': item['banner_link_type'],
        }).toList();

        // final banners = jsonData.map((item) => BannerItem.fromJson(item)).toList();

        // print('Parsed banners: $banners');
        return {
          'status': true,
          'message': 'Banner image loaded',
          'data': banners,
        };
      } else {
        return {
          'status': false,
          'message': 'Banner fetch failed: ${response.body}',
        };
      }
    } catch (e) {
      print("Banner API error: $e");
      return {
        'status': false,
        'message': 'Something went wrong: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> category() async {
    final url = Uri.parse('$baseUrl/categories');
    try{
      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        final filteredData = jsonData.where((item) => item['category_image'] != null);

        final categories = filteredData.map((item) => {
          'category_id': item['category_id'],
          'category_name': item['category_name'],
          'category_image': item['category_image'],
        }).toList();

        // print('categories: ');
        // print(categories);
        return {
          'status': true,
          'message': 'categories image loaded',
          'data': categories,
        };
      } else {
        return {
          'status': false,
          'message': 'categories fetch failed: ${response.body}',
        };
      }
    } catch(e){
      print("categories API error: $e");
      return {
        'status': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}