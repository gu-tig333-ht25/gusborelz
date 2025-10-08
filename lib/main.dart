//Steg3
import 'package:flutter/material.dart';
import 'api_service.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo app',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// MODEL: Task
class Task {
  String id;
  String name;
  bool isDone;

  Task({required this.id, required this.name, this.isDone = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      name: json['title'],
      isDone: json['done'] ?? false,
    );
  }
}

// HUVUDSIDAN

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = [];
  String activeFilter = 'All';
  String hoveredIndex = '';

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final taskList = await ApiService.getTasks();
    setState(() {
      tasks = taskList.map((json) => Task.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = tasks.where((task) {
      if (activeFilter == 'All') return true;
      if (activeFilter == 'Done') return task.isDone;
      if (activeFilter == 'Undone') return !task.isDone;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        title: const Text(
          'My ToDo app',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      
      // HAMBURGARMENYN
      
      drawer: Drawer(
        width: 200,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 103, 192, 228)),
              child: Text('Filter',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('All'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FilteredTasksPage(filter: 'All')),
                );
              },
            ),
            ListTile(
              title: const Text('Done'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FilteredTasksPage(filter: 'Done')),
                );
              },
            ),
            ListTile(
              title: const Text('Undone'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FilteredTasksPage(filter: 'Undone')),
                );
              },
            ),
          ],
        ),
      ),

      
      // INNEHÅLL
      
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'My Tasks',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTaskPage()),
                  );
                  if (result == true) {
                    await fetchTasks(); // Uppdatera när man lagt till något
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'No tasks yet.\nPress the plus button to add something you want to do.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: task.isDone,
                                        onChanged: (bool? value) async {
                                          await ApiService.updateTask(
                                              task.id, value!);
                                          if (!context.mounted) return;
                                          await fetchTasks();
                                        },
                                        activeColor: Colors.green,
                                      ),
                                      Expanded(
                                        child: Text(
                                          task.name,
                                          style: TextStyle(
                                            decoration: task.isDone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                MouseRegion(
                                  onEnter: (_) =>
                                      setState(() => hoveredIndex = task.id),
                                  onExit: (_) =>
                                      setState(() => hoveredIndex = ''),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: hoveredIndex == task.id
                                          ? Colors.red
                                          : const Color.fromARGB(
                                              255, 201, 196, 196),
                                    ),
                                    onPressed: () async {
                                      await ApiService.deleteTask(task.id);
                                      if (!context.mounted) return;
                                      await fetchTasks();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 220, 220, 220),
                            thickness: 0.5,
                            height: 1,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


// NY SIDA FÖR ATT LÄGGA TILL UPPGIFT
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addTask() async {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      await ApiService.addTask(name);
      if (!context.mounted) return;
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lägg till ny uppgift')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Uppgift'),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Lägg till'),
            ),
          ],
        ),
      ),
    );
  }
}

// NY SIDA FÖR FILTRERING

class FilteredTasksPage extends StatefulWidget {
  final String filter;
  const FilteredTasksPage({super.key, required this.filter});

  @override
  State<FilteredTasksPage> createState() => _FilteredTasksPageState();
}

class _FilteredTasksPageState extends State<FilteredTasksPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final taskList = await ApiService.getTasks();
    setState(() {
      tasks = taskList.map((json) => Task.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filtered = tasks.where((task) {
      if (widget.filter == 'All') return true;
      if (widget.filter == 'Done') return task.isDone;
      if (widget.filter == 'Undone') return !task.isDone;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Filter: ${widget.filter}')),
      body: filtered.isEmpty
          ? const Center(child: Text('Inga uppgifter hittades'))
          : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final task = filtered[index];
                return ListTile(
                  title: Text(task.name),
                  trailing: Icon(
                    task.isDone ? Icons.check_circle : Icons.circle_outlined,
                    color: task.isDone ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
    );
  }
}