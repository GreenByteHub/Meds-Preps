import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class Swagger {
  static Future<bool> registerUser(BuildContext context, String name, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': name,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loginUser(BuildContext context, String name, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'username': name,
          'password': password,
          'scope': '',
          'client_id': '',
          'client_secret': '',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'access_token': responseData['access_token'],
          'token_type': responseData['token_type'] ?? 'Bearer',
        };
      } else {
        print('Ошибка: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Ошибка соединения: $e');
      return null;
    }
  }
}