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
    final r = await http.get(Uri.parse('$baseUrl/status'));

    if (r.statusCode != 200) {
      throw Exception('Erro ao carregar status: ${r.statusCode}');
    }

    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<List<CameraItem>> cameras() async {
    final r = await http.get(Uri.parse('$baseUrl/cameras'));

    if (r.statusCode != 200) {
      throw Exception('Erro ao carregar câmeras: ${r.statusCode}');
    }

    final decoded = jsonDecode(r.body);

    final List lista = decoded is List
        ? decoded
        : (decoded['cameras'] ?? decoded['data'] ?? []);

    return lista
        .map((e) => CameraItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<EventItem>> events() async {
    final r = await http.get(Uri.parse('$baseUrl/eventos'));

    if (r.statusCode != 200) {
      throw Exception('Erro ao carregar eventos: ${r.statusCode}');
    }

    final decoded = jsonDecode(r.body);

    final List lista = decoded is List
        ? decoded
        : (decoded['events'] ?? decoded['eventos'] ?? decoded['data'] ?? []);

    return lista
        .map((e) => EventItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<dynamic> gravacoes() async {
    final r = await http.get(Uri.parse('$baseUrl/gravacoes'));

    if (r.statusCode != 200) {
      throw Exception('Erro ao carregar gravações: ${r.statusCode}');
    }

    return jsonDecode(r.body);
  }
}
