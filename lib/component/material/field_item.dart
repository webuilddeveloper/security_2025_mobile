import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

fieldItem({
  String? title = '',
  String? value = '',
  String? hintText = '',
  required TextInputType? textInputType,
  required Function? validator,
  required Function? onChanged,
  required TextEditingController controller,
  required List<TextInputFormatter> inputFormatters,
}) {
  return Container(
    color: Colors.white,
    height: 35,
    // alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 10),
    margin: EdgeInsets.only(bottom: 1),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            new Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
                fontSize: 13.0,
              ),
            ),
            Text(
              '*',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: TextFormField(
              inputFormatters: inputFormatters,
              textAlign: TextAlign.right,
              keyboardType: textInputType,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
                fontSize: 13.0,
              ),
              decoration: new InputDecoration.collapsed(
                hintText: hintText,
              ),
              validator: (model) {
                return validator!(model);
              },
              onChanged: (value) => onChanged!(value),
              // initialValue: value,
              controller: controller,
              // enabled: true,
            ),
          ),
        ),
      ],
    ),
  );
}
