import 'package:flutter/material.dart';

header() {
  return AppBar(
    backgroundColor: Color(0xFFFF7900),
    title: Row(
      children: [
        Image.asset(
          'assets/logo/logo.png',
          height: 50,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 10,
          ),
          child: Text(
            'Smart Security',
            style: TextStyle(
              fontFamily: 'Sarabun',
            ),
          ),
        )
      ],
    ),
  );
}
