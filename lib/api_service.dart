import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://todoapp-api.apps.k8s.gu.se';
  static const String group = '91fbf6dd-e898-46d1-9a77-0ddcb5d437c3'; 

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todos?key=$group'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static Future<void> addTask(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos?key=$group'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'done': false}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  static Future<void> updateTask(String id, bool done) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/$id?key=$group'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'done': done}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  static Future<void> deleteTask(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id?key=$group'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
