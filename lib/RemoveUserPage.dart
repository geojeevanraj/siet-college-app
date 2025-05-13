import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemoveUserPage extends StatefulWidget {
  @override
  _RemoveUserPageState createState() => _RemoveUserPageState();
}

class _RemoveUserPageState extends State<RemoveUserPage> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _removeUser() async {
    final url = Uri.parse('http://10.0.2.2:5000/remove_faculty');
    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": _usernameController.text.trim(),
      }),
    );

    final result = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Remove Faculty")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: "Username")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _removeUser, child: Text("Remove Faculty")),
          ],
        ),
      ),
    );
  }
}
