import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models.http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    print(_token);
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyAzZryY5K54TJLbQLz8-LuHa2dy103wiKM';
    try {
      final res = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final resonseData = jsonDecode(res.body);
      print(resonseData);
      if (resonseData['error'] != null) {
        throw HttpException(resonseData['error']['message']);
      }
      _token = resonseData['idToken'];
      _userId = resonseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resonseData['expiresIn'])));
      notifyListeners();
    } on Exception catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}
