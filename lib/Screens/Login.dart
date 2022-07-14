import 'package:doctor_users/Functions/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../Constants/colors.dart';
import '../Widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool inAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLoginRegisterColor,
        title: const Text("Login"),
        centerTitle: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomeTextField(
                  controller: emailController,
                  hintText: "Enter your email or phone number..."),
              const SizedBox(height: 5.0),
              CustomeTextField(
                  obscureText: true,
                  controller: passwordController,
                  hintText: "Enter your password..."),
              const SizedBox(height: 45.0),
              ContainerRoundedButton(
                mainText: "Login",
                onTap: () async {
                  setState(() {
                    inAsyncCall = true;
                  });
                  String? result = await context
                      .read<AuthenticationService>()
                      .signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result!)));
                      setState(() {
                    inAsyncCall = false;
                  });
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}