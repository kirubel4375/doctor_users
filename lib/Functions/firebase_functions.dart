import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_users/Functions/enums.dart';
import 'package:doctor_users/models/lab_model.dart';
import 'package:doctor_users/models/messages.dart';
import 'package:doctor_users/models/pharmacy_models.dart';
import 'package:doctor_users/models/provider_patient_doctor.dart';
import 'package:doctor_users/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:short_uuids/short_uuids.dart';

class FirebaseApi extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  User? get getLoggedInUser => _auth.currentUser;

  static Future<Doctor> getTheDoc() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final _firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> result =
        await _firestore.collection("doctors").doc(currentUserId).get();
    return Doctor.fromJson(result.data());
  }

  static Future<List<Patient>> getPatients() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('patients')
        .where('immadiateDocId', isEqualTo: currentUserId)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> userQueryList =
        querySnapshot.docs;
    List<Patient> userList =
        userQueryList.map((e) => Patient.fromJson(e.data())).toList();
    return userList;
  }

  static Future uploadMessage(
      {required String message, required String? recieverId}) async {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    final userId = _auth.currentUser!.uid;
    final refMessage =
        _firestore.collection('chats').doc(recieverId).collection('messages');
    await refMessage.add(Messages(
            senderId: userId,
            recieverId: recieverId,
            message: message,
            createdAt: Timestamp.now())
        .toJson());
    final refUser = _firestore.collection('patients');
    await refUser.doc(recieverId).update({
      'lastMessageTime': Timestamp.now(),
    });
  }

  static Future<List<Patient>> getRequestingPatients() async {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    final userId = _auth.currentUser!.uid;
    List<Patient> patientsList = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> query =
          await _firestore.collection("doctors").doc(userId).get();
      Doctor doctor = Doctor.fromJson(query.data());
      List<dynamic> requestingPatientId = doctor.requestPatientId;
      for (String e in requestingPatientId) {
        DocumentSnapshot<Map<String, dynamic>> result =
            await _firestore.collection("patients").doc(e).get();
        patientsList.add(Patient.fromJson(result.data()));
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
    }
    return patientsList;
  }

  static Future<Map<Lab, List<LabService>>?> getAllLabs() async {
    try {
      final _firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> labsquery =
          await _firestore.collection('lab').get();
      List<Lab> labs =
          labsquery.docs.map((e) => Lab.fromJson(e.data())).toList();
      Map<Lab, List<LabService>> labMap = {};
      if (labs.isNotEmpty) {
        for (Lab lab in labs) {
          QuerySnapshot<Map<String, dynamic>> serviceQuery = await _firestore
              .collection('lab')
              .doc(lab.username)
              .collection('services')
              .get();
          List<LabService> labserivces = serviceQuery.docs
              .map((e) => LabService.fromJson(e.data()))
              .toList();
          labMap[lab] = labserivces;
        }
        return labMap;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return null;
    }
  }

  static Future<String> giveOrder(
      {required String username,
      required String note,
      required String patient,
      required String doctor,
      required String patientId,
      required String labName,
      required List<Map<String, dynamic>> orderUuids}) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      final translator = ShortUuid.init();
      final uuid = translator.generate();
      await _firestore
          .collection('lab')
          .doc(username)
          .collection('order')
          .doc(uuid)
          .set(LabOrder(
                  doctor: doctor,
                  date: Timestamp.now(),
                  patient: patient,
                  id: uuid,
                  note: note,
                  result: false)
              .toJson());
      orderUuids.add({username: uuid});
      _firestore.collection('patients').doc(patientId).update({
        'orderUuids': orderUuids,
      });
      return "success,$labName,$uuid";
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  static Future<List<LabOrder>?> getOrderResults(
      {required String patientId,
      required List<Map<String, dynamic>> orderUuids,
      required CompPending compPending}) async {
    try {
      List<LabOrder> labOrders = [];
      List<LabOrder> completedOrders = [];
      for (Map<String, dynamic> orderUuid in orderUuids) {
        final _firestore = FirebaseFirestore.instance;
        DocumentSnapshot<Map<String, dynamic>> orderQuery = await _firestore
            .collection('lab')
            .doc(orderUuid.keys.first)
            .collection('order')
            .doc(orderUuid.values.first.toString())
            .get();
        LabOrder order = LabOrder.fromJson(orderQuery.data());
        if (order.result) {
          completedOrders.add(order);
        } else {
          labOrders.add(order);
        }
      }
      return compPending == CompPending.completed ? completedOrders : labOrders;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  static Future<String> fetchExactLabResults(
      {required Map<String, dynamic> uuidUsername}) async {
    final _firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> fiechQuery = await _firestore
        .collection('lab')
        .doc(uuidUsername.keys.first)
        .collection('order')
        .doc(uuidUsername.values.first)
        .collection('result')
        .get();
    String fetch = fiechQuery.docs.first.data().values.first;
    return fetch;
  }

  static Future<Map<Pharmacy, List<Drug>>> getPharmaAndMeds(
      {required String query, required String username}) async {
    final _firestore = FirebaseFirestore.instance;
    Map<Pharmacy, List<Drug>> pharmaMap = {};
    if (username.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> pharmaQuery =
          await _firestore.collection('pharma').doc(username).get();
      Pharmacy aPharmacy = Pharmacy.fromJson(pharmaQuery.data());
      QuerySnapshot<Map<String, dynamic>> drugQuery = await _firestore
          .collection('pharma')
          .doc(username)
          .collection("Drugs")
          .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> drugDocQuery =
          drugQuery.docs;
      List<Drug> drugs =
          drugDocQuery.map((e) => Drug.fromJson(e.data())).toList();
      List<Drug> filteredDrugs = drugs
          .where((e) => e.name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
      if (filteredDrugs.isNotEmpty) {
        pharmaMap[aPharmacy] = filteredDrugs;
        return pharmaMap;
      }
    }
    QuerySnapshot<Map<String, dynamic>> pharmaQuery =
        await _firestore.collection('pharma').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> pharmaDocQuery =
        pharmaQuery.docs;
    List<Pharmacy> pharmacies =
        pharmaDocQuery.map((e) => Pharmacy.fromJson(e.data())).toList();
    if (pharmacies.isNotEmpty) {
      for (Pharmacy pharmacy in pharmacies) {
        QuerySnapshot<Map<String, dynamic>> drugQuery = await _firestore
            .collection('pharma')
            .doc(pharmacy.username)
            .collection("Drugs")
            .get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> drugDocQuery =
            drugQuery.docs;
        List<Drug> drugs =
            drugDocQuery.map((e) => Drug.fromJson(e.data())).toList();
        List<Drug> filteredDrugs = drugs
            .where((e) => e.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
        pharmaMap[pharmacy] = filteredDrugs;
      }
      return pharmaMap;
    } else {
      return {};
    }
  }

  static Future<String> uploadPrescription(
      {required BuildContext context,
      required Map<Pharmacy, Drug> map,
      required String note,
      required int amount}) async {
    final _firestore = FirebaseFirestore.instance;
    final translator = ShortUuid.init();
    final uuid = translator.generate();
    Doctor doctor = Provider.of<PharmaCheck>(context, listen: false).getDoctor;
    Patient patient =
        Provider.of<PharmaCheck>(context, listen: false).getPatient;
    String pharmacyName = map.entries.first.key.name;
    await _firestore
        .collection('pharma')
        .doc(map.entries.first.key.username)
        .collection('Prescription')
        .doc(uuid)
        .set(Prescription(
          doctor: doctor.name,
          date: Timestamp.now(),
          patient: patient.name,
          id: uuid,
          note: note,
          sold: false,
        ).toJson());
    await _firestore
        .collection('pharma')
        .doc(map.entries.first.key.username)
        .collection('Prescription')
        .doc(uuid)
        .collection("drugs")
        .add(PriscribedDrug(
          amount: amount,
          name: map.values.first.name,
          dose: " ",
          note: note,
        ).toJson());
        return "success,$pharmacyName,$uuid";
  }

  static Future<Map<List<String>, List<String>>> getVitalinfo(
      String email) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("${email.split('.').first + email.split('.').last}/Heartbeat");
    DatabaseEvent event = await ref.once();
    DatabaseReference ref1 = FirebaseDatabase.instance
        .ref("${email.split('.').first + email.split('.').last}/Blood Oxygen");
    DatabaseEvent event1 = await ref1.once();
    final event1Value = event1.snapshot.children;
    final values = event.snapshot.children;
    List<String> heartbeatValue = [];
    List<String> oxygenLevelValue = [];
    for (DataSnapshot dataSnapshot in values) {
      heartbeatValue.add(dataSnapshot.value.toString());
    }
    for (DataSnapshot dataSnapshot in event1Value) {
      oxygenLevelValue.add(dataSnapshot.value.toString());
    }
    Map<List<String>, List<String>> mapTwoStrings = {};
    mapTwoStrings[heartbeatValue] = oxygenLevelValue;
    return mapTwoStrings;
  }
}
