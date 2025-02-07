import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:security_2025_mobile_v3/component/button_close_back.dart';
import 'package:security_2025_mobile_v3/component/carousel_form.dart';
import 'package:security_2025_mobile_v3/component/link_url_in.dart';
import 'package:security_2025_mobile_v3/pages/main_popup/mainpop_up_form.dart';

class MainPopupDialog extends StatefulWidget {
  MainPopupDialog(
      {Key? key,
      required this.model,
      required this.url,
      required this.urlGallery,
      required this.type,
      required this.username})
      : super(key: key);

  final Future<dynamic> model;
  final String? urlGallery;
  final String? url;
  final String? type;
  final String? username;

  @override
  _MainPopupDialogState createState() => new _MainPopupDialogState();
}

class _MainPopupDialogState extends State<MainPopupDialog> {
  final storage = new FlutterSecureStorage();

  bool notShowOnDay = false;

  void setHiddenMainPopup() async {
    this.setState(() {
      notShowOnDay = !notShowOnDay;
    });

    var value = await storage.read(key: widget.type! + 'DDPM');
    var dataValue;
    if (value != null) {
      dataValue = json.decode(value);
    } else {
      dataValue = null;
    }

    var now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    if (dataValue != null) {
      var index = dataValue.indexWhere((c) => c['username'] == widget.username);

      if (index == -1) {
        dataValue.add({
          'boolean': notShowOnDay.toString(),
          'username': widget.username,
          'date': DateFormat("ddMMyyyy").format(date).toString(),
        });

        await storage.write(
          key: widget.type! + 'DDPM',
          value: jsonEncode(dataValue),
        );
      } else {
        dataValue[index]['boolean'] = dataValue[index]['boolean'] == "true"
            ? "true"
            : notShowOnDay.toString();
        dataValue[index]['username'] = widget.username;
        dataValue[index]['date'] =
            DateFormat("ddMMyyyy").format(date).toString();

        await storage.write(
          key: widget.type! + 'DDPM',
          value: jsonEncode(dataValue),
        );
      }
    } else {
      var itemData = [
        {
          'boolean': notShowOnDay.toString(),
          'username': widget.username,
          'date': DateFormat("ddMMyyyy").format(date).toString(),
        },
      ];

      await storage.write(
        key: widget.type! + 'DDPM',
        value: jsonEncode(itemData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        height: MediaQuery.of(context).size.height * 0.8,
        width: width,
        child: Column(
          children: [
            Container(
              child: Container(
                child: buttonCloseBack(context),
              ),
              alignment: Alignment.topRight,
            ),
            MainPopup(
              model: widget.model,
              nav: (String path, String action, dynamic model, String code,
                  String urlGallery) {
                if (action == 'out') {
                  launchInWebViewWithJavaScript(path);
                  // launchURL(path);
                } else if (action == 'in') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarouselForm(
                        code: code,
                        model: model,
                        url: widget.url!,
                        urlGallery: widget.urlGallery!,
                      ),
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0),
                  child: InkWell(
                    onTap: () => {setHiddenMainPopup()},
                    child: new Icon(
                      !notShowOnDay
                          ? Icons.check_box_outline_blank
                          : Icons.check_box,
                      color: Colors.lightGreenAccent,
                      size: 40.0,
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                  child: InkWell(
                    onTap: () => {setHiddenMainPopup()},
                    child: Text(
                      'ไม่ต้องแสดงเนื้อหาอีกภายในวันนี้',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Sarabun',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
