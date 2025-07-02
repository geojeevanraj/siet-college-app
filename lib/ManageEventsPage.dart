import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class ManageEventsPage extends StatefulWidget {
  @override
  _ManageEventsPageState createState() => _ManageEventsPageState();
}

class _ManageEventsPageState extends State<ManageEventsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> _postEvent() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/add_event'),
      // Uri.parse('$baseURL/add_event'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
        'date': dateController.text,
      }),
    );

    final responseData = jsonDecode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(responseData['message'] ?? 'Unknown error')),
    );

    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      dateController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Events')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _postEvent, child: Text('Post Event')),
          ],
        ),
      ),
    );
  }
}
