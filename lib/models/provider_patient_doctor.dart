import 'package:doctor_users/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class PharmaCheck extends ChangeNotifier{
  late Patient _patient;
  late Doctor _doctor;

  void setPatient(Patient patient){
    _patient = patient;
    notifyListeners();
  }
  void setDoctor(Doctor doctor){
    _doctor = doctor;
    notifyListeners();
  }

  Patient get getPatient=>_patient;
  Doctor get getDoctor=>_doctor;

}