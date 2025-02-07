import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';

blankMenu(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double statusBarHeight = MediaQuery.of(context).padding.top;
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          height: statusBarHeight + (height * 9) / 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF000070),
                Color(0xFF000070),
              ],
              begin: Alignment.topCenter,
              end: new Alignment(0.6, 0.0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    top: statusBarHeight,
                    left: width * 5 / 100,
                    right: width * 5 / 100,
                    bottom: 5.0),
                color: Colors.transparent,
                child: Image.asset(
                  'assets/logo/logo.png',
                  height: (height * 7) / 100,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: statusBarHeight),
                child: Text(
                  'Smart Security',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: (height * 2.5 / 100),
                      color: Colors.white,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
        BlankLoading(
          width: width,
          height: height * 18 / 100,
        ),
        BlankLoading(
          width: width,
          height: height * 16 / 100,
        ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          children: [
            BlankLoading(
              width: width * 33.3 / 100,
              height: width * 33.3 / 100,
            ),
            BlankLoading(
              width: width * 33.3 / 100,
              height: width * 33.3 / 100,
            ),
            BlankLoading(
              width: width * 33.3 / 100,
              height: width * 33.3 / 100,
            ),
          ],
        ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          children: [
            BlankLoading(
              width: width * 33.3 / 100,
              height: width * 33.3 / 100,
            ),
            BlankLoading(
              width: width * 33.3 / 100,
              height: width * 33.3 / 100,
            ),
            BlankLoading(
              width: width * 33.3 / 100,
              height: width * 33.3 / 100,
            ),
          ],
        ),
        SizedBox(
          height: 3.0,
        ),
        BlankLoading(
          width: width,
          height: width * 33.3 / 100,
        ),
        BlankLoading(
          width: width,
          height: width * 33.3 / 100,
        ),
        BlankLoading(
          width: width,
          height: width * 33.3 / 100,
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );
}
