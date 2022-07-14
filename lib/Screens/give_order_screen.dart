import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class GiveOrderScreen extends StatefulWidget {
  const GiveOrderScreen({
    Key? key,
    required this.labName,
    required this.patientName,
    required this.labUserName,
    required this.patientId,
    required this.orderUuids,
  }) : super(key: key);
  final String labName;
  final String patientName;
  final String labUserName;
  final String patientId;
  final List<Map<String, dynamic>> orderUuids;

  @override
  State<GiveOrderScreen> createState() => _GiveOrderScreenState();
}

class _GiveOrderScreenState extends State<GiveOrderScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool inAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: inAsyncCall,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Spacer(),
                Card(
                  color: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 19.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.labName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 30.0),
                        TextField(
                          controller: _noteController,
                          maxLines: 10,
                          minLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: "Type message here for the lab.",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              inAsyncCall = true;
                            });
                            final Doctor doc = await FirebaseApi.getTheDoc();
                            String orderResult = await FirebaseApi.giveOrder(
                              username: widget.labUserName,
                              note: _noteController.text,
                              patient: widget.patientName,
                              patientId: widget.patientId,
                              labName: widget.labName,
                              doctor: doc.name,
                              orderUuids: widget.orderUuids,
                            );
                            if (orderResult.split(',').first == "success") {
                              await FirebaseApi.uploadMessage(
                                message: "${orderResult.split(',')[2]} take this id to ${orderResult.split(',')[1]} ",
                                recieverId: widget.patientId,
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Order submited successfuly.")));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Column(
                                children: [
                                  const Text(
                                      "Failed to submit the order please try again."),
                                  Text(orderResult),
                                ],
                              )));
                            }
                            setState(() {
                              inAsyncCall = false;
                            });
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
