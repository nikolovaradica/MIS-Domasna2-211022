import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifelog/models/daily_entry.dart';
import 'package:lifelog/providers/daily_entry_provider.dart';
import 'package:lifelog/screens/add_daily_entry_screen.dart';
import 'package:lifelog/screens/profile_screen.dart';
import 'package:lifelog/screens/view_daily_entry_screen.dart';
import 'package:lifelog/screens/view_graphs_screen.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/gradient_background.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<DailyEntryProvider>(context).entries;

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
                          TableCalendar(
                            firstDay: DateTime.utc(2010),
                            lastDay: DateTime.utc(2030),
                            focusedDay: DateTime.now(),
                            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                              });
                              final selectedDateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                              if (entries.containsKey(selectedDateOnly)) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewDailyEntryScreen(
                                      selectedDate: _selectedDay,
                                      entry: entries[selectedDateOnly]!,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddDailyEntryScreen(
                                      selectedDate: _selectedDay
                                    ),
                                  ),
                                );
                              }
                            },
                            enabledDayPredicate: (day) {
                              return !day.isAfter(DateTime.now());
                            },
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Color(0xFF5D9EEA), width: 2),
                                
                              ),
                              selectedDecoration: const BoxDecoration(
                                color: Color(0xFF5D9EEA),
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(
                                color: Color(0xFF5D9EEA),
                                fontWeight: FontWeight.w600,
                              ),
                              markerDecoration: const BoxDecoration(
                                color: Color(0xFF5D9EEA),
                                shape: BoxShape.circle
                              ),
                              markersMaxCount: 1
                            ),
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF5D9EEA)),
                              rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF5D9EEA)),
                            ),
                            eventLoader: (day) {
                              final dateOnly = DateTime(day.year, day.month, day.day);
                              return entries.containsKey(dateOnly) ? [entries[dateOnly]] : [];
                            },
                          ),
                          const Padding(padding: EdgeInsets.only(top: 60)),
                          const Text(
                            'Quote of the Day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          const Text(
                            '“Darkness cannot drive out darkness: only light can do that. Hate cannot drive out hate: only love can do that.”',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 22,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '- Martin Luther King Jr.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 60)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ViewGraphsScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5D9EEA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'My Statistics',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5D9EEA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Profile',
                                  style: TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }
}
