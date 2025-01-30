// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pab_pbl/Login/Signup/login.dart';

import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final kunciform = GlobalKey<FormState>();
  double _containerOffset = 400.0;
  final double _upperLimit = 0.0;
  final double _lowerLimit = 400.0;

  String? _FirstName = "";
  String? _LastName = "";
  String? _Email = "";
  String? _Pass = "";

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: const Text(
                          "Register to Enjoy All Of Our Latest Features",
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
                    child: Form(
                      key: kunciform, // Connect the form to the form state
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
                            child: Column(
                              children: <Widget>[
                                // First Name
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      hintText: "First Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      _FirstName = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                // Last Name
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
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                      hintText: "Last Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      _LastName = value;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                // Email
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
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validator: (String? value) {
                                        _Email = value;
                                        if (value == null || value.isEmpty) {
                                          return "Kosong mas";
                                        } else if (!value.contains("@")) {
                                          return "Ga valid atuh kang gitu mah";
                                        } else {
                                          return null;
                                        }
                                      } // Email validation
                                      ),
                                ),
                                // Password
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
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validator: (String? value) {
                                        _Pass = value;
                                        if (value == null || value.isEmpty) {
                                          return "Kosong mas";
                                        } else if (value.length < 4) {
                                          return "Sing panjang atuh password na ujang";
                                        } else {
                                          return null;
                                        }
                                      } // Password validation
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: () {
                                if (kunciform.currentState!.validate()) {
                                  kunciform.currentState?.save();

                                  insertData(
                                      _FirstName, _LastName, _Email, _Pass);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                }
                              },
                              height: 50,
                              color: const Color.fromARGB(255, 38, 194, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 212),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: const Text(
                              "Already Have an Account?",
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
                                    builder: (context) => const Login(),
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
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: const Text(
                              "Continue with social media",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 30),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void insertData(String? a, String? b, String? c, String? d) {
  String uri = "http://192.168.63.254/rawr/insert.php";
  http.post(Uri.parse(uri), body: {
    "itemnamadepan": a,
    "itemnamabelakang": b,
    "itememail": c,
    "itempass": d,
  });
}
