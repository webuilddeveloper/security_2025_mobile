import 'package:flutter/material.dart';

fontCus(String title,
    {FontWeight fontWeight = FontWeight.normal,
    double fontSize = 11.0,
    Color color = Colors.black,
    int maxLines = 1,
    TextOverflow textOverflow = TextOverflow.ellipsis,
    required TextStyle style,
    required TextAlign textAlign}) {
  var defaultStyle = TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: 'Sarabun',
  );
  return Text(
    title,
    style: defaultStyle.merge(style),
    maxLines: maxLines,
    overflow: textOverflow,
    textAlign: textAlign,
  );
}
