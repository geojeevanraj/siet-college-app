import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'AddUserPage.dart';
import 'RemoveUserPage.dart';
import 'ViewStudentsPage.dart';
import 'ManageTimetablePage.dart';
import 'PostNoticePage.dart';
import 'AssignAssignmentPage.dart';
import 'ManageEventsPage.dart';
import 'LoginScreen.dart';

class FacultyDashboard extends StatefulWidget {
  final String username;
  final String role; // uncommented

  const FacultyDashboard({
    Key? key,
    required this.username,
    required this.role, // add required here too
  }) : super(key: key);

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  int _selectedIndex = 0;

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
      body: Stack(children: [_buildBackground(), _buildBody()]),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return _buildDashboardGrid();
    } else {
      return _buildProfile();
    }
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

  Widget _buildDashboardGrid() {
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
                    children: options.map((item) {
                      return _buildOptionCard(
                        label: item['label'],
                        icon: item['icon'],
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
  }) {
    return Container(
      width: 160,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          const BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (label == "Add Users") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddUserPage(role: "student")));
          } else if (label == "Remove Users") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => RemoveUserPage(role: "student")));
          } else if (label == "View Students") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ViewStudentsPage()));
          } else if (label == "Manage Class Timetable") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ManageTimetablePage()));
          } else if (label == "Post Notices") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => PostNoticePage()));
          } else if (label == "Assign Assignments") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AssignAssignmentPage()));
          } else if (label == "Manage Events\n& Calendar") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ManageEventsPage()));
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
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.white70),
            const SizedBox(height: 20),
            Text(
              "${widget.role} Profile",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Name: ${widget.username}",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
            ),
            Text(
              "Role: ${widget.role}",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _showChangePasswordDialog(),
              child: const Text("Change Password"),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showChangePasswordDialog() async {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    String errorMessage = '';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Change Password'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(labelText: 'Current Password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(labelText: 'Confirm New Password'),
                      obscureText: true,
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final current = _currentPasswordController.text.trim();
                    final newPass = _newPasswordController.text.trim();
                    final confirm = _confirmPasswordController.text.trim();

                    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                      setStateDialog(() {
                        errorMessage = 'Please fill all fields';
                      });
                      return;
                    }

                    if (newPass != confirm) {
                      setStateDialog(() {
                        errorMessage = 'New passwords do not match';
                      });
                      return;
                    }

                    final url = Uri.parse("http://10.0.2.2:5000/change_password");
                    final response = await http.post(
                      url,
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({
                        "username": widget.username,
                        "current_password": current,
                        "new_password": newPass,
                      }),
                    );

                    final data = jsonDecode(response.body);

                    if (data['success']) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password changed successfully')),
                      );
                    } else {
                      setStateDialog(() {
                        errorMessage = data['message'] ?? 'Failed to change password';
                      });
                    }
                  },
                  child: const Text('Change'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
