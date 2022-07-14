import 'package:doctor_users/Screens/new_patients.dart';
import 'package:doctor_users/Screens/patient_list_screen.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 130),
        BigRoundedButton(
          onCall: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewPatient()));
          },
          text: "New Patient",
        ),
        BigRoundedButton(
          onCall: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PatientsList()));
          },
          text: "My Patient",
        ),
      ],
    );
  }
}

class BigRoundedButton extends StatelessWidget {
  const BigRoundedButton({
    Key? key,
    required this.text,
    @required this.onCall,
  }) : super(key: key);

  final String text;
  final Function()? onCall;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCall,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        height: 90,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        decoration: const BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
