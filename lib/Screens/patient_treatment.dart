import 'package:doctor_users/Screens/diagnosis_detail.dart';
import 'package:flutter/material.dart';

class PatientTreatment extends StatelessWidget {
  const PatientTreatment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Treatment"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Card(
                child: Icon(Icons.person, size: 120),
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
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Dispotion",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  GrayCardButtons(
                    title: "Observation",
                    onTap: () {},
                  ),
                  GrayCardButtons(
                    title: "Diagnosis",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiagnosisDetail(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  GrayCardButtons(
                    title: "Medication",
                    onTap: () {},
                  ),
                  GrayCardButtons(
                    title: "Order",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GrayCardButtons extends StatelessWidget {
  const GrayCardButtons({
    required this.onTap,
    required this.title,
    Key? key,
  }) : super(key: key);

  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width * .4,
        height: 200.0,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        color: Colors.black12,
      ),
    );
  }
}
