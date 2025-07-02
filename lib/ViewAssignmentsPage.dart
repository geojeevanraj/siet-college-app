import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class ViewAssignmentsPage extends StatefulWidget {
  @override
  _ViewAssignmentsPageState createState() => _ViewAssignmentsPageState();
}

class _ViewAssignmentsPageState extends State<ViewAssignmentsPage> {
  List assignments = [];

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_assignments'));
    // final response = await http.get(Uri.parse('$baseURL/get_assignments'));
    final data = jsonDecode(response.body);
    setState(() {
      assignments = data['assignments'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assignments")),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final item = assignments[index];
          return ListTile(
            title: Text(item['title']),
            subtitle: Text(item['description']),
            trailing: Text(item['due_date'] ?? ""),
          );
        },
      ),
    );
  }
}
