// ViewNoticesPage.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class ViewNoticesPage extends StatefulWidget {
  @override
  _ViewNoticesPageState createState() => _ViewNoticesPageState();
}

class _ViewNoticesPageState extends State<ViewNoticesPage> {
  List<dynamic> notices = [];

  Future<void> fetchNotices() async {
    final url = Uri.parse('http://10.0.2.2:5000/get_notices');
    // final url = Uri.parse('$baseURL/get_notices');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        notices = data['notices'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Notices')),
      body: notices.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return ListTile(
                  title: Text(notice['title']),
                  subtitle: Text(notice['content']),
                );
              },
            ),
    );
  }
}
