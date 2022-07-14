import 'package:doctor_users/Functions/firebase_auth.dart';
import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/Screens/Homepage.dart';
import 'package:doctor_users/Screens/Login.dart';
import 'package:doctor_users/models/provider_patient_doctor.dart';
import 'package:doctor_users/models/provider_pharma_drug.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context)=>FirebaseApi()),
        ChangeNotifierProvider(create: (BuildContext context)=>PharmaCheck()),
        ChangeNotifierProvider(create: (BuildContext context)=>PharmaDrug()),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(create: ((context) => context.read<AuthenticationService>().authStateChanges), initialData: null),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if(firebaseUser!=null){
      return const HomePage();
    }else{
      return const LoginScreen();
    }
  }
}
