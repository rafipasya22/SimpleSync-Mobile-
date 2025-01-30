import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HeartRatePage extends StatefulWidget {
  const HeartRatePage({super.key});

  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  bool isVisible = false;
  String? heartrate = "";
  String? ox = "";
  String? maxheart = "";
  String? minheart = "";

  List dataavg = []; // Array of data (timestamp and heart rate)

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isVisible = true;
      });
    });
    fetchHeartRateData();
    fetchHeartRateAvg();
    fetchminmax();
  }

  Future<void> fetchHeartRateData() async {
    String uri = "http://192.168.63.254/rawr/getHeartRate.php";

    try {
      var response = await http.get(Uri.parse(uri));
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          heartrate = data['heart_rate'];
          ox = data['spo2'];
          print('Heart Rate: $heartrate BPM');
        });
      } else {
        print('Error: Unable to fetch heart rate data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchminmax() async {
    String uri = "http://192.168.63.254/rawr/getminmax.php";

    try {
      var response = await http.get(Uri.parse(uri));
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          maxheart = data['max_heart_rate'];
          minheart = data['min_heart_rate'];
          print(' Max Heart Rate: $maxheart BPM');
          print(' Min Heart Rate: $minheart BPM');
        });
      } else {
        print('Error: Unable to fetch heart rate data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchHeartRateAvg() async {
    String uri = "http://192.168.63.254/rawr/getavg.php";

    try {
      var response = await http.get(Uri.parse(uri));
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataavg = data;
          print(dataavg[0]["avg_heart_rate"]);
        });
      } else {
        print('Error: Unable to fetch heart rate data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double parsedHeartRate =
        (heartrate != null && double.tryParse(heartrate!) != null)
            ? double.parse(heartrate!)
            : 0.0;
    double normalizedHeartRate = parsedHeartRate / 200;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 194, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                tween: Tween<double>(begin: 0, end: normalizedHeartRate),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    heartrate ?? "Loading...",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "BPM",
                    style: TextStyle(
                      color: Color.fromARGB(179, 255, 255, 255),
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
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              transform: isVisible
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, 800, 0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          "Your Heartbeat Average",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Past 2 Hours",
                          style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 219, 219, 219),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white38,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (dataavg.isNotEmpty) {
                                  int index = value.toInt();
                                  if (index < dataavg.length) {
                                    return Text(dataavg[index]["time_interval"],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11));
                                  }
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.white38),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              dataavg.length,
                              (index) {
                                double avg = double.tryParse(dataavg[index]
                                            ["avg_heart_rate"]
                                        .toString()) ??
                                    0.0;
                                return FlSpot(index.toDouble(), avg);
                              },
                            ),
                            isCurved: false,
                            color: Colors.lightBlueAccent,
                            barWidth: 3,
                            belowBarData: BarAreaData(
                                show: false, color: Colors.lightBlueAccent),
                          ),
                        ],
                        minY: 0,
                        maxY: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: 450,
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
                              backgroundColor:
                                  Color.fromARGB(255, 220, 240, 255),
                              child: Icon(Icons.water_drop,
                                  color: Colors.red, size: 24),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Blood Oxidation Level",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  "$ox %",
                                  style: TextStyle(
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
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "MIN",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "$minheart BPM",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "MAX",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "$maxheart BPM",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
