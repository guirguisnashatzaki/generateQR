import 'package:flutter/material.dart';

class customTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final Widget icon;
  final bool isPass;
  bool isShown = false;
  customTextFormField({
    super.key,
    required this.controller,
    required this.icon,
    required this.text,
    required this.isPass
  });

  @override
  State<customTextFormField> createState() => _customTextFormFieldState();
}

class _customTextFormFieldState extends State<customTextFormField> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          keyboardType: widget.isPass ? TextInputType.number:TextInputType.text,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              prefixIcon: widget.icon,
              label: Text(widget.text),
              labelStyle: const TextStyle(
                color: Colors.grey
              ),
          ),
          textInputAction: TextInputAction.next,
          controller: widget.controller,
        ),
      ),
    );
  }
}