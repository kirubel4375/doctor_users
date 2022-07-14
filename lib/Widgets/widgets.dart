import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class CustomeTextField extends StatelessWidget {
  const CustomeTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    this.keyboardType,
  }) : super(key: key);
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0).copyWith(bottom: 5.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerRoundedButton extends StatelessWidget {
  const ContainerRoundedButton({
    Key? key,
    this.onTap,
    required this.mainText,
  }) : super(key: key);
  final Function()? onTap;
  final String mainText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
        width: 240.0,
        decoration: const BoxDecoration(
          color: kLoginRegisterColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Center(
          child: Text(
            mainText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}