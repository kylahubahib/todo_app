import 'package:flutter/material.dart';
import 'package:todo_app/add_task.dart';
import 'package:todo_app/database/tasks_database.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/tasks_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<Task> tasks = [];

  Future<void> getAllTasks() async {
    setState(() => isLoading = true);

    tasks = await TasksDatabase.instance.readAllTasks();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Create Task',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildTasksList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddTask()));
          getAllTasks();
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddTask(
                    task: task,
                  ),
                ),
              );

              getAllTasks();
            },
            child: TasksCard(
              task: task,
              onDelete: () {
                setState(() {
                  tasks.remove(task);
                });
              },
            ));
      },
    );
  }
}
