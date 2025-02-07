import 'package:flutter/material.dart';

itemSwitch({
  required BuildContext context,
  String title = '',
  bool value = false,
  double fontSize = 12,
  Color activeTrackColor = const Color(0xFF9488A5),
  Color activeColor = const Color(0xFF583B80),
  Color fontColor = const Color(0xFF583B80),
  required Function callback,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
      ),
    ),
    alignment: Alignment.centerLeft,
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text(
              title,
              style: new TextStyle(
                fontSize: fontSize,
                color: fontColor,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
        Container(
          width: 100.0,
          height: 40.0,
          alignment: Alignment.centerRight,
          child: Switch(
            value: value,
            onChanged: (change) {
              callback(change);
            },
            activeTrackColor: activeTrackColor,
            activeColor: activeColor,
          ),
        ),
      ],
    ),
  );
}
