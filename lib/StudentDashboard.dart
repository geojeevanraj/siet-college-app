import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ViewTimetablePage.dart';
import 'ViewNoticesPage.dart';
import 'ViewAssignmentsPage.dart';
import 'ViewEventsPage.dart';

class StudentDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {"label": "Timetable", "icon": Icons.schedule},
    {"label": "Notices/\nAnnouncements", "icon": Icons.announcement},
    {"label": "Assignment List", "icon": Icons.assignment},
    {"label": "Events/Calendar", "icon": Icons.event},
    {"label": "Student Materials", "icon": Icons.menu_book},
    {"label": "Lost & Found Section", "icon": Icons.find_in_page},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Stack(children: [_buildBackground(), _buildContent(context)]),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Text(
              "Welcome, Student!",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children:
                        options.map((item) {
                          return _buildOptionCard(
                            item['label'],
                            item['icon'],
                            context,
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String label, IconData icon, BuildContext context) {
    return Container(
      width: 160,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (label == "Timetable") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewTimetablePage()),
            );
          } else if (label == "Notices/\nAnnouncements") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewNoticesPage()),
            );
          } else if (label == "Assignment List"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewAssignmentsPage()),
            );
          } else if (label == "Events/Calendar") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewEventsPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$label functionality coming soon")),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
