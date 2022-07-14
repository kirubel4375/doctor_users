// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Lab {
  final String name;
  final String loc;
  final String phone_number;
  final String username;

  Lab(
      {required this.name,
      required this.loc,
      required this.phone_number,
      required this.username});

  static Lab fromJson(Map<String, dynamic> json) => Lab(
        name: json['name'],
        loc: json['loc'],
        phone_number: json['phone_number'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'loc': loc,
        'phone_number': phone_number,
        'username': username,
      };
}

class LabService {
  final String name;
  final String price;
  final String time;

  LabService({required this.name, required this.price, required this.time});

  static LabService fromJson(Map<String, dynamic> json) => LabService(
        name: json['name'],
        price: json['price'],
        time: json['time'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'time': time,
      };
}

class LabOrder {
  final String doctor;
  final Timestamp date;
  final String patient;
  final String id;
  final String note;
  final bool result;

  LabOrder({
    required this.doctor,
    required this.date,
    required this.patient,
    required this.id,
    required this.note,
    required this.result,
  });

  static LabOrder fromJson(Map<String, dynamic>? json) => LabOrder(
      doctor: json!['doctor'],
        date: json['date'],
        patient: json['patient'],
        id: json['id'],
        note: json['note'],
        result: json['result'],
      );

  Map<String, dynamic> toJson() => {
        'doctor': doctor,
        'date': date,
        'patient': patient,
        'id': id,
        'note': note,
        'result': result,
      };
}
