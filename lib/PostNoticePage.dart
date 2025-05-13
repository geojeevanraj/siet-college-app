// PostNoticePage.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostNoticePage extends StatefulWidget {
  @override
  _PostNoticePageState createState() => _PostNoticePageState();
}

class _PostNoticePageState extends State<PostNoticePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _postNotice() async {
    final url = Uri.parse('http://10.0.2.2:5000/post_notice');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _titleController.text,
        'content': _contentController.text,
      }),
    );

    final data = jsonDecode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data['message'])),
    );

    if (response.statusCode == 201) {
      _titleController.clear();
      _contentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Notice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Title is required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Content is required' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _postNotice();
                  }
                },
                child: Text('Post Notice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
