import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://api.ponto.it4d.com.br/api/v1';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      if (token == null) {
        throw Exception('Erro no login: Token não encontrado.');
      }
      await saveToken(token);
      return token;
    } else {
      throw Exception('Erro no login. Verifique as credenciais.');
    }
  }

  static Future<List<dynamic>> getUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] is List) {
        return data['data'];
      } else {
        throw Exception('Erro');
      }
    } else {
      throw Exception('Erro ao carregar lista de usuários.');
    }
  }

  static Future<Map<String, dynamic>> getUserInfo(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
      }),
    );

    print('Status Code (getUserInfo): ${response.statusCode}');
    print('Response Body (getUserInfo): ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao carregar informações do usuário.');
    }
  }


  static Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await deleteToken();
    } else {
      throw Exception('Erro ao fazer logout.');
    }
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> loadToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
