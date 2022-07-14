import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  Doctor({required this.name, required this.id, required this.lastMessageTime, required this.immadiatePatientId, required this.requestPatientId});
  final String name;
  final String id;
  final Timestamp lastMessageTime;
  final List<dynamic> immadiatePatientId;
  final List<dynamic> requestPatientId;

  static Doctor fromJson(Map<String, dynamic>? json) => Doctor(
        name: json!['name'],
        id: json['id'],
        lastMessageTime: json['lastMessageTime'],
        immadiatePatientId: json['immadiatePatientId'],
        requestPatientId: json['requestPatientId'],
      );
  Map<String, dynamic> toJson()=>{
    'name': name,
    'id': id,
    'lastMessageTime': lastMessageTime,
    'immadiatePatientId': immadiatePatientId,
    'requestPatientId': requestPatientId,
  };
}


class Patient {
  Patient({required this.name, required this.email, required this.id, required this.lastMessageTime, required this.immadiateDocId, required this.orderUuids});
  final String name;
  final String id;
  final Timestamp lastMessageTime;
  final String immadiateDocId;
  final List<Map<String, dynamic>> orderUuids;
  final String email;

  static Patient fromJson(Map<String, dynamic>? json) => Patient(
        name: json!['name'],
        id: json['id'],
        email: json['email'],
        lastMessageTime: json['lastMessageTime'],
        immadiateDocId: json['immadiateDocId'],
        orderUuids: json['orderUuids'].cast<Map<String, dynamic>>(),
      );
  Map<String, dynamic> toJson()=>{
    'name': name,
    'id': id,
    'email': email,
    'lastMessageTime': lastMessageTime,
    'immadiateDocId': immadiateDocId,
    'orderUuids': orderUuids,
  };
}
