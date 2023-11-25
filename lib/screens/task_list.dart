import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:assignment_app/screens/add_task_screen.dart';
import 'package:assignment_app/screens/task_details_screen.dart';

// Define the Task class
class Task {
  final String objectId; // Added objectId to uniquely identify tasks
  final String title;
  final String description;

  Task(
      {required this.objectId, required this.title, required this.description});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchTasks();
  }

  // Implement the logic for fetching tasks from Back4App
  Future<List<Task>> fetchTasks() async {
    final ParseResponse apiResponse = await ParseObject('Task').getAll();

    if (apiResponse.success && apiResponse.result != null) {
      final List<ParseObject> parseObjects =
          (apiResponse.results! as List).cast<ParseObject>();
      final List<Task> tasks = parseObjects.map((parseObject) {
        return Task(
          objectId: parseObject.objectId!,
          title: parseObject.get<String>('title') ?? '',
          description: parseObject.get<String>('description') ?? '',
        );
      }).toList();
      return tasks;
    } else {
      print('Error querying tasks: ${apiResponse.error?.message}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        centerTitle: true,
        automaticallyImplyLeading:
            false, // Set this to false to hide the back button
      ),
      body: FutureBuilder(
        // Use a FutureBuilder to asynchronously load and display tasks
        future: _futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while fetching tasks
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if an error occurs
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the list of tasks
            List<Task> tasks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Task task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),

                  // Add onTap to navigate to the task details screen
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          objectId: task.objectId,
                          title: task.title,
                          description: task.description,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the screen for adding new tasks
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
