import 'package:doctor_users/models/pharmacy_models.dart';
import 'package:flutter/cupertino.dart';

class PharmaDrug extends ChangeNotifier{
  List<MapEntry<Pharmacy, Drug>> _listEntry= [];

  List<MapEntry<Pharmacy, Drug>> get getPharmacyDrugEntries =>_listEntry;

  void setPharmacyDrugEntry(Pharmacy pharmacy, Drug drug){
    Map<Pharmacy, Drug> theMap = {};
    theMap[pharmacy]= drug;
    MapEntry<Pharmacy, Drug> entry = theMap.entries.first;
    _listEntry.add(entry);
    notifyListeners();
  }
  void clearListEntry(){
    _listEntry.clear();
    notifyListeners();
  }
}