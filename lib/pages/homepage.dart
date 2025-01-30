import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pab_pbl/pages/temp.dart';
import 'package:pab_pbl/util/emot.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pab_pbl/pages/heartrate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpandedBloodPressure = false;
  bool isExpandedBodyTemperature = false;
  bool isVisible = false;
  bool isEmotVisible = false;
  bool isContentVisible = true;
  String? firstName = "";
  String? email = "";
  String? heartrate = "";
  String? temp = "";
  String? jatuh;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isVisible = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isEmotVisible = true;
      });
    });
    getEmailFromStorage();
    fetchHeartRateData();
  }

  Future<void> fetchHeartRateData() async {
    String uri =
        "http://192.168.63.254/rawr/getHeartRate.php"; // Ganti dengan URL endpoint yang benar untuk mengambil data BPM

    try {
      var response = await http.get(Uri.parse(uri));

      // Log response body untuk memeriksa format
      print('Response body: ${response.body}');

      // Cek jika response berbentuk JSON
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          // Misalnya, jika data BPM ada di dalam field 'bpm'
          heartrate = data['heart_rate'];
          temp = data['temperature'];
          jatuh = data['jatuh'];
          print('Heart Rate: $heartrate BPM');
        });
      } else {
        print('Error: Unable to fetch heart rate data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fetch first name from the PHP session
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

      // Log the raw response to check the format
      print('Response body: ${response.body}');

      // Check if the response is HTML (not JSON)
      if (response.body.contains('<html>')) {
        print('Error: HTML response received, check server');
        return;
      }

      // Try to parse the response as JSON
      var data = jsonDecode(response.body);
      setState(() {
        firstName = data['first_name']; // Assign firstName from the response
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text("No More Questions"),
          content: const Text("We won't ask you how you feel anymore."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isContentVisible = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _EmotePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text("Blood Pressure Details"),
          content:
              const Text("Here are more details about your blood pressure."),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _NotiPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              transform: isVisible
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, 500, 0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notifications",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //listview

                    Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Color.fromARGB(255, 220, 240, 255),
                                    child: Icon(LineIcons.pills,
                                        color: Colors.red, size: 24),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Don't Forget to take your medicine",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "In 2 hours you should drink you amphetamine!",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 194, 255),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                //greetings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  "https://via.placeholder.com/150"), // Ganti dengan foto asli
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  email != null
                                      ? 'Hello, $firstName'
                                      : 'Hello, Guest',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Welcome Back!",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 34, 162, 221),
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(1),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _NotiPopup(context);
                          },
                        ))
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 600),
                  crossFadeState: isContentVisible
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: isContentVisible ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'How Do You Feel Today?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                              ),
                              onSelected: (value) {
                                if (value == "dont_ask") {
                                  _showPopup(context);
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  value: "dont_ask",
                                  child: Text("I don't wanna be asked"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        //mood
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeInOut,
                          transform: isEmotVisible
                              ? Matrix4.translationValues(0, 0, 0)
                              : Matrix4.translationValues(-500, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //ga bagus
                              Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        fetchUserData(email);
                                      },
                                      child: const Emot(
                                        emoticonface: "😔",
                                      )),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Bad",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              //fine
                              Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        _EmotePopup(context);
                                      },
                                      child: const Emot(
                                        emoticonface: "🙂",
                                      )),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Fine",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              //well
                              Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        _EmotePopup(context);
                                      },
                                      child: const Emot(
                                        emoticonface: "😃",
                                      )),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Well",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              //exelento
                              Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        _EmotePopup(context);
                                      },
                                      child: const Emot(
                                        emoticonface: "😎",
                                      )),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Excellent",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              transform: isVisible
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, 500, 0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                  )),
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Vital Signs",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //listview

                    Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: (heartrate != null &&
                                    double.tryParse(heartrate!) != null &&
                                    double.parse(heartrate!) < 70)
                                ? Colors
                                    .red // If heart rate is below 70, make the color red
                                : const Color.fromARGB(
                                    255, 38, 194, 255), // Default color
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
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
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Color.fromARGB(255, 220, 240, 255),
                                    child: Icon(Icons.monitor_heart,
                                        color: Colors.red, size: 24),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Heart Rate",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        "$heartrate BPM", // Display heart rate
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isExpandedBloodPressure =
                                        !isExpandedBloodPressure;
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HeartRatePage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: (temp != null &&
                                    double.tryParse(temp!) != null &&
                                    double.parse(temp!) > 38)
                                ? const Color.fromARGB(255, 255, 111, 0)
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
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
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Color.fromARGB(255, 220, 240, 255),
                                    child: Icon(Icons.device_thermostat,
                                        color: Colors.blue, size: 24),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Body Temperature",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        "$temp °C",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isExpandedBodyTemperature =
                                        !isExpandedBodyTemperature;
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TempPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: jatuh == "1"
                                ? Colors.red // Warna merah jika jatuh = "1"
                                : const Color.fromARGB(255, 38, 194,
                                    255), // Warna default jika tidak
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
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
                                    backgroundColor:
                                        Color.fromARGB(255, 220, 240, 255),
                                    child: Icon(Icons.safety_check,
                                        color: Colors.blue, size: 24),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Fall Detection",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        jatuh == "1"
                                            ? "Jatuh Terdeteksi"
                                            : "Belum Jatuh",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Medication",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //listview

                    Column(
                      children: [
                        AnimatedContainer(
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
                              ]),
                          padding: const EdgeInsets.all(20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Color.fromARGB(255, 220, 240, 255),
                                    child: Icon(LineIcons.pills,
                                        color: Colors.green, size: 30),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Amphetamine",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        "In 2 Hours",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
