import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:line_icons/line_icons.dart';
import 'package:pab_pbl/nav.dart';
import 'package:pab_pbl/pages/editmeds.dart';
import 'package:pab_pbl/pages/medicine.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Meds extends StatefulWidget {
  const Meds({super.key});

  @override
  State<Meds> createState() => _MedsState();
}

class _MedsState extends State<Meds> {
  TimeOfDay? selectedTime;
  String? selectedTimePeriod;
  bool isVisible = false;
  String? email = "";
  String? namaobat = "";
  String? id = "";
  String? diff = "";
  String? waktu = "";
  String? closestmeds = "";
  String? closestdiff = "";

  List dataku = [];
  final storage = FlutterSecureStorage();

  Future<String?> getEmailFromStorage() async {
    String? storedEmail = await storage.read(key: 'email');
    setState(() {
      email = storedEmail;
    });

    if (email != null) {
      bacadata(email);
      terdekat(email);
    }
  }

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

  Future<void> bacadata(String? email) async {
    if (email == null) return;

    String uri = "http://192.168.63.254/rawr/getmeds.php";

    try {
      var response = await http.post(Uri.parse(uri), body: {
        "email": email,
      });
      if (response.body.contains('<html>')) {
        print('Error: HTML response received, check server');
        return;
      }

      var data = jsonDecode(response.body);

      setState(() {
        dataku = data;
        print(dataku[0]["id"]);
        print(dataku[0]["nama_obat"]);
        print(dataku[0]["waktu"]);
        print(dataku[0]["time_difference"]);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> terdekat(String? email) async {
    if (email == null) return;

    String uri = "http://192.168.63.254/rawr/getclosestmeds.php";

    try {
      var response = await http.post(Uri.parse(uri), body: {
        "email": email,
      });
      if (response.body.contains('<html>')) {
        print('Error: HTML response received, check server');
        return;
      }

      var data = jsonDecode(response.body);

      setState(() {
        closestmeds = data["meds_name"];
        closestdiff = data["time_difference"];
        print(closestmeds);
        print(closestdiff);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _selectTimePeriod(String period) {
    setState(() {
      selectedTimePeriod = period;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isVisible = true;
      });
    });
    getEmailFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Medicine",
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
      backgroundColor: const Color.fromARGB(255, 38, 194, 255),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            height: 150, // Tinggi ditingkatkan
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Row untuk Icon Pill dan teks di bagian atas
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black26, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        LineIcons.pills,
                        size: 36,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Upcoming Meds",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          (closestmeds?.isEmpty ?? true)
                              ? "Medication not added yet"
                              : "Take $closestmeds in $closestdiff",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                    bottom: 0,
                    right: 8,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReminderPage()));
                      },
                      child: const Text(
                        "Add New Medicine",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              transform: isVisible
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, 1000, 0),
              margin: const EdgeInsets.only(top: 150),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Your Medication List",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Past 2 Hours",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataku.length,
                      itemBuilder: (context, index) {
                        diff = dataku[index]["time_difference"];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text('Ubah'),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EditMed(
                                                      data0: dataku[index]
                                                          ["id"],
                                                      data1: dataku[index]
                                                          ["nama_obat"],
                                                      data2: dataku[index]
                                                          ["catatan"],
                                                      data3: dataku[index]
                                                          ["waktu"],
                                                      data4: dataku[index]
                                                          ["urgent"])));
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Hapus'),
                                        onTap: () {
                                          deleteData(dataku[index]["id"]);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 38, 194, 255),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(3, 0),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: const Color.fromARGB(
                                          255, 220, 240, 255),
                                      child: const Icon(LineIcons.pills,
                                          color: Colors.blue, size: 30),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dataku[index]["nama_obat"] ??
                                              "No Data",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Take Medicine in $diff",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Icon(Icons.more_vert,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget button() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shadowColor: Colors.blueAccent,
          elevation: 10,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const nav(),
            ),
          );
        },
        child: const Text('pindah'), // TEXT YANG AKAN DITAMPILKAN PADA TOMBOL
      ),
    );
  }

  void deleteData(String a) async {
    //String uri = "http://10.0.2.2/apicrudflutter/insert.php";
    String uri = "http://192.168.63.254/rawr/delete.php";
    http.post(Uri.parse(uri), body: {
      "itemid": a,
    });
    bacadata(email);
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
