import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifelog/models/daily_entry.dart';
import 'package:lifelog/providers/daily_entry_provider.dart';
import 'package:lifelog/services/location_service.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/gradient_background.dart';
import 'package:lifelog/widgets/mood_picker.dart';
import 'package:lifelog/widgets/photo_of_the_day.dart';
import 'package:lifelog/widgets/section_title.dart';
import 'package:lifelog/widgets/sleep_time_picker.dart';
import 'package:provider/provider.dart';

class AddDailyEntryScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddDailyEntryScreen({super.key, required this.selectedDate});

  @override
  State<AddDailyEntryScreen> createState() => _AddDailyEntryScreenState();
}

class _AddDailyEntryScreenState extends State<AddDailyEntryScreen> {
  String? selectedMood;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  LatLng? currentLocation;
  XFile? photoOfTheDay;

  final TextEditingController gratefulForController = TextEditingController();
  final TextEditingController highlightsController = TextEditingController();

  void _submitEntry(BuildContext context) {
    if (selectedMood == null ||
        startTime == null ||
        endTime == null ||
        photoOfTheDay == null ||
        gratefulForController.text.isEmpty ||
        highlightsController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please populate all fields'))
          );
          return;
        }
    final entry = DailyEntry(
      mood: selectedMood!, 
      sleepStartTime: startTime!, 
      sleepEndTime: endTime!, 
      gratefulFor: gratefulForController.text, 
      highlights: highlightsController.text, 
      location: currentLocation!,
      photoOfTheDayPath: photoOfTheDay!.path,
    );
    final dateOnly = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);
    Provider.of<DailyEntryProvider>(context, listen: false).addEntry(entry, dateOnly);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                          Text(
                            DateFormat('dd MMMM yyyy').format(widget.selectedDate),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SectionTitle(title: 'Mood'),
                          MoodPicker(
                            selectedMood: selectedMood, 
                            onMoodSelected: (mood) {
                              setState(() {
                                selectedMood = mood;
                              });
                            },
                          ),
                          const SectionTitle(title: 'Sleep'),
                          SleepTimePicker(
                            onStartTimeChanged: (time) {
                              setState(() {
                                startTime = time;
                              });
                            }, 
                            onEndTimeChanged: (time) {
                              setState(() {
                                endTime = time;
                              });
                            }
                          ),
                          const SectionTitle(title: 'Grateful For'),
                          TextField(
                            controller: gratefulForController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF5D9EEA))),
                              hintText: 'Enter one thing you are grateful for today'
                            ),
                          ),
                          const SectionTitle(title: 'Highlights'),
                          TextField(
                            controller: highlightsController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF5D9EEA))),
                              hintText: 'Enter the highlights of the day',
                            ),
                          ),
                          const SectionTitle(title: 'Location'),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final scaffoldMessenger = ScaffoldMessenger.of(context);

                              try {
                                Position position = await LocationService().getCurrentLocation();
                                setState(() {
                                  currentLocation = LatLng(position.latitude, position.longitude);
                                });
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Location set to: (${position.latitude}, ${position.longitude})'),
                                  ),
                                );
                              } catch (e) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(content: Text('Failed to get location: $e')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Color.fromARGB(255, 207, 207, 207))  
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black
                            ),
                            icon: const Icon(Icons.location_on, color: Color(0xFF5D9EEA)),
                            label: const Text('Use Current Location', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
                          const SectionTitle(title: 'Photo of the Day'),
                          PhotoOfTheDay(
                            photoOfTheDay: photoOfTheDay, 
                            onPhotoSelected: (photo) {
                              setState(() {
                                photoOfTheDay = photo;
                              });
                            }
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          ElevatedButton(
                            onPressed: () => _submitEntry(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF5D9EEA)
                            ),
                            child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          ),
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