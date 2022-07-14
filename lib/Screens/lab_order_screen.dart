import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/Screens/give_order_screen.dart';
import 'package:doctor_users/models/lab_model.dart';
import 'package:flutter/material.dart';

class LabOrderScreen extends StatefulWidget {
  const LabOrderScreen({Key? key, required this.patientName, required this.patientId, required this.orderUuids}) : super(key: key);
  final String patientName;
  final String patientId;
  final List<Map<String, dynamic>> orderUuids;

  @override
  State<LabOrderScreen> createState() => _LabOrderScreenState();
}

class _LabOrderScreenState extends State<LabOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Available Laboratories"),
        ),
        body: FutureBuilder<Map<Lab, List<LabService>>?>(
          future: FirebaseApi.getAllLabs(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (!snapshot.hasData) {
                  return const Center(child: Text("Can't retrive data"));
                } else {
                  Map<Lab, List<LabService>>? labMap = snapshot.data;
                  List<MapEntry> labMapList = labMap!.entries.toList();
                  return ListView.builder(
                    itemCount: labMapList.length,
                    itemBuilder: ((context, index) {
                      Lab lab = labMapList[index].key;
                      List<LabService> labServices = labMapList[index].value;
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>GiveOrderScreen(
                              labName: lab.name,
                              patientName: widget.patientName,
                              labUserName: lab.username,
                              patientId: widget.patientId,
                              orderUuids: widget.orderUuids,
                            )));
                          },
                          child: Card(
                            color: Colors.lightBlue.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 10.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.5, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    lab.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.5,
                                    ),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 10.0),
                                  Table(
                                    children: [
                                      TableRow(children: [
                                        const Text("location ---"),
                                        Text(
                                          lab.loc,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.5,
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        const Text("phone number ---"),
                                        Text(
                                          lab.phone_number,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.5,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Text(
                                      "${lab.name} provides the following services"),
                                  const Divider(),
                                  ...labServices.map(
                                    (e) => Column(
                                      children: [
                                        Table(
                                          children: [
                                            TableRow(
                                              children: [
                                                const Text('service name ---'),
                                                Text(
                                                  e.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                const Text('price ---'),
                                                Text(
                                                  "${e.price} Birr",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                const Text('estimated hour ---'),
                                                Text(
                                                  e.time,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 4.0,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(height: 10.0),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
            }
          }),
        ),
      ),
    );
  }
}
