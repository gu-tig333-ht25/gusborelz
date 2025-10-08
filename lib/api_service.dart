// api_service.dart
import 'dart:async';


class ApiService {
  static List<Map<String, dynamic>> _tasks = []; // <-- Lokalt minne


  // Hämta alla uppgifter
  static Future<List<Map<String, dynamic>>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulera nätverk
    return _tasks;
  }


  // Lägg till ny uppgift
  static Future<void> addTask(String name) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': name,
      'done': false,
    });
  }


  // Uppdatera status (done/undone)
  static Future<void> updateTask(String id, bool done) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _tasks.indexWhere((task) => task['id'] == id);
    if (index != -1) {
      _tasks[index]['done'] = done;
    }
  }


  // Ta bort uppgift
  static Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.removeWhere((task) => task['id'] == id);
  }
}



