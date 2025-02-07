import 'package:security_2025_mobile_v3/pages/blank_page/toast_fail.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class IDCardInfo extends StatefulWidget {
  @override
  _IDCardInfoPageState createState() => _IDCardInfoPageState();
}

class _IDCardInfoPageState extends State<IDCardInfo> {
  late Future<dynamic> futureModel;
  final storage = new FlutterSecureStorage();
  String profileCode = '';
  @override
  void initState() {
    read();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, () {
        Navigator.pop(context, false);
      }, title: 'ข้อมูลบัตรประชาชน', rightButton: null),
      backgroundColor: Colors.white,
      body: _futureBuilder(),
    );
  }

  _futureBuilder() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _screen(snapshot.data);
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _screen(model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 240,
            color: Color(0xFFDFCDCA),
            child: Column(
              children: [
                SizedBox(
                  height: 34,
                ),
                Expanded(
                  child: Container(
                    child: Image.asset(
                      'assets/ex_id_card.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 34,
                )
              ],
            ),
          ),
          Container(
            height: 35,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  height: 9,
                  width: 9,
                  decoration: BoxDecoration(
                    color: Color(0xFF00992D),
                    borderRadius: BorderRadius.circular(4.5),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'ยืนยันตัวตนแล้ว',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                    fontSize: 13.0,
                    color: Color(0xFF00992D),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 35,
            width: double.infinity,
            color: Color(0xFFEDF0F3),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ข้อมูลบัตรประจำตัวประชาชน',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                    fontSize: 13.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    deleteIdCard();
                    // toastFail(context, text: 'delete complete');
                  },
                  child: Image.asset(
                    'assets/trash.png',
                    width: 20,
                    height: 23,
                  ),
                ),
              ],
            ),
          ),
          fieldItemDisable(
            title: 'เลขประจำตัวประชาชน',
            value: model['idcard'],
          ),
          fieldItemDisable(
            title: 'วัน/เดือน/ปีเกิด',
            value: DateFormat("dd MMMM yyyy").format(
              DateTime(
                int.parse(model['birthDay'].substring(0, 4)),
                int.parse(model['birthDay'].substring(4, 6)),
                int.parse(model['birthDay'].substring(6, 8)),
              ),
            ),
          ),
          fieldItemDisable(
            title: 'ชื่อ',
            value: model['firstName'],
          ),
          fieldItemDisable(
            title: 'นามสกุล',
            value: model['lastName'],
          ),
          SizedBox(
            height: 160,
          ),
        ],
      ),
    );
  }

  fieldItemDisable({
    String title = '',
    String value = '',
  }) {
    return Container(
      color: Color(0xFFF5F8FB),
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              new Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sarabun',
                  fontSize: 13.0,
                  color: Color(0xFFA8A8A8),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sarabun',
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // function
  read() async {
    profileCode = (await storage.read(key: 'profileCode3'))!;
    if (profileCode != '') {
      setState(() {
        futureModel = postDio(profileReadApi, {"code": profileCode});
      });
    }
  }

  deleteIdCard() {
    dialog(context,
        title: 'แจ้งเตือน',
        description: 'ยืนยันการลบข้อมูลบัตร',
        isYesNo: true, callBack: () async {
      postDio('${serverMW}DOPA/deleteIdCard', {
        "code": profileCode,
        "": {"updateBy": profileCode}
      });

      storage.write(
        key: 'idcard',
        value: '',
      );
      toastFail(context, text: 'delete complete');
      Navigator.pop(context, false);
    });
  }
}
