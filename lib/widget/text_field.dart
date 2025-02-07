import 'package:flutter/material.dart';

labelTextField(String label, Icon icon) {
  return Row(
    children: <Widget>[
      icon,
      Text(
        ' ' + label,
        style: TextStyle(
          fontSize: 15.000,
          fontFamily: 'Sarabun',
        ),
      ),
    ],
  );
}

textField(
  TextEditingController model,
  TextEditingController? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return SizedBox(
    height: 45.0,
    child: TextField(
      // keyboardType: TextInputType.number,
      obscureText: isPassword,
      controller: model,
      enabled: enabled,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: 'Sarabun',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFC5DAFC),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
