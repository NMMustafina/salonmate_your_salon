import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MmaasstteRevie {
  final int maasstteRevieId;
  final List<Uint8List> maasstteReviePhotos;
  final DateTime maasstteRevieDate;
  final String maasstteRevieDesc;
  final String maasstteRevieClientName;

  MmaasstteRevie({
    required this.maasstteRevieId,
    required this.maasstteReviePhotos,
    required this.maasstteRevieDate,
    required this.maasstteRevieDesc,
    required this.maasstteRevieClientName,
  });

  Map<String, dynamic> toJson() {
    return {
      'maasstteRevieId': maasstteRevieId,
      'maasstteReviePhotos':
          maasstteReviePhotos.map((photo) => base64Encode(photo)).toList(),
      'maasstteRevieDate': maasstteRevieDate.toIso8601String(),
      'maasstteRevieDesc': maasstteRevieDesc,
      'maasstteRevieClientName': maasstteRevieClientName,
    };
  }

  factory MmaasstteRevie.fromJson(Map<String, dynamic> json) {
    return MmaasstteRevie(
      maasstteRevieId: json['maasstteRevieId'],
      maasstteReviePhotos: (json['maasstteReviePhotos'] as List)
          .map((photo) => base64Decode(photo))
          .toList(),
      maasstteRevieDate: DateTime.parse(json['maasstteRevieDate']),
      maasstteRevieDesc: json['maasstteRevieDesc'],
      maasstteRevieClientName: json['maasstteRevieClientName'],
    );
  }
}

class MastteModl {
  final int maasstteId;
  final Uint8List? maassttePhoto;
  final String maasstteName;
  final String maasstteSpecial;
  final String maasstteExperi;
  final String maasstteDesc;
  final List<MmaasstteRevie> mmaasstteRevieList;

  MastteModl({
    required this.maasstteId,
    this.maassttePhoto,
    required this.maasstteName,
    required this.maasstteSpecial,
    required this.maasstteExperi,
    required this.maasstteDesc,
    required this.mmaasstteRevieList,
  });

  Map<String, dynamic> toJson() {
    return {
      'maasstteId': maasstteId,
      'maassttePhoto':
          maassttePhoto != null ? base64Encode(maassttePhoto!) : null,
      'maasstteName': maasstteName,
      'maasstteSpecial': maasstteSpecial,
      'maasstteExperi': maasstteExperi,
      'maasstteDesc': maasstteDesc,
      'mmaasstteRevieList':
          mmaasstteRevieList.map((review) => review.toJson()).toList(),
    };
  }

  factory MastteModl.fromJson(Map<String, dynamic> json) {
    return MastteModl(
      maasstteId: json['maasstteId'],
      maassttePhoto: json['maassttePhoto'] != null
          ? base64Decode(json['maassttePhoto'])
          : null,
      maasstteName: json['maasstteName'],
      maasstteSpecial: json['maasstteSpecial'],
      maasstteExperi: json['maasstteExperi'],
      maasstteDesc: json['maasstteDesc'],
      mmaasstteRevieList: (json['mmaasstteRevieList'] as List)
          .map((review) => MmaasstteRevie.fromJson(review))
          .toList(),
    );
  }
}

class MasttePrvdr with ChangeNotifier {
  static const String _key = 'mastte_list';
  List<MastteModl> _mastteList = [];

  MasttePrvdr() {
    _loadMastteList();
  }

  List<MastteModl> get mastteList => _mastteList;

  void _loadMastteList() async {
    final bgfcgf = await SharedPreferences.getInstance();
    final jsonString = bgfcgf.getString(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _mastteList = jsonList.map((json) => MastteModl.fromJson(json)).toList();
      notifyListeners();
    }
  }

  void _saveMastteList() async {
    final bgfcgf = await SharedPreferences.getInstance();

    final jsonList = _mastteList.map((mastte) => mastte.toJson()).toList();
    bgfcgf.setString(_key, jsonEncode(jsonList));
  }

  Future<void> addUpdateMastte(MastteModl mastte) async {
    final index =
        _mastteList.indexWhere((m) => m.maasstteId == mastte.maasstteId);
    if (index >= 0) {
      _mastteList[index] = mastte;
    } else {
      _mastteList.add(mastte);
    }
    _saveMastteList();
    notifyListeners();
  }

  Future<void> addUpdateMmaasstteRevie(
      int mastteId, MmaasstteRevie review) async {
    final mastteIndex = _mastteList.indexWhere((m) => m.maasstteId == mastteId);
    if (mastteIndex >= 0) {
      final reviews = _mastteList[mastteIndex].mmaasstteRevieList;
      final reviewIndex = reviews
          .indexWhere((r) => r.maasstteRevieId == review.maasstteRevieId);

      if (reviewIndex >= 0) {
        reviews[reviewIndex] = review;
      } else {
        reviews.add(review);
      }

      final updatedMastte = MastteModl(
        maasstteId: _mastteList[mastteIndex].maasstteId,
        maassttePhoto: _mastteList[mastteIndex].maassttePhoto,
        maasstteName: _mastteList[mastteIndex].maasstteName,
        maasstteSpecial: _mastteList[mastteIndex].maasstteSpecial,
        maasstteExperi: _mastteList[mastteIndex].maasstteExperi,
        maasstteDesc: _mastteList[mastteIndex].maasstteDesc,
        mmaasstteRevieList: reviews,
      );

      _mastteList[mastteIndex] = updatedMastte;
      _saveMastteList();
      notifyListeners();
    }
  }

  Future<void> deleteMastte(int mastteId) async {
    _mastteList.removeWhere((m) => m.maasstteId == mastteId);
    _saveMastteList();
    notifyListeners();
  }

  Future<void> deleteMmaasstteRevie(int mastteId, int reviewId) async {
    final mastteIndex = _mastteList.indexWhere((m) => m.maasstteId == mastteId);
    if (mastteIndex >= 0) {
      final reviews = _mastteList[mastteIndex].mmaasstteRevieList;
      reviews.removeWhere((r) => r.maasstteRevieId == reviewId);

      final updatedMastte = MastteModl(
        maasstteId: _mastteList[mastteIndex].maasstteId,
        maassttePhoto: _mastteList[mastteIndex].maassttePhoto,
        maasstteName: _mastteList[mastteIndex].maasstteName,
        maasstteSpecial: _mastteList[mastteIndex].maasstteSpecial,
        maasstteExperi: _mastteList[mastteIndex].maasstteExperi,
        maasstteDesc: _mastteList[mastteIndex].maasstteDesc,
        mmaasstteRevieList: reviews,
      );

      _mastteList[mastteIndex] = updatedMastte;
      _saveMastteList();
      notifyListeners();
    }
  }
}

class Appointment {
  final String master;
  final String service;
  final TimeOfDay time;
  bool enabled;

  Appointment({
    required this.master,
    required this.service,
    required this.time,
    this.enabled = true,
  });
}

class AppointmentPrvdr with ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  void addAppointment(Appointment appt) {
    _appointments.add(appt);
    notifyListeners();
  }

  void toggleEnabled(int index) {
    _appointments[index].enabled = !_appointments[index].enabled;
    notifyListeners();
  }
}
