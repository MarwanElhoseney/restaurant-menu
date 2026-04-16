import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    // TODO: implement initState
    _obscureText = widget.isPassword;
    super.initState();
  }

  void togglePassword() {
    setState(() {});
    _obscureText = !_obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorHeight: 20,
      cursorColor: AppColors.primary,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return "please enter the${widget.hint}";
        }
        return null;
      },
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon:
            widget.isPassword
                ? GestureDetector(
                  onTap: togglePassword,
                  child: Icon(CupertinoIcons.eye, color: AppColors.primary),
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.primary),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
