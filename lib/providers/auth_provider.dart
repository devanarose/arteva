import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/api_helper.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  Future<void> loadUserFromPrefs() async { // without this the welcome,-------! will be shown
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userJson = prefs.getString('user_info');

    if (token != null && userJson != null) {
      _token = token;
      _user = jsonDecode(userJson);
      notifyListeners();
    }

    //print('loged in initially');
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final result = await APIHelper.loginApi(username, password);

    if (result['status']) {
      _token = result['token'];
      _user = result['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _token!);
      await prefs.setString('user_info', jsonEncode(_user));

      notifyListeners();
    }
    return result;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _user = null;
    notifyListeners();
  }

  Future<bool> get isAuth async { // loged in or not
    //print('inside isauth');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      return token != null;
    } catch (e) {
      if (kDebugMode) {
        print('isAuth error: $e');
      }
      return false;
    }
  }
}
