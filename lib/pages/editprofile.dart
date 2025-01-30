import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pab_pbl/Login/Signup/login.dart';
import 'dart:convert';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  String? firstName = "";
  String? lastName = "";
  String? email = "";
  String? emailUser = "";
  final _storage = const FlutterSecureStorage();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isVisible = true;
      });
    });
    _getEmailFromStorage();
  }

  Future<void> _getEmailFromStorage() async {
    try {
      String? storedEmail = await _storage.read(key: 'email');
      if (storedEmail != null) {
        setState(() {
          email = storedEmail;
        });
        await _fetchUserData(storedEmail);
      }
    } catch (e) {
      print('Error fetching email from storage: $e');
    }
  }

  Future<void> _fetchUserData(String email) async {
    String uri = "http://192.168.63.254/rawr/ambilnama.php";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        "email": email,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          firstName = data['first_name'] ?? "";
          lastName = data['last_name'] ?? "";
          emailUser = data['email'] ?? "";
        });
        _firstNameController.text = firstName!;
        _lastNameController.text = lastName!;
        _emailController.text = emailUser!;
      } else {
        print('Failed to fetch user data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateData(String? firstName, String? lastName, String? email_,
      String? password) async {
    String uri = "http://192.168.63.254/rawr/update.php";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
        "email_baru": email_,
        "pass": password
      });
      if (response.statusCode == 200) {
        print('Profile updated successfully');
        print(email);
        print(email_);
      } else {
        print('Failed to update profile. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  Future<void> _logOut() async {
    await _storage.delete(key: 'email');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Login()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "$emailUser",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Logika untuk mengganti foto profil
                    // Bisa menggunakan ImagePicker untuk memilih gambar dari galeri atau kamera
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        transform: isVisible
                            ? Matrix4.translationValues(0, 0, 0)
                            : Matrix4.translationValues(0, 1000, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Change Profile Picture",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              transform: isVisible
                  ? Matrix4.translationValues(0, 210, 0)
                  : Matrix4.translationValues(0, 800, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Center(
                        child: Text("Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        cursorColor: Colors.blue,
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: const TextStyle(color: Colors.grey),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.blue),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        cursorColor: Colors.blue,
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: const TextStyle(color: Colors.grey),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.blue),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        cursorColor: Colors.blue,
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.grey),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.blue),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) =>
                            value == null || !value.contains('@')
                                ? 'Invalid Email'
                                : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        cursorColor: Colors.blue,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.grey),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.blue),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                          ),
                          prefixIcon: const Icon(Icons.key),
                        ),
                        validator: (value) => value == null || value.length < 4
                            ? 'Min 4 chars'
                            : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _updateData(
                              _firstNameController.text,
                              _lastNameController.text,
                              _emailController.text,
                              _passwordController.text,
                            );
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Profile Updated"),
                                content: const Text("You will be logged out."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _logOut();  
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 38, 194, 255),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
