// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Pharmacy {
  final String name;
  final String loc;
  final bool open;
  final String phone_number;
  final String username;

  Pharmacy(
      {required this.name,
      required this.loc,
      required this.open,
      required this.phone_number,
      required this.username});

  static Pharmacy fromJson(Map<String, dynamic>? json) => Pharmacy(
      name: json!['name'],
      loc: json['loc'],
      open: json['open'],
      phone_number: json['phone_number'],
      username: json['username']);
  Map<String, dynamic> toJson() => {
        'name': name,
        'loc': loc,
        'open': open,
        'phone_number': phone_number,
        'username': username
      };
}

class Drug {
  final String generic_name;
  final String name;
  final String price;
  final String expire_date;

  Drug({
    required this.generic_name,
    required this.name,
    required this.price,
    required this.expire_date,
  });

  static Drug fromJson(Map<String, dynamic> json) => Drug(
        generic_name: json['generic_name'],
        name: json['name'],
        price: json['price'].toString(),
        expire_date: json['expire_date'],
      );
  Map<String, dynamic> toJson() => {
        'generic_name': generic_name,
        'name': name,
        'price': price,
        'expire_date': expire_date,
      };
}

class Prescription {
  final String doctor;
  final Timestamp date;
  final String patient;
  final String id;
  final String note;
  final bool sold;

  Prescription({
    required this.doctor,
    required this.date,
    required this.patient,
    required this.id,
    required this.note,
    required this.sold,
  });
  static Prescription fromJson(Map<String, dynamic> json) => Prescription(
        doctor: json['doctor'],
        date: json['date'],
        patient: json['patient'],
        id: json['id'],
        note: json['note'],
        sold: json['sold'],
      );
  Map<String, dynamic> toJson() => {
        'doctor': doctor,
        'date': date,
        'patient': patient,
        'id': id,
        'note': note,
        'sold': sold,
      };
}

class PriscribedDrug {
  final int amount;
  final String name;
  final String dose;
  final String note;

  PriscribedDrug({
    required this.amount,
    required this.name,
    required this.dose,
    required this.note,
  });
  static PriscribedDrug fromJson(Map<String, dynamic> json) => PriscribedDrug(
        amount: json['amount'],
        name: json['name'],
        dose: json['dose'],
        note: json['note'],
      );
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'name': name,
        'dose': dose,
        'note': note,
      };
}
