import 'package:cloud_firestore/cloud_firestore.dart';

class Messages{
  final String? recieverId;
  final String message;
  final String senderId;
  final Timestamp createdAt;

  Messages({required this.recieverId, required this.message, required this.senderId, required this.createdAt});

  static Messages fromJson(Map<String, dynamic> json)=>Messages(recieverId: json['recieverId'], message: json['message'], senderId: json['senderId'], createdAt: json['createdAt']);

  Map<String, dynamic> toJson()=>{
    'recieverId': recieverId,
    'message': message,
    'senderId': senderId,
    'createdAt': createdAt,
  };
}