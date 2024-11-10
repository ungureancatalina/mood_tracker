import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mood_storage.dart';
import 'package:fl_chart/fl_chart.dart';

extension StringCapitalization on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  bool isWeeklyPressed = true;
  Color weeklyButtonColor = Color(0xFF006600);
  Color monthlyButtonColor = Color(0xFF003300);

  DateTime _selectedDay = DateTime.now();
  List<double> moodAverages = [0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> moodFlowData = [0.0,1.0,2.0,3.0,4.0,5.0];
  List<MapEntry<String, int>> emotionCounts = [];
  List<MapEntry<String, int>> personCounts = [];
  List<MapEntry<String, int>> weatherCounts = [];
  List<double> hoursSleptData = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0];
  List<double> exerciseTime =[0.0,15.0,30.0,45.0,60.0,75.0,90.0,105.0,120.0];

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final moodData = await _calculateMoodAverages();
    moodAverages = moodData['averages'];
    moodFlowData = moodData['dailyMoodCounts'];
    emotionCounts = moodData['emotionCounts'];
    hoursSleptData = moodData['hoursSlept'];
    exerciseTime =moodData['exerciseTime'];
    personCounts = moodData['personCounts'];
    weatherCounts = moodData['weatherCounts'];
    setState(() {});
  }

  Future<Map<String, dynamic>> _calculateMoodAverages() async {
    DateTime startDate, endDate;
    if (isWeeklyPressed) {
      startDate = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
      endDate = startDate.add(Duration(days: 6));
    } else {
      startDate = DateTime(_selectedDay.year, _selectedDay.month, 1);
      endDate = DateTime(_selectedDay.year, _selectedDay.month + 1, 0);
    }

    List<int> moodCounts = List<int>.filled(5, 0);
    int totalEntries = 0;

    Map<String, int> emotionCountMap = {
      'calm': 0,
      'happy': 0,
      'excited': 0,
      'cheerful': 0,
      'in_love': 0,
      'friendly': 0,
      'shocked': 0,
      'singing': 0,
      'speachless': 0,
      'confused': 0,
      'nervous': 0,
      'crying': 0,
      'stressed': 0,
      'lonely': 0,
      'sad': 0,
      'unbothered': 0,
      'anxious': 0,
      'annoyed': 0,
      'angry': 0,
      'sick': 0,
      'unfocussed': 0,
      'disoriented': 0,
      'sleepy': 0,
      'proud': 0,
    };

    Map<String, int> personCountsMap = {
      'p1': 0,
      'p2': 0,
      'p3': 0,
      'p4': 0,
    };

    Map<String, int> weatherCountsMap = {
      'w1': 0,
      'w2': 0,
      'w3': 0,
      'w4': 0,
    };

    List<double> hoursSlept = [];
    List<double> dailyMoodCounts = [];
    List<double> exerciseTime = [];

    for (DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      Map<String, dynamic> data = await DataStorage.loadData(formattedDate);

      if (data.isNotEmpty) {
        if (data['dayEmotion'] != null) {
          String dayEmotion = data['dayEmotion'];
          int moodIndex = int.tryParse(dayEmotion.replaceAll('em', '')) ?? 0;
          if (moodIndex > 0 && moodIndex <= 5) {
            moodCounts[moodIndex - 1]++;
            totalEntries++;
          }
        }

        if (data['dayEmotion'] != null) {
          String dayEmotion = data['dayEmotion'];
          int moodIndex = 6-int.parse(dayEmotion.substring(2));
          dailyMoodCounts.add(moodIndex.toDouble());
        } else {
          dailyMoodCounts.add(0.0);
        }

        if (data['emotions'] is List) {
          for (String emotion in data['emotions']) {
            if (emotionCountMap.containsKey(emotion)) {
              emotionCountMap[emotion] = (emotionCountMap[emotion] ?? 0) + 1;
            }
          }
        }

        if (data['person'] is String) {
          String person = data['person'];
          if (personCountsMap.containsKey(person)) {
            personCountsMap[person] = (personCountsMap[person] ?? 0) + 1;
          }
        }

        if (data['weather'] is String) {
          String weather = data['weather'];
          if (weatherCountsMap.containsKey(weather)) {
            weatherCountsMap[weather] = (weatherCountsMap[weather] ?? 0) + 1;
          }
        }

        if (data['hoursSlept'] != null) {
          hoursSlept.add(data['hoursSlept'].toDouble());
        } else {
          hoursSlept.add(0.0);
        }
        if (data['exerciseTime'] != null) {
          exerciseTime.add(data['exerciseTime'].toDouble());
        } else {
          exerciseTime.add(0.0);
        }
      }else {
        hoursSlept.add(0.0);
        dailyMoodCounts.add(0.0);
        exerciseTime.add(0.0);
      }
    }

    List<double> averages = List.generate(5, (index) => totalEntries > 0 ? (moodCounts[index] * 100 / totalEntries) : 0.0);
    List<MapEntry<String, int>> emotionCounts = emotionCountMap.entries.where((entry) => entry.value > 0).toList();
    List<MapEntry<String, int>> personCounts = personCountsMap.entries.where((entry) => entry.value > 0).toList();
    List<MapEntry<String, int>> weatherCounts = weatherCountsMap.entries.where((entry) => entry.value > 0).toList();

    return {
      'averages': averages,
      'dailyMoodCounts': dailyMoodCounts,
      'emotionCounts': emotionCounts,
      'hoursSlept': hoursSlept,
      'exerciseTime': exerciseTime,
      'personCounts': personCounts,
      'weatherCounts': weatherCounts,
    };
  }

  @override
  Widget build(BuildContext context) {
    Color veryDarkGreen = Color(0xFF003300);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your report',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: veryDarkGreen,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imag2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildButtonRow(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    isWeeklyPressed
                        ? _getWeeklyReportText()
                        : _getMonthlyReportText(),
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              _buildMoodBarBox(),
              _buildMoodFlowBox(),
              _buildFrequentEmotionsBox(),
              _buildFrequentPersonsBox(),
              _buildFrequentWeatherBox(),
              _buildHoursSleptBox(),
              _buildExerciseTimeBox(),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeeklyReportText() {
    DateTime startOfWeek = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    return "${DateFormat('MMMM d').format(startOfWeek)} - ${DateFormat('d').format(endOfWeek)}";
  }

  String _getMonthlyReportText() {
    String monthName = DateFormat('MMMM').format(_selectedDay);
    return "$monthName";
  }

  Widget _buildButtonRow(BuildContext context) {
    Color veryDarkGreen = Color(0xFF003300);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isWeeklyPressed) {
                  _selectedDay = _selectedDay.subtract(Duration(days: 7));
                } else {
                  _selectedDay = DateTime(_selectedDay.year, _selectedDay.month - 1);
                }
              });
              _loadMoodData();
              print('Previous button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: veryDarkGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              '<',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isWeeklyPressed = true;
                weeklyButtonColor = Color(0xFF006600);
                monthlyButtonColor = Color(0xFF003300);
              });
              _loadMoodData();
              print('Weekly report button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: weeklyButtonColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              'Weekly',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isWeeklyPressed = false;
                monthlyButtonColor = Color(0xFF006600);
                weeklyButtonColor = Color(0xFF003300);
              });
              _loadMoodData();
              print('Monthly report button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: monthlyButtonColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              'Monthly',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isWeeklyPressed) {
                  _selectedDay = _selectedDay.add(Duration(days: 7));
                } else {
                  _selectedDay = DateTime(_selectedDay.year, _selectedDay.month + 1);
                }
              });
              _loadMoodData();
              print('Next button pressed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: veryDarkGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Text(
              '>',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBarBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Bar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          _buildMoodBar('assets/em1.jpg', moodAverages[0]),
          _buildMoodBar('assets/em2.jpg', moodAverages[1]),
          _buildMoodBar('assets/em3.jpg', moodAverages[2]),
          _buildMoodBar('assets/em4.jpg', moodAverages[3]),
          _buildMoodBar('assets/em5.jpg', moodAverages[4]),
        ],
      ),
    );
  }

  Widget _buildMoodBar(String imagePath, double percentage) {
    double circlePosition = percentage / 100;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          width: 30,
          height: 30,
        ),
        SizedBox(width: 10),
        Stack(
          children: [
            Container(
              width: 300,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                widthFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 300 * circlePosition - 7.5,
              top: -5,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodFlowBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Flow',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'The bottom axis is for days and the left axis is for wellness',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value >= 1 && value <= 5) {
                          Color moodColor;
                          switch (value.toInt()) {
                            case 1:
                              moodColor = Colors.grey;
                              break;
                            case 2:
                              moodColor = Colors.lightGreen;
                              break;
                            case 3:
                              moodColor = Colors.green;
                              break;
                            case 4:
                              moodColor = Color(0xFF00B200);
                              break;
                            case 5:
                              moodColor = Color(0xFF006400);
                              break;
                            default:
                              moodColor = Colors.transparent;
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: moodColor,
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text((value.toInt()+1).toString());
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                maxY: 5,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateMoodFlowSpots(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateMoodFlowSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < moodFlowData.length; i++) {
        spots.add(FlSpot(i.toDouble(), moodFlowData[i]));
    }
    return spots;
  }

  Widget _buildFrequentEmotionsBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequent Emotions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: emotionCounts.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    _buildImage(entry.key),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${entry.key.capitalize()} usages:  ${entry.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, String> personMapping = {
    'p1': 'Family',
    'p2': 'Friends',
    'p3': 'Partner',
    'p4': 'Alone',
  };

  Widget _buildFrequentPersonsBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequent Persons',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: personCounts.map((entry) {
              String personName = personMapping[entry.key] ?? entry.key;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    _buildImage(entry.key),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '$personName usages:  ${entry.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, String> weatherMapping = {
    'w1': 'Sunny',
    'w2': 'Cloudy',
    'w3': 'Rainy',
    'w4': 'Stormy',
  };

  Widget _buildFrequentWeatherBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequent Weather',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: weatherCounts.map((entry) {
              String weather = weatherMapping[entry.key] ?? entry.key;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    _buildImage(entry.key),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '$weather usages:  ${entry.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String im) {
    String imagePath = 'assets/$im.jpg';
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
    );
  }


  Widget _buildHoursSleptBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hours Slept',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'The bottom axis is for days and the left axis is for hours per day',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text((value.toInt()+1).toString());
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                maxY: 14,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateHoursSleptSpots(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateHoursSleptSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < hoursSleptData.length; i++) {
      spots.add(FlSpot(i.toDouble(), hoursSleptData[i]));
    }
    return spots;
  }

  Widget _buildExerciseTimeBox() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Doing Workouts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'The bottom axis is for days and the left axis is for minutes of workout per day',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text((value.toInt()+1).toString());
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                maxY: 120,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateExerciseTimeSpots(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateExerciseTimeSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < exerciseTime.length; i++) {
      spots.add(FlSpot(i.toDouble(), exerciseTime[i]));
    }
    return spots;
  }
}

