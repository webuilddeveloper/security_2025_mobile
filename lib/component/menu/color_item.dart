import 'package:flutter/material.dart';

colorItem(
  String title,
  String subTitle,
  String imageUrl,
  int flex, {
  bool titleStart = false,
  Color fontColor = Colors.white,
  Function? callback,
  LinearGradient linearGradient = const LinearGradient(
    colors: [
      Color(0xFFFF8E00),
      Color(0xFFFFC200),
    ],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  ),
}) {
  return Expanded(
    flex: flex,
    child: InkWell(
      onTap: () {
        callback!();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: linearGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Image.asset(
                imageUrl,
                height: 45,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: 'Sarabun',
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: 'Sarabun',
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
