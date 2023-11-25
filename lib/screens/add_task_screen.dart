// add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:assignment_app/screens/task_list.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Implement the logic for adding new tasks
  void _addTask() async {
    final ParseObject taskObject = ParseObject('Task')
      ..set('title', _titleController.text)
      ..set('description', _descriptionController.text);

    final ParseResponse apiResponse = await taskObject.save();

    if (apiResponse.success) {
      // Task saved successfully, call fetchTasks in TaskListScreen
      Navigator.pop(context);

      // If you have access to the TaskListScreen's context, you can use it.
      // Otherwise, consider using a global state management solution like Provider.

      // Example using Navigator:
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return TaskListScreen();
      }));
    } else {
      print('Error creating task: ${apiResponse.error?.message}');
      // Handle the error, show a message to the user, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
