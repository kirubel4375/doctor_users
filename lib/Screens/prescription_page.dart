import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/Functions/search_deleget.dart';
import 'package:doctor_users/Screens/Homepage.dart';
import 'package:doctor_users/models/pharmacy_models.dart';
import 'package:doctor_users/models/provider_patient_doctor.dart';
import 'package:doctor_users/models/provider_pharma_drug.dart';
import 'package:doctor_users/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({Key? key, required this.pharmacy, required this.drug})
      : super(key: key);
  final Pharmacy pharmacy;
  final Drug drug;

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  TextEditingController noteEditingController = TextEditingController();
  TextEditingController numberEditingController = TextEditingController();
  bool inAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Prescribe"),
        ),
        body: ModalProgressHUD(
          inAsyncCall: inAsyncCall,
          child: Column(
            children: [
              Expanded(
                child: Card(
                  color: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20.0)
                        .copyWith(right: 8.0),
                    child: Column(children: [
                      Column(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  const Text("pharmacy name:"),
                                  Text(
                                    widget.pharmacy.name,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text("Located at:"),
                                  Text(
                                    widget.pharmacy.loc,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text("Contact:"),
                                  Text(
                                    widget.pharmacy.phone_number,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  const Text("name:"),
                                  Text(
                                    widget.drug.name,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(children: [
                                Container(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .78,
                                  child: TextField(
                                    maxLines: 2,
                                    controller: noteEditingController,
                                    decoration: InputDecoration(
                                      hintText: "Enter your notes here",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                const Text("Amount"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .45,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 8.0),
                                    child: TextField(
                                      controller: numberEditingController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    inAsyncCall = true;
                  });
                  Patient patient =
                      Provider.of<PharmaCheck>(context).getPatient;
                  Map<Pharmacy, Drug> pmDrug = {};
                  pmDrug[widget.pharmacy] = widget.drug;
                  String prescriptionResult =
                      await FirebaseApi.uploadPrescription(
                    context: context,
                    map: pmDrug,
                    note: noteEditingController.text,
                    amount: double.parse(numberEditingController.text).floor(),
                  );
                  if (prescriptionResult.split(',').first == "success") {
                    await FirebaseApi.uploadMessage(
                      message:
                          "${prescriptionResult.split(',')[2]} take this id to ${prescriptionResult.split(',')[1]} ",
                      recieverId: patient.id,
                    );
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 4),
                      content: Text("Order unsuccessful please try again"),
                    ));
                  }
                  setState(() {
                    inAsyncCall = false;
                  });
                },
                child: const Text("prescribe"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
