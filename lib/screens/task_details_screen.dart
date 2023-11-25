import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:assignment_app/screens/task_list.dart';
import 'package:assignment_app/screens/edit_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String objectId;
  final String title;
  final String description;

  // Constructor to receive task details
  TaskDetailsScreen(
      {required this.objectId, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Trigger task deletion
              _deleteTask(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the EditTaskScreen when the "Edit" button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(
                    currentobjectId: objectId,
                    currentTitle: title,
                    currentDescription: description,
                    onTaskUpdated: () {
                      // Callback function to refetch task details
                      Navigator.pop(context);

                      // If you have access to the TaskListScreen's context, you can use it.
                      // Otherwise, consider using a global state management solution like Provider.
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return TaskListScreen();
                      }));
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }

  // Function to handle task deletion
  void _deleteTask(BuildContext context) async {
    final ParseObject taskObject = ParseObject('Task')..objectId = objectId;
    final ParseResponse apiResponse = await taskObject.delete();
    if (apiResponse.success) {
      // Task deleted successfully, navigate back to the task list
      Navigator.pop(context);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return TaskListScreen();
      }));
    } else {
      // Handle the error, show a message to the user, etc.
      print('Error deleting task: ${apiResponse.error?.message}');
    }
  }
}
