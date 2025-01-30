// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditMed extends StatelessWidget {
  late final String data0, data1, data2, data3, data4;
  EditMed(
      {required this.data0,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4});

  final formKey = GlobalKey<FormState>(); // Global key for form validation
  String? _medID = "";
  String? _medName = "";
  String? _note = "";
  String? _time = "";
  String? _urgency = "";
  String? _email = "";

  final storage = FlutterSecureStorage();

  Future<String?> getEmailFromStorage() async {
    String? storedEmail = await storage.read(key: 'email');
    _email = storedEmail ?? "";
    updateMedData(_medID, _medName, _note, _time, _urgency, _email);
    return _email;
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerMedID =
        TextEditingController(text: data0);
    final TextEditingController controllerMedName =
        TextEditingController(text: data1);
    final TextEditingController controllerNote =
        TextEditingController(text: data2);
    final TextEditingController controllerTime =
        TextEditingController(text: data3);
    final TextEditingController controllerUrgency =
        TextEditingController(text: data4);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit Medication",
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
      backgroundColor: const Color.fromARGB(255, 38, 194, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: formKey,
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
                    controller: controllerMedID,
                    enabled: false,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 225, 225, 225)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      _medID = value!;
                      if (value.isEmpty) {
                        return 'Medicine name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                    controller: controllerMedName,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      _medName = value!;
                      if (value.isEmpty) {
                        return 'Medicine name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "When To Take",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controllerTime,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      _time = value!;
                      if (value.isEmpty) {
                        return 'Medicine name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Urgency",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controllerUrgency,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (String? value) {
                      _urgency = value!;
                      if (value.isEmpty) {
                        return 'Medicine name cannot be empty';
                      }
                      return null;
                    },
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
                    controller: controllerNote,
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
                      _note = value;
                      if (value == null || value.isEmpty) {
                        return "Medication name cannot be empty!";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
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
          ],
        ),
      ),
    );
  }

  void updateMedData(String? medID, String? medName, String? note, String? time,
      String? urgency, String? email) async {
    String uri = "http://192.168.63.254/rawr/updatemeds.php";
    await http.post(Uri.parse(uri), body: {
      "medID": medID,
      "medName": medName,
      "note": note,
      "time": time,
      "urgency": urgency,
      "email": email,
    });
  }
}
