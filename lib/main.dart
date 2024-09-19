import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 23, 97, 50)),
        useMaterial3: true,
      ),
      home: const TodaApp(),
    );
  }
}

class TodaApp extends StatefulWidget {
  const TodaApp({super.key});

  @override
  State<TodaApp> createState() => _TodaAppState();
}

class _TodaAppState extends State<TodaApp> {
  late TextEditingController _texteditController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _texteditController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  // Function to show dialog for adding or editing a task
  void showTaskDialog(BuildContext context,
      {String? taskId, String? initialName, String? initialDescription}) {
    _texteditController.text = initialName ?? '';
    _descriptionController.text = initialDescription ?? '';

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(taskId == null ? "Add new task" : "Edit task"),
            content: SizedBox(
              width: 120,
              height: 140,
              child: Column(
                children: [
                  TextField(
                    controller: _texteditController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Task Name"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Description"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (_texteditController.text.isNotEmpty) {
                      if (taskId == null) {
                        // Add new task
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .add({
                          'name': _texteditController.text,
                          'description': _descriptionController.text,
                          'completed': false, // Default status
                        });
                      } else {
                        // Update existing task
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(taskId)
                            .update({
                          'name': _texteditController.text,
                          'description': _descriptionController.text,
                        });
                      }

                      _texteditController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"))
            ],
          );
        });
  }

  // Function to delete a task
  void deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  }

  // Function to toggle the completion status of a task
  void toggleTaskStatus(String taskId, bool currentStatus) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'completed': !currentStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var tasks = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return ListTile(
                  title: Text(
                    task['name'],
                    style: TextStyle(
                      decoration: task['completed']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task['completed'] ? Colors.green : Colors.black,
                    ),
                  ),
                  subtitle: Text(task['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          task['completed']
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: task['completed'] ? Colors.green : null,
                        ),
                        onPressed: () {
                          toggleTaskStatus(task.id, task['completed']);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showTaskDialog(
                            context,
                            taskId: task.id,
                            initialName: task['name'],
                            initialDescription: task['description'],
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteTask(task.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
