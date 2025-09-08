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
      title: 'Steg 1- ToDo app',
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
List<Task> tasks = [
  Task(name: 'Städa sovrum'),
  Task(name: 'Släng soppor'),
  Task(name: 'Tvätta vit tvätt'),
  Task(name: 'Handla middag'),
  Task(name: 'Plugga'),
  Task(name: 'Gör matlådor'),
];

  @override
  Widget build(BuildContext context) {
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
//ovan är koden för to do rubrik i appbar

    drawer: Drawer(
      width: 200,
  child: ListView(
    padding: EdgeInsets.zero,
    children: const <Widget>[
      DrawerHeader(
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
        title: Text('All'),
      ),
      ListTile(
        title: Text('Done'),
      ),
        ListTile(
          title: Text('Undone'),
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
  child: ListView.builder(
    itemCount: tasks.length,
itemBuilder: (context, index) {
  return Column(
    children: [
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CheckboxListTile(
                title: Text(tasks[index].name),
                value: tasks[index].isDone,
                onChanged: (bool? value) {
                  setState(() {
                    tasks[index].isDone = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 201, 196, 196)),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
      const Divider(
        color: Color.fromARGB(255, 220, 220, 220), // Ljusgrå färg
        thickness: 0.5, // Tunt streck
        height: 1, // Litet mellanrum
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