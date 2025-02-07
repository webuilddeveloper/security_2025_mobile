import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dialog(BuildContext context,
    {required String title,
    required String description,
    bool isYesNo = false,
    required Function callBack}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Sarabun',
              color: Colors.red,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            if (isYesNo)
              Container(
                child: CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ยกเลิก",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Sarabun',
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
            Container(
              child: CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Sarabun',
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  if (isYesNo) {
                    callBack();
                    Navigator.pop(context, false);
                  } else {
                    Navigator.pop(context, false);
                  }
                },
              ),
            ),
          ],
        );
      });
}
