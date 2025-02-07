import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/splash.dart';

dialogFail(BuildContext context,
    {String title = 'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
    bool reloadApp = false}) {
  return WillPopScope(
    onWillPop: () {
      return Future.value(reloadApp);
    },
    child: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: CupertinoAlertDialog(
        title: new Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Sarabun',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Sarabun',
                color: Color(0xFFFF7514),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              reloadApp
                  ? Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => SplashPage(),
                      ),
                      (Route<dynamic> route) => false,
                    )
                  : Navigator.pop(context, false);
            },
          ),
        ],
      ),
    ),
  );
}
