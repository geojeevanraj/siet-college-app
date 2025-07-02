import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class AddUserPage extends StatefulWidget {
  final String role; // Accept role from constructor

  AddUserPage({required this.role});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _addUser() async {
    final url = Uri.parse(
      widget.role == "faculty"
          ? 'http://10.0.2.2:5000/add_faculty'
          : 'http://10.0.2.2:5000/add_student',
          // ? 'http://$baseURL/add_faculty'
          // : 'http://$baseURL/add_student',

    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": _usernameController.text.trim(),
        "password": _passwordController.text.trim(),
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
      appBar: AppBar(title: Text("Add ${widget.role.capitalize()}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addUser, child: Text("Add ${widget.role.capitalize()}")),
          ],
        ),
      ),
    );
  }
}

extension StringCasing on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
