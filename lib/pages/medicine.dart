import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:pab_pbl/pages/meds.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final kunciform = GlobalKey<FormState>();
  TimeOfDay? selectedTime;
  String? selectedTimePeriod;
  String? namamed = "";
  String? note = "";
  String? email = "";
  final TextEditingController medsname = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final storage = FlutterSecureStorage();

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _selectTimePeriod(String period) {
    setState(() {
      selectedTimePeriod = period;
    });
  }

  void Alert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text("Medication Added Sucessfully!"),
          content: const Text("You Will Now be Redirected to Medication Page"),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> getEmailFromStorage() async {
    String? storedEmail = await storage.read(key: 'email');
    setState(() {
      email = storedEmail;
    });

    if (email != null) {
      String waktuFormat = selectedTime != null
          ? selectedTime!.format(context)
          : "No time selected";
      insertData(namamed, note, waktuFormat, selectedTimePeriod, email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Add Medication",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      backgroundColor:
          const Color.fromARGB(255, 38, 194, 255), // Warna latar belakang
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Form dibungkus dengan widget Form
          key: kunciform,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              const Text(
                "Medicine name",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: medsname,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter medicine name",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (String? value) {
                  namamed = value;
                  if (value == null || value.isEmpty) {
                    return "Kosong mas";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "When to take?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : "Select time",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const Icon(Icons.access_time, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "How Important Is It?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _timeButton("Not Urgent", Icons.check_circle,
                      selectedTimePeriod == "Not Urgent", () {
                    _selectTimePeriod("Not Urgent");
                  }),
                  SizedBox(width: 50),
                  _timeButton(
                      "Urgent", Icons.warning, selectedTimePeriod == "Urgent",
                      () {
                    _selectTimePeriod("Urgent");
                  }),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Additional notes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 3,
                controller: notes,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Additional notes...",
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (String? value) {
                  note = value;
                  if (value == null || value.isEmpty) {
                    return "Medication name cannot be empty!";
                  } else {
                    return null;
                  }
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  if (kunciform.currentState!.validate()) {
                    kunciform.currentState?.save();
                    getEmailFromStorage();
                    Alert(context);
                  }
                },
                icon: const Icon(Icons.notifications, color: Colors.white),
                label: const Text(
                  "Set Reminder",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeButton(
      String label, IconData icon, bool isSelected, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.blue),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> insertData(
      String? a, String? b, String? c, String? d, String? e) async {
    if (email == null) return;

    String uri = "http://192.168.63.254/rawr/insertmeds.php";

    try {
      var response = await http.post(Uri.parse(uri), body: {
        "itemnama": a,
        "itemcatatan": b,
        "itemwaktu": c,
        "itemurgent": d,
        "itememail": e,
      });
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }
}
