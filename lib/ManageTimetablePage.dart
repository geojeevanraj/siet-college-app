import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class ManageTimetablePage extends StatefulWidget {
  @override
  _ManageTimetablePageState createState() => _ManageTimetablePageState();
}

class _ManageTimetablePageState extends State<ManageTimetablePage> {
  final TextEditingController _dayController = TextEditingController();
  List<Map<String, String>> _classes = [];
  String _time = '', _subject = '', _room = '';

  void _addClassEntry() {
    if (_time.isNotEmpty && _subject.isNotEmpty && _room.isNotEmpty) {
      setState(() {
        _classes.add({"time": _time, "subject": _subject, "room": _room});
        _time = _subject = _room = '';
      });
    }
  }

  Future<void> _updateTimetable() async {
    final url = Uri.parse('http://10.0.2.2:5000/update_timetable');
    // final url = Uri.parse('$baseURL/update_timetable');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"day": _dayController.text, "classes": _classes}),
    );
    final result = json.decode(response.body);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result['message'])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Timetable")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _dayController,
              decoration: InputDecoration(labelText: "Day (e.g. Monday)"),
            ),
            TextField(
              onChanged: (v) => _time = v,
              decoration: InputDecoration(labelText: "Time"),
            ),
            TextField(
              onChanged: (v) => _subject = v,
              decoration: InputDecoration(labelText: "Subject"),
            ),
            TextField(
              onChanged: (v) => _room = v,
              decoration: InputDecoration(labelText: "Room"),
            ),
            ElevatedButton(onPressed: _addClassEntry, child: Text("Add Class")),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateTimetable,
              child: Text("Update Timetable"),
            ),
          ],
        ),
      ),
    );
  }
}
