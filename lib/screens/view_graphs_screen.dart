import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lifelog/models/daily_entry.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/gradient_background.dart';
import 'package:lifelog/widgets/mood_pie_chart.dart';
import 'package:lifelog/widgets/section_title.dart';
import 'package:lifelog/widgets/sleep_line_chart.dart';

class ViewGraphsScreen extends StatelessWidget {
  const ViewGraphsScreen({super.key});

  List<DailyEntry> generateSampleData() {
    final random = Random();
    return List.generate(30, (index) {
      final mood = 'mood_${random.nextInt(5)+1}';

      final sleepStartHour = 23 - random.nextInt(5);
      final sleepStartMinute = random.nextInt(60);
      final sleepEndHour = 6 + random.nextInt(5);
      final sleepEndMinute = random.nextInt(60);
      final sleepStartTime = TimeOfDay(hour: sleepStartHour, minute: sleepStartMinute);
      final sleepEndTime = TimeOfDay(hour: sleepEndHour, minute: sleepEndMinute);

      return DailyEntry(
        mood: mood, 
        sleepStartTime: sleepStartTime, 
        sleepEndTime: sleepEndTime, 
        gratefulFor: "Grateful sample $index", 
        highlights: "Highlights sample $index", 
        photoOfTheDayPath: "path/to/photo_$index.jpg"
      );
    });
  }

  List<double> calculateSleepData(List<DailyEntry> data, int numEntries) {
    return data.take(numEntries).map((entry) {
      final start = entry.sleepStartTime.hour + entry.sleepStartTime.minute / 60;
      final end = entry.sleepEndTime.hour + entry.sleepEndTime.minute / 60;
      return end >= start ? end - start : 24- start + end;
    }).toList();
  }

  double calculateAverageSleep(List<double> sleepData) {
    return sleepData.isEmpty ? 0.0 : sleepData.reduce((a, b) => a+b) / sleepData.length;
  }

  double calculateMaxSleep(List<double> sleepData) {
    return sleepData.isEmpty ? 0.0 : sleepData.reduce(max);
  }

  double calculateMinSleep(List<double> sleepData) {
    return sleepData.isEmpty ? 0.0 : sleepData.reduce(min);
  }

  String formatSleepDuration(double hours) {
    final int hourPart = hours.floor();
    final int minutePart = ((hours - hourPart) * 60).round();
    return '${hourPart}h ${minutePart}min';
  }

  Map<String, int> calculateMoodData(List<DailyEntry> data, int numEntries) {
    List<DailyEntry> entries = data.take(numEntries).toList();
    const moodMap = {'mood_1': 'angry', 'mood_2': 'sad', 'mood_3': 'neutral', 'mood_4': 'happy', 'mood_5': 'super'};
    final moodFrequency = {'angry': 0, 'sad': 0, 'neutral': 0, 'happy': 0, 'super': 0};
    for (final entry in entries) {
      final moodLabel = moodMap[entry.mood];
      moodFrequency[moodLabel!] = (moodFrequency[moodLabel] ?? 0) + 1;
    }
    return moodFrequency;
  }

  @override
  Widget build(BuildContext context) {
    final data = generateSampleData();
    final weeklySleepData = calculateSleepData(data, 7);
    final monthlySleepData = calculateSleepData(data, 30);
    final averageSleep = calculateAverageSleep(monthlySleepData);
    final maxSleep = calculateMaxSleep(monthlySleepData);
    final minSleep = calculateMinSleep(monthlySleepData);   
    final weeklyMoodData = calculateMoodData(data, 7);
    final monthlyMoodData = calculateMoodData(data, 30);

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(showLogo: true),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CentralCard(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Graph view of your statistics', 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SectionTitle(title: 'Weekly sleep statistics'),
                          SleepLineChart(
                            sleepData: weeklySleepData, 
                            labels: const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
                          ),
                          const SectionTitle(title: 'Monthly sleep statistics'),
                          SleepLineChart(
                            sleepData: monthlySleepData, 
                            labels: List.generate(monthlySleepData.length, (index) => (index + 1).toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Average Sleep Time: ${formatSleepDuration(averageSleep)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Max Sleep Time: ${formatSleepDuration(maxSleep)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Min Sleep Time: ${formatSleepDuration(minSleep)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SectionTitle(title: 'Weekly mood statistics'),
                          MoodPieChart(moodData: weeklyMoodData),
                          const SectionTitle(title: 'Monthly mood statistics'),
                          MoodPieChart(moodData: monthlyMoodData),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}