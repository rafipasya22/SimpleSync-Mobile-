import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TempPage extends StatefulWidget {
  const TempPage({super.key});

  @override
  _TempPageState createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  bool isVisible = false;
  String? temp = "";

  Future<void> fetchTempData() async {
    String uri = "http://192.168.63.254/rawr/getHeartRate.php";

    try {
      var response = await http.get(Uri.parse(uri));
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          temp = data['temperature'];
          print('Heart Rate: $temp BPM');
        });
      } else {
        print('Error: Unable to fetch heart rate data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Animasi muncul ketika halaman dibuka
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        isVisible = true;
      });
    });
    fetchTempData();
  }

  @override
  Widget build(BuildContext context) {
    double parsedtemp = (temp != null && double.tryParse(temp!) != null)
        ? double.parse(temp!)
        : 0.0;
    double tempfinal = parsedtemp / 100;
    double kelvin = parsedtemp + 273;
    double fahrenheit = (9 / 5 * parsedtemp) + 32;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 194, 255),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 10)),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: tempfinal),
                duration: const Duration(milliseconds: 1200),
                builder: (context, value, child) {
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 10,
                      color: Colors.blue,
                      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                    ),
                  );
                },
              ),
              Column(
                children: [
                  const Icon(
                    Icons.thermostat,
                    color: Colors.blueAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$temp",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "°C",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Please Make Sure The Bracelet Positioned Correctly",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          // Animated Container untuk bagian bawah
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            transform: isVisible
                ? Matrix4.translationValues(0, 200, 0)
                : Matrix4.translationValues(0, 700, 0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Your Temp Data",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Latest",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 219, 219, 219),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTempCard("Temperature in Celcius", "$temp °C"),
                      const SizedBox(height: 10),
                      _buildTempCard("Temperature in Kelvin", "$kelvin °K"),
                      const SizedBox(height: 10),
                      _buildTempCard(
                          "Temperature in Fahrenheit", "$fahrenheit °F"),
                    ],
                  ),
                ),
                const SizedBox(height: 270),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempCard(String label, String value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.lightBlue,
            offset: Offset(3, 0),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color.fromARGB(255, 220, 240, 255),
                child: Icon(Icons.thermostat, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
