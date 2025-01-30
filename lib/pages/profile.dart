import 'package:flutter/material.dart';
import 'package:pab_pbl/Login/Signup/login.dart';
import 'package:pab_pbl/pages/editprofile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isVisible = false;
  String? firstName = "";
  String? lastName = "";
  String? email = "";
  String? emailUser = "";
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isVisible = true;
      });
    });
    getEmailFromStorage();
  }

  Future<String?> getEmailFromStorage() async {
    String? storedEmail = await storage.read(key: 'email');
    setState(() {
      email = storedEmail;
    });

    if (email != null) {
      fetchUserData(email);
    }
  }

  Future<void> fetchUserData(String? email) async {
    if (email == null) return;

    String uri = "http://192.168.63.254/rawr/ambilnama.php";

    try {
      var response = await http.post(Uri.parse(uri), body: {
        "email": email,
      });

      print('Response body: ${response.body}');

      if (response.body.contains('<html>')) {
        print('Error: HTML response received, check server');
        return;
      }

      var data = jsonDecode(response.body);
      setState(() {
        firstName = data['first_name'];
        lastName = data['last_name'];
        emailUser = data['email'];
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> logOut() async {
    // Clear the email from secure storage
    await storage.delete(key: 'email');

    // Navigate the user back to the login screen (or any page you prefer)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => Login()), // Replace with your LoginPage widget
      (route) =>
          false, // Remove all previous routes to prevent going back to the profile page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 194, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(255, 38, 194, 255)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile_picture.png'),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "$firstName $lastName",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "$emailUser",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Menu dengan Animasi
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              transform: isVisible
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, 800, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.person,
                    title: "Edit Profile",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => EditProfile()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SettingsPage()));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.lock,
                    title: "Privacy Policy",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: "Log Out",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Log Out"),
                            content:
                                const Text("Are you sure you want to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  logOut();
                                },
                                child: const Text("Log Out"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 38, 194, 255),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(255, 38, 194, 255),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(66, 0, 187, 255),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Center(
        child: Text("Settings Page"),
      ),
    );
  }
}
