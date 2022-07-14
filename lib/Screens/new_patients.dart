import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}) : super(key: key);

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New Patients Request"),
        ),
        body: FutureBuilder<List<Patient>>(
          future: FirebaseApi.getRequestingPatients(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: Text("Can't retrive data"));
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Request from patients will appear here"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        final patients = snapshot.data;
                        return ListTile(
                          title: Text(patients![index].name),
                          subtitle: Text("${DateTime.now().difference(patients[index].lastMessageTime.toDate()).inHours} hours since last seen"),
                          trailing: SizedBox(
                            width: 190.0,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  child: const Text("Accept"),
                                  onPressed: ()async{
                                    final _firebase = FirebaseFirestore.instance;
                                    final _auth = FirebaseAuth.instance;
                                    final currentUserId = _auth.currentUser!.uid;
                                    await _firebase.collection("patients").doc(patients[index].id).update({
                                      'immadiateDocId': currentUserId
                                    });
                                    Doctor doc = await FirebaseApi.getTheDoc();
                                    List<dynamic> requests = doc.requestPatientId;
                                    bool finalResult = requests.remove(patients[index].id);
                                    List<dynamic> myPatients = doc.immadiatePatientId;
                                    myPatients.add(patients[index].id);
                                    if(finalResult){
                                      await _firebase.collection("doctors").doc(currentUserId).update({
                                        'requestPatientId': requests,
                                        'immadiatePatientId': myPatients,
                                      });
                                    }
                                    setState(() {
                                    });
                                  },
                                ),
                                const SizedBox(width: 10.0),
                                ElevatedButton(
                                  child: const Text("Decline"),
                                  onPressed: ()async{
                                     final _firebase = FirebaseFirestore.instance;
                                    final _auth = FirebaseAuth.instance;
                                    final currentUserId = _auth.currentUser!.uid;
                                    Doctor doc = await FirebaseApi.getTheDoc();
                                    List<dynamic> requests = doc.requestPatientId;
                                    bool finalResult = requests.remove(patients[index].id);
                                    if(finalResult){
                                     _firebase.collection("doctors").doc(currentUserId).update({
                                       'requestPatientId': requests,
                                     });
                                    }
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }
                } else {
                  return const Center(child: Text("no data"));
                }
            }
          },
        ),
      ),
    );
  }
}
