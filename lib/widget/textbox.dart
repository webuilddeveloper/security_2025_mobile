import 'package:security_2025_mobile_v3/widget/text_form_field.dart';
import 'package:flutter/material.dart';

textbox(
    {TextEditingController? controller,
    String title = '',
    bool enabled = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      labelTextFormField(title),
      // Text(
      //   title,
      //   style: TextStyle(
      //     fontSize: 18.00,
      //     fontFamily: 'Sarabun',
      //     fontWeight: FontWeight.w500,
      //     // color: Color(0xFFBC0611),
      //   ),
      // ),
      SizedBox(height: 2.0),
      // labelTextFormField('* ชื่อผู้ใช้งาน'),
      textFormField(
        controller!,
        null,
        title,
        title,
        enabled,
        false,
        false,
      ),
    ],
  );
}
