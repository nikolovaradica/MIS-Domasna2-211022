import 'package:flutter/material.dart';
import 'package:lifelog/models/daily_entry.dart';

class DailyEntryProvider with ChangeNotifier {
  final Map<DateTime, DailyEntry> _entries = {};

  Map<DateTime, DailyEntry> get entries => Map.unmodifiable(_entries);

  void addEntry(DailyEntry entry, DateTime date) {
    _entries[date] = entry;
    notifyListeners();
  }
}