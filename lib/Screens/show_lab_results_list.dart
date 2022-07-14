import 'package:doctor_users/Functions/enums.dart';
import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/Screens/lab_result_detail.dart';
import 'package:doctor_users/models/lab_model.dart';
import 'package:doctor_users/models/provider_patient_doctor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowLabResult extends StatelessWidget {
  const ShowLabResult({
    Key? key,
    required this.patientId,
    required this.orderUuids,
  }) : super(key: key);
  final String patientId;
  final List<Map<String, dynamic>> orderUuids;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Result"),
        ),
        body: FutureBuilder<List<LabOrder>?>(
          future: FirebaseApi.getOrderResults(
              patientId: patientId,
              orderUuids: orderUuids,
              compPending: CompPending.completed),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                List<LabOrder>? labOrders = snapshot.data;
                if (labOrders == null) {
                  return const Center(child: Text("please try again"));
                } else if (labOrders.isEmpty) {
                  return const Center(
                      child: Text("Orders will be displayed here."));
                }
                return ListView.builder(
                  itemCount: labOrders.length,
                  itemBuilder: ((context, index) {
                    String username = "";
                    List<Map<String, dynamic>> orderIds =
                        Provider.of<PharmaCheck>(context, listen: false)
                            .getPatient
                            .orderUuids;
                    for (Map<String, dynamic> x in orderIds) {
                      if (labOrders[index].id == x.values.first) {
                        username = x.keys.first;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LabResultDetail(
                                usernameUuid: orderUuids,
                                singleUuid: labOrders[index].id,
                                username: username,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.lightBlue.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Ordered to: "),
                                    const SizedBox(width: 30.0),
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        fontSize: 19.0,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 13.0),
                                const Divider(),
                                Text(labOrders[index].note),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
            }
          }),
        ),
      ),
    );
  }
}
