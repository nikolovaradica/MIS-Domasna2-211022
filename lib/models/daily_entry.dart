import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DailyEntry {
  final String mood;
  final TimeOfDay sleepStartTime;
  final TimeOfDay sleepEndTime;
  final String gratefulFor;
  final String highlights;
  final LatLng? location;
  final String photoOfTheDayPath;

  DailyEntry({
    required this.mood,
    required this.sleepStartTime,
    required this.sleepEndTime,
    required this.gratefulFor,
    required this.highlights,
    this.location,
    required this.photoOfTheDayPath,
  });
}