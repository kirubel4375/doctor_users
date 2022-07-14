import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/Screens/chat_screen.dart';
import 'package:doctor_users/Screens/patient_detail.dart';
import 'package:doctor_users/models/user_model.dart';
import 'package:flutter/material.dart';

class PatientsList extends StatefulWidget {
  const PatientsList({Key? key}) : super(key: key);

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patients"),
      ),
      body: FutureBuilder<List<Patient>>(
        future: FirebaseApi.getPatients(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text("Can't retrive data"));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
              List<Patient>? patients = snapshot.data;
              if(patients!.isEmpty){
                return const Center(child: Text("Your patients will appear here."),);
              }else {
                return ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => PatientDetail(
                          patientId: patients[index].id,
                          patientName: patients[index].name,
                          orderUuids: patients[index].orderUuids,
                          patient: patients[index],
                          email: patients[index].email,
                        ))));
                      },
                      leading: CircleAvatar(
                        child: Text(
                          patients[index].name[0],
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      title: Text(patients[index].name),
                      subtitle: Text('${DateTime.now().difference(patients[index].lastMessageTime.toDate()).inDays} days'),
                    );
                  }),
                );
              }
              } else {
                return const Center(child: Text("The patients that are assigned to you will appear here"),);
              }
          }
        }),
      ),
    );
  }
}
