// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doctor_users/Screens/Homepage.dart';
// import 'package:doctor_users/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../Functions/firebase_auth.dart';
// import '../Widgets/widgets.dart';

// class NewToTheHospital extends StatefulWidget {
//   const NewToTheHospital({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<NewToTheHospital> createState() => _NewToTheHospitalState();
// }

// class _NewToTheHospitalState extends State<NewToTheHospital> {
//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const SizedBox(height: 150),
//         CustomeTextField(
//           controller: fullNameController,
//           hintText: "Full name",
//           keyboardType: TextInputType.name,
//         ),
//         CustomeTextField(
//           controller: emailController,
//           hintText: "Email",
//           keyboardType: TextInputType.emailAddress,
//         ),
//         CustomeTextField(
//           controller: passwordController,
//           hintText: "Password",
//           obscureText: true,
//         ),
//         // CustomeTextField(
//         //   controller: phoneNumberController,
//         //   hintText: "Phone Number",
//         //   keyboardType: TextInputType.phone,
//         // ),
//         const SizedBox(height: 10.0),
//         ContainerRoundedButton(
//           onTap: () async {
//             String? result = await context.read<AuthenticationService>().signUp(
//                 email: emailController.text.trim(),
//                 password: passwordController.text.trim());
//             if (result == "sign up successful") {
//               final firestore = FirebaseFirestore.instance;
//               final auth = FirebaseAuth.instance;
//               final currentUserID = auth.currentUser!.uid;
//               await firestore
//                   .collection("doctors")
//                   .doc(currentUserID)
//                   .set(Doctor(
//                     id: currentUserID,
//                     immadiatePatientId: [],
//                     requestPatientId: [],
//                     lastMessageTime: Timestamp.now(),
//                     name: fullNameController.text,
//                   ).toJson());
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const HomePage(),
//                 ),
//               );
//             }
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(result!)));
//           },
//           mainText: "Register",
//         ),
//         const SizedBox(height: 100.0),
//         // TextButton(
//         //   onPressed: () {
//         //     Navigator.push(context,
//         //         MaterialPageRoute(builder: (context) => const LoginScreen()));
//         //   },
//         //   child: const Text("login"),
//         // ),
//       ],
//     );
//   }
// }
