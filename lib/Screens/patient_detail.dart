import 'package:doctor_users/Constants/colors.dart';
import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/Functions/search_deleget.dart';
import 'package:doctor_users/Screens/chat_screen.dart';
import 'package:doctor_users/Screens/lab_order_screen.dart';
import 'package:doctor_users/Screens/show_lab_orders.dart';
import 'package:doctor_users/Screens/show_lab_results_list.dart';
import 'package:doctor_users/Screens/vital_page.dart';
import 'package:doctor_users/models/provider_patient_doctor.dart';
import 'package:doctor_users/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class PatientDetail extends StatefulWidget {
  const PatientDetail({
    Key? key,
    required this.patientName,
    required this.patientId,
    required this.orderUuids,
    required this.patient,
    required this.email,
  }) : super(key: key);
  final String patientName;
  final String patientId;
  final List<Map<String, dynamic>> orderUuids;
  final Patient patient;
  final String email;

  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  bool inAsyncCall = false;

  @override
  void initState() {
    doSeparetWork();
    super.initState();
  }

  doSeparetWork() async {
    Doctor doctor = await FirebaseApi.getTheDoc();
    Provider.of<PharmaCheck>(context, listen: false).setDoctor(doctor);
    Provider.of<PharmaCheck>(context, listen: false).setPatient(widget.patient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Detail"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: inAsyncCall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Card(
                  child: Icon(Icons.person, size: 120),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.patientName),
                    const Text("DOB: 1999/09/20"),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ChatScreen(
                                  patientId: widget.patientId,
                                  patientName: widget.patientName,
                                ))));
                  },
                  child: const Text("Message"),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LabOrderScreen(
                                    patientName: widget.patientName,
                                    patientId: widget.patientId,
                                    orderUuids: widget.orderUuids,
                                  ))));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: kLightBlueButtonColor,
                      ),
                      child: const Text(
                        "Order",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  GestureDetector(
                    onTap: () async => showSearch(
                        context: context, delegate: MedicineSearch()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: kLightBlueButtonColor,
                      ),
                      child: const Text(
                        "Prescibe",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GrayButtons(
              title: "Vitals",
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) => VitalPage(email: widget.email)));
              },
              notfications: 3,
            ),
            GrayButtons(
              title: "Lab Results",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowLabResult(
                              patientId: widget.patientId,
                              orderUuids: widget.orderUuids,
                            )));
              },
              notfications: 3,
            ),
            GrayButtons(
              title: "Pending Orders",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowLabOrders(
                              patientId: widget.patientId,
                              orderUuids: widget.orderUuids,
                            )));
              },
              notfications: 3,
            ),
            GrayButtons(
              title: "Prescription Records",
              onTap: () {},
              notfications: 3,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class GrayButtons extends StatelessWidget {
  const GrayButtons({
    required this.onTap,
    required this.title,
    required this.notfications,
    Key? key,
  }) : super(key: key);

  final Function()? onTap;
  final String title;
  final int notfications;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        width: double.infinity,
        height: 60.0,
        color: kButtonGrayColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .089,
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 19.0),
              ),
            ),
            Container(
              height: 30.0,
              width: 30.0,
              decoration: const BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Center(
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  child: Center(child: Text("$notfications")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
