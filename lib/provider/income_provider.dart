import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/income_entry.dart';

class IncomeProvider with ChangeNotifier {
  static const _key = 'income_entries';
  List<IncomeEntry> _entries = [];

  List<IncomeEntry> get entries => _entries;

  IncomeProvider() {
    _load();
  }

  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _entries = list.map((e) => IncomeEntry.fromJson(e)).toList();
      notifyListeners();
    }
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _key,
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }

  void addOrUpdate(IncomeEntry entry) {
    final i = _entries.indexWhere((e) => e.id == entry.id);
    if (i != -1) {
      _entries[i] = entry;
    } else {
      _entries.add(entry);
    }
    _save();
    notifyListeners();
  }

  void delete(int id) {
    _entries.removeWhere((e) => e.id == id);
    _save();
    notifyListeners();
  }

  List<IncomeEntry> entriesForDay(DateTime day) {
    return _entries
        .where((e) =>
            e.date.year == day.year &&
            e.date.month == day.month &&
            e.date.day == day.day)
        .toList();
  }

  List<IncomeEntry> entriesForMonth(DateTime month) {
    return _entries
        .where((e) => e.date.year == month.year && e.date.month == month.month)
        .toList();
  }

  double totalForDay(DateTime day) =>
      entriesForDay(day).fold(0.0, (sum, e) => sum + e.amount);

  double totalForMonth(DateTime month) =>
      entriesForMonth(month).fold(0.0, (sum, e) => sum + e.amount);
}
