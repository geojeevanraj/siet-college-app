import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewEventsPage extends StatefulWidget {
  @override
  _ViewEventsPageState createState() => _ViewEventsPageState();
}

class _ViewEventsPageState extends State<ViewEventsPage> {
  List events = [];

  Future<void> _fetchEvents() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_events'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        events = data['events'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upcoming Events')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event['title']),
            subtitle: Text('${event['description']}\nDate: ${event['date']}'),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
