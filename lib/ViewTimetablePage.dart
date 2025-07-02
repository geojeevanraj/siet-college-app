import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class ViewTimetablePage extends StatefulWidget {
  @override
  _ViewTimetablePageState createState() => _ViewTimetablePageState();
}

class _ViewTimetablePageState extends State<ViewTimetablePage> {
  List timetable = [];

  Future<void> fetchTimetable() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_timetable'));
    // final response = await http.get(Uri.parse('$baseURL/get_timetable'));
    final result = json.decode(response.body);
    if (result['success']) {
      setState(() {
        timetable = result['timetable'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTimetable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Timetable")),
      body: ListView.builder(
        itemCount: timetable.length,
        itemBuilder: (context, index) {
          final day = timetable[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text(day['day']),
              children: (day['classes'] as List).map((cls) {
                return ListTile(
                  title: Text("${cls['time']} - ${cls['subject']}"),
                  subtitle: Text("Room: ${cls['room']}"),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
