import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/camera.dart';
import '../models/event_item.dart';

class ApiService {
  static const String baseUrl = 'http://zabbix.tlconsultorias.com.br:8088';

  static String media(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

  Future<bool> login(String user, String password) async {
    final r = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': user,
        'password': password,
      }),
    );

    return r.statusCode == 200;
  }

  Future<Map<String, dynamic>> status() async {
    final r = await http.get(Uri.parse('$baseUrl/api/status'));
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<List<CameraItem>> cameras() async {
    final r = await http.get(Uri.parse('$baseUrl/api/cameras'));
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    return (j['cameras'] as List? ?? [])
        .map((e) => CameraItem.fromJson(e))
        .toList();
  }

  Future<List<EventItem>> events() async {
    final r = await http.get(Uri.parse('$baseUrl/api/events'));
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    return (j['events'] as List? ?? [])
        .map((e) => EventItem.fromJson(e))
        .toList();
  }
}
