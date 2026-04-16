import 'package:flutter/material.dart';

class CustomUserTextField extends StatelessWidget {
  CustomUserTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      cursorWidth: 20,
      style: TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
