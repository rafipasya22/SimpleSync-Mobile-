import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pab_pbl/Login/Signup/Signup.dart';
import 'package:pab_pbl/nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final kunciform = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  double _containerOffset = 525.0;
  final double _upperLimit = 0.0;
  final double _lowerLimit = 525.0;
  String? _Email = "";
  String? _Pass = "";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> saveEmailToSession(String? email) async {
  await storage.write(key: 'email', value: email);
  print("emal disimpan");
}
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  const Color.fromARGB(255, 7, 222, 230),
                  Colors.blue.shade800,
                  const Color.fromARGB(255, 38, 194, 255)
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20.0, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Welcome",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: const Text(
                          "Ready to Pick Up Where We Left Off?",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Transform.translate(
                  offset: Offset(0, _containerOffset),
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 60),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onVerticalDragUpdate: (details) {
                            setState(() {
                              _containerOffset += details.primaryDelta!;
                              if (_containerOffset < _upperLimit) {
                                _containerOffset = _upperLimit;
                              } else if (_containerOffset > _lowerLimit) {
                                _containerOffset = _lowerLimit;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              height: 30,
                              width: 200,
                              color: Colors.transparent,
                              child: Center(
                                child: Container(
                                  height: 5,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Form(
                            key: kunciform,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validator: (String? value) {
                                        _Email = value;
                                        if (value == null || value.isEmpty) {
                                          return "Can't be Empty";
                                        } else if (!value.contains("@")) {
                                          return "Email Invalid";
                                        } else {
                                          return null;
                                        }
                                      }),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validator: (String? value) {
                                        _Pass = value;
                                        if (value == null || value.isEmpty) {
                                          return "Can't be Empty";
                                        } else {
                                          return null;
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () async {
                              if (kunciform.currentState!.validate()) {
                                kunciform.currentState?.save();
                                print("Email: $_Email, Password: $_Pass");
                                bool loginSuccess =
                                    await insertData(_Email, _Pass);

                                if (loginSuccess) {
                                  await saveEmailToSession(_Email!);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const nav(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Login Failed")),
                                  );
                                }
                              }
                            },
                            height: 50,
                            color: const Color.fromARGB(255, 38, 194, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 329),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child: const Text(
                            "Don't Have an Account?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                ),
                              );
                            },
                            height: 50,
                            color: const Color.fromARGB(255, 38, 194, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child: const Text(
                            "Continue with social media",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1800),
                                child: MaterialButton(
                                  onPressed: () {},
                                  height: 50,
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Facebook",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1900),
                                child: MaterialButton(
                                  onPressed: () {},
                                  height: 50,
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Github",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> insertData(String? email, String? password) async {
  String uri = "http://192.168.63.254/rawr/login.php";
  try {
    final response = await http.post(Uri.parse(uri), body: {
      "email": email,
      "pass": password,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['success'] == true) {
        
        return true; // Login sukses
      } else {
        return false; // Login gagal
      }
    } else {
      return false; // Server error
    }
  } catch (e) {
    print("Error: $e");
    return false; // Kesalahan koneksi atau lainnya
  }
}
