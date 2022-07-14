import 'package:flutter/material.dart';

class DiagnosisDetail extends StatelessWidget {
  const DiagnosisDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnosis Detail"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  Card(
                    child: Icon(Icons.person, size: 120),
                  ),
                  SizedBox(height: 5.0),
                  Text("Diagnosis Detail")
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Tessema Lema"),
                  Text("DOB: 1999/09/20"),
                  Text("Age: 88"),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30.0,
          ),
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text(
                          "Card Type:",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(width:10.0),
                        Text("6578954",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding:const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text(
                          "Card Number:",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(width:10.0),
                        Text("6578954",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding:const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text(
                          "Name on Card:",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(width:10.0),
                        Text("6578954",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding:const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text(
                          "Expiry Date:",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(width:10.0),
                        Text("6578954",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
