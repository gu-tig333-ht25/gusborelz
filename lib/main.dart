import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class Task {
  String name;
  bool isDone;

  Task({required this.name, this.isDone = false});
}
//den ovan annvänds för att skapa task 

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
List<Task> tasks = [];
String activeFilter = 'Undone'; // Standardfilter

int hoveredIndex = -1;


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
  title: Row(
    children: const [
      Text(
        'My ToDo app',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ],
  ),
),
//ovan är koden för todo rubrik i appbar

drawer: Drawer(
  width: 200,
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 103, 192, 228),
        ),
        child: Text(
          'Filter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        title: const Text('All'),
        onTap: () {
          setState(() {
            activeFilter = 'All';
          });
          Navigator.pop(context); // Stänger menyn
        },
      ),
      ListTile(
        title: const Text('Done'),
        onTap: () {
          setState(() {
            activeFilter = 'Done';
          });
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('Undone'),
        onTap: () {
          setState(() {
            activeFilter = 'Undone';
          });
          Navigator.pop(context);
        },
      ),
    ],
  ),
),
//Ovan är koden för hamburgarmenyn 

body: Column(
  children: [
    const SizedBox(height: 20), // Avstånd från AppBar
    const Center(
      child: Text(
        'My Tasks',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const SizedBox(height: 10), // Litet avstånd till knappen
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
          onPressed: () {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      String newTaskName = '';

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Lägg till ny uppgift',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Uppgift',
              ),
              onChanged: (value) {
                newTaskName = value;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (newTaskName.trim().isNotEmpty) {
                  setState(() {
                    tasks.add(Task(name: newTaskName));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Lägg till'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
},

        ),
      ),
    ),
    const SizedBox(height: 40), // Avstånd till resten av innehållet
Expanded(
  child: tasks.isEmpty
      ? Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
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
                              value: filteredTasks[index].isDone,
                              onChanged: (bool? value) {
                              setState(() {
                                // Hitta rätt task i den ursprungliga listan
                                final task = filteredTasks[index];
                                final taskIndex = tasks.indexOf(task);
                                if (taskIndex != -1) {
                                  tasks[taskIndex].isDone = value!;
                                }
                              });
                            },
                              activeColor: Colors.green,
                            ),
                            Expanded(
                              child: Text(
                                filteredTasks[index].name,
                                style: TextStyle(
                                  decoration: filteredTasks[index].isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MouseRegion(
                        onEnter: (_) => setState(() => hoveredIndex = index),
                        onExit: (_) => setState(() => hoveredIndex = -1),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                           color: hoveredIndex == index
                              ? Colors.red
                              : const Color.fromARGB(255, 201, 196, 196),
                       ),
                       onPressed: () {
                        setState(() {
                          tasks.remove(filteredTasks[index]);
                        });
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
), // Column
); // Scaffold
  }  // <-- stänger build-metoden
}    // <-- stänger _MyHomePageState-klassen