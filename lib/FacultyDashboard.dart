import 'package:app/AssignAssignmentPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AddUserPage.dart';
import 'RemoveUserPage.dart';
import 'ViewStudentsPage.dart';
import 'ManageTimetablePage.dart';
import 'PostNoticePage.dart';
import 'AssignAssignmentPage.dart';
import 'ManageEventsPage.dart';

class FacultyDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {"label": "Add Users", "icon": Icons.person_add_alt},
    {"label": "Remove Users", "icon": Icons.person_remove},
    {"label": "View Students", "icon": Icons.people_alt},
    {"label": "Manage Class Timetable", "icon": Icons.schedule},
    {"label": "Post Notices", "icon": Icons.announcement},
    {"label": "Assign Assignments", "icon": Icons.assignment_turned_in},
    {"label": "Manage Events\n& Calendar", "icon": Icons.event},
    {"label": "Upload Study Materials", "icon": Icons.upload_file},
    {"label": "Leave Applications", "icon": Icons.assignment_late},
    {"label": "Lost & Found", "icon": Icons.find_in_page},
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
          colors: [Color(0xFF00B09B), Color(0xFF96C93D)],
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
              "Welcome, Faculty!",
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
                            label: item['label'],
                            icon: item['icon'],
                            context: context,
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

  Widget _buildOptionCard({
    required String label,
    required IconData icon,
    required BuildContext context,
  }) {
    return Container(
      width: 160,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (label == "Add Users") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddUserPage(role: "student")),
            );
          } else if (label == "Remove Users") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RemoveUserPage(role: "student"),
              ),
            );
          } else if (label == "View Students") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewStudentsPage()),
            );
          } else if (label == "Manage Class Timetable") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManageTimetablePage()),
            );
          } else if (label == "Post Notices") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PostNoticePage()),
            );
          } else if (label == "Assign Assignments") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AssignAssignmentPage()),
            );
          } else if (label == "Manage Events\n& Calendar") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManageEventsPage()),
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
        selectedItemColor: Colors.green,
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
