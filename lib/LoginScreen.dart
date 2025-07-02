import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AdminDashboard.dart';
import 'FacultyDashboard.dart';
import 'StudentDashboard.dart';
import 'constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please fill all fields";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = Uri.parse("http://10.0.2.2:5000/login"); // Android emulator
    // final url = Uri.parse("$baseURL/login"); //Real device
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    setState(() {
      _isLoading = false;
    });

    if (data['success']) {
      String role = data['role'];
      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => (AdminDashboard(username: username))));
      } else if (role == 'faculty') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FacultyDashboard(username: username, role: role,)));
      } else if (role == 'student') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StudentDashboard()));
      } else {
        setState(() {
          _errorMessage = "Unknown role: $role";
        });
      }
    } else {
      setState(() {
        _errorMessage = data['message'] ?? 'Login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Text(_errorMessage, style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
