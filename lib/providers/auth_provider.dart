import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/api_helper.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;
  int? _userId;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  int? get userId => _userId;
  bool isGuest = false;

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

  Future<Map<String, dynamic>> guestold() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userJson = prefs.getString('user_info');

    if (token != null && userJson != null) {
      _token = token;
      _user = jsonDecode(userJson);
      isGuest = true;
      _userId = _user!['user_id'];
      notifyListeners();
      return {
        'status': true,
        'message': 'Guest login already exists',
        'token': _token,
        'user_id': _user!['user_id'],
        'name': _user!['name'],
      };
    }

    final result = await APIHelper.guestApi();

    if (result['status']) {
      _token = result['token'];
      _user = {
        'user_id': result['user_id'],
        'name': result['name'],
      };

      await prefs.setString('access_token', _token!);
      await prefs.setInt('user_id', int.parse(result['user_id']));
      await prefs.setString('name', result['name']!);
      await prefs.setBool('isGuest', isGuest);
      // await prefs.setString('user_info', jsonEncode(_user));

      isGuest = true;
      notifyListeners();
    }
    print(result);
    return result;
  }

  // Future<bool> isAuthenticated() async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   final token = prefs.getString('access_token');
  //   if(token != null)
  //
  // }
  Future<bool> isAuthenticated() async {
    final prefs1 = await SharedPreferences.getInstance();

    final token = prefs1.getString('access_token');

    print("token To $token");
    if(token == null){
      final result = await APIHelper.guestApi();
      if (result['status'] != true){
        // show "error"
        return false;
      }
    }

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('access_token');
    _userId = prefs.getInt('user_id');
    // _name = prefs.getString('name');
    isGuest = prefs.getBool('isGuest') ?? true;


    return true;




    // final userJson = prefs.getString('user_info');
    //
    // if (token != null && userJson != null) {
    //   _token = token;
    //   _user = jsonDecode(userJson);
    //   isGuest = true;
    //   _userId = _user!['user_id'];
    //   notifyListeners();
    //   return {
    //     'status': true,
    //     'message': 'Guest login already exists',
    //     'token': _token,
    //     'user_id': _user!['user_id'],
    //     'name': _user!['name'],
    //   };
    // }
    //
    // final result = await APIHelper.guestApi();
    //
    // if (result['status']) {
    //   _token = result['token'];
    //   _user = {
    //     'user_id': result['user_id'],
    //     'name': result['name'],
    //   };
    //
    //
    //   // await prefs.setString('user_info', jsonEncode(_user));
    //
    //   isGuest = true;
    //   notifyListeners();
    // }
    // print(result);
    // return result;
  }



  // Future<Map<String,dynamic>> login(String username,String password){
  //   isGuest = false;
  //   return 'hiu';
  // }

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
  bool get isLoggedIn => _token != null && _user != null;

  Future login(String username, String password) async {}
}
