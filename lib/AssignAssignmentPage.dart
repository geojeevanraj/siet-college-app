import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class AssignAssignmentPage extends StatefulWidget {
  @override
  _AssignAssignmentPageState createState() => _AssignAssignmentPageState();
}

class _AssignAssignmentPageState extends State<AssignAssignmentPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  Future<void> assignAssignment() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/assign_assignment'),
      // Uri.parse('$baseURL/assign_assignment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
        'due_date': dueDateController.text,
      }),
    );

    final jsonResponse = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(jsonResponse['message'])),
    );

    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      dueDateController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assign Assignment")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: dueDateController, decoration: InputDecoration(labelText: "Due Date (optional)")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: assignAssignment, child: Text("Assign")),
          ],
        ),
      ),
    );
  }
}
