import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class EditTaskScreen extends StatefulWidget {
  final String currentobjectId;
  final String currentTitle;
  final String currentDescription;
  final VoidCallback onTaskUpdated; // Add callback parameter

  EditTaskScreen({
    required this.currentobjectId,
    required this.currentTitle,
    required this.currentDescription,
    required this.onTaskUpdated, // Pass the callback
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descriptionController =
        TextEditingController(text: widget.currentDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final ParseObject taskObject = ParseObject('Task')
                  ..objectId = widget.currentobjectId; // Set the objectId
                taskObject.set('title', _titleController.text);
                taskObject.set('description', _descriptionController.text);

                final ParseResponse apiResponse = await taskObject.save();

                if (apiResponse.success) {
                  // Task updated successfully, navigate back to TaskListScreen and replace the current route
                  Navigator.pushReplacementNamed(context, '/task_list');
                } else {
                  // Handle the error, show a message to the user, etc.
                  print('Error updating task: ${apiResponse.error?.message}');
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
