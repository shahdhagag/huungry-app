import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    required this.isPassword,
    required this.controller,
  });

  final String hint;
  final bool isPassword;
  final TextEditingController controller;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    // TODO: implement activate
    _obscureText = widget.isPassword;

    super.initState();
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      cursorHeight: 20,
      cursorColor: AppColors.primary,
      validator: (v) {
        if(v ==null || v.isEmpty){
          return "please fill ${widget.hint}";
        }
        null;
      },
      obscureText: _obscureText,

      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? GestureDetector(onTap: () {},
            child: Icon(CupertinoIcons.eye , color: Colors.white,))
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),

        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.white

        ),
        fillColor: Colors.transparent,
        filled: true,
      ),
    );
  }
}
