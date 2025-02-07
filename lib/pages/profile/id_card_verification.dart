import 'package:security_2025_mobile_v3/component/material/custom_alert_dialog.dart';
import 'package:security_2025_mobile_v3/component/material/field_item.dart';
import 'package:security_2025_mobile_v3/home_v2.dart';
import 'package:security_2025_mobile_v3/pages/profile/register_with_diver_license.dart';
import 'package:security_2025_mobile_v3/pages/profile/register_with_license_plate.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:intl/intl.dart';

class IDCardVerification extends StatefulWidget {
  @override
  _IDCardVerificationPageState createState() => _IDCardVerificationPageState();
}

class _IDCardVerificationPageState extends State<IDCardVerification> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TextEditingController idCard = new TextEditingController();
  TextEditingController birthDay = new TextEditingController();
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController laserID = new TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  TextEditingController txtDate = TextEditingController();
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
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
      }, title: 'เพิ่มข้อมูลบัตรประชาชน', rightButton: null),
      backgroundColor: Color(0xFFF5F8FB),
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: screen(),
      ),
    );
  }

  screen() {
    return SingleChildScrollView(
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    width: double.infinity,
                    child: Image.asset(
                      'assets/Artboard.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 34,
                  child: Text(
                    'กรุณากรอกข้อมูลตามบัตรประชาชนเพื่อทำการยืนยันตัวตน',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 13,
                    ),
                  ),
                )
              ],
            ),
          ),
          fieldItem(
            title: 'เลขประจำตัวประชาชน',
            hintText: 'กรอกเลขประจำตัวประชาชน',
            controller: idCard,
            inputFormatters: [
              // fixflutter2 new WhitelistingTextInputFormatter(RegExp("[0-9]")),
              new LengthLimitingTextInputFormatter(13),
            ],
            textInputType: null,
            validator: null,
            onChanged: null,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
              dialogOpenPickerDate();
            },
            child: AbsorbPointer(
              child: fieldDate(
                title: 'วัน/เดือน/ปีเกิด',
                hintText: 'วัน/เดือน/ปีเกิด',
                controller: birthDay,
                textInputType: null,
                validator: null,
                onChanged: null,
                inputFormatters: [],
              ),
            ),
          ),
          fieldItem(
            title: 'ชื่อ',
            hintText: 'กรอกชื่อ',
            controller: firstName,
            textInputType: TextInputType.name,
            inputFormatters: [
              // FilteringTextInputFormatter.deny(RegExp('[@#_+!.]'))
            ],
            validator: null,
            onChanged: null,
          ),
          fieldItem(
            title: 'นามสกุล',
            hintText: 'กรอกนามสกุล',
            controller: lastName,
            textInputType: null,
            validator: null,
            onChanged: null,
            inputFormatters: [],
          ),
          fieldItem(
            title: 'laser ID',
            hintText: 'กรอก laser ID',
            controller: laserID,
            inputFormatters: [
              // fixflutter2 new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
              new UpperCaseTextFormatter(),
              new LengthLimitingTextInputFormatter(12),
            ],
            textInputType: null, validator: null, onChanged: null,
            // textInputType: TextInputType.numberWithOptions(),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: Color(0xFFA2A2A2),
                    borderRadius: BorderRadius.circular(4.5),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Laser ID คือรหัสหลังบัตรประชาชนโดย 2 หลักแรกเป็นตัวอักษร',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 12,
                    color: Color(0xFFA2A2A2),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 140,
          ),
          InkWell(
            onTap: () {
              dialogVerification();
            },
            child: Container(
              height: 45,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF9C0000),
              ),
              child: Text(
                'ตรวจสอบ',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> dialogVerification() async {
    if (idCard.text == '' ||
        firstName.text == '' ||
        lastName.text == '' ||
        laserID.text == '' ||
        _selectedYear == 0 ||
        _selectedMonth == 0 ||
        _selectedDay == 0) {
      // toastFail(context, text: 'กรุณากรอกข้อมูลให้ครบถ้วน');
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CustomAlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Container(
                width: 325,
                height: 300,
                // width: MediaQuery.of(context).size.width / 1.3,
                // height: MediaQuery.of(context).size.height / 2.5,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/cross_ quadrangle.png',
                        height: 50,
                      ),
                      // Icon(
                      //   Icons.check_circle_outline_outlined,
                      //   color: Color(0xFF5AAC68),
                      //   size: 60,
                      // ),
                      SizedBox(height: 10),
                      Text(
                        'กรุณากรอกข้อมูลให้ครบถ้วน',
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 15,
                          // color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'กรุณายืนยันตัวผ่านตัวเลือกดังต่อไปนี้',
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 15,
                          color: Color(0xFF4D4D4D),
                        ),
                      ),
                      SizedBox(height: 28),
                      Container(height: 0.5, color: Color(0xFFcfcfcf)),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            'ลองใหม่อีกครั้ง',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              color: Color(0xFF4D4D4D),
                            ),
                          ),
                        ),
                      ),
                      Container(height: 0.5, color: Color(0xFFcfcfcf)),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              color: Color(0xFF9C0000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // child: //Contents here
              ),
            ),
          );
        },
      );
    } else {
      String? profileCode = await storage.read(key: 'profileCode3');
      if (profileCode != '' && profileCode != null) {
        final result =
            await postObjectDataMW(serverMW + 'DOPA/ReadVerifyCard', {
          'code': profileCode,
          'createBy': profileCode,
          'updateBy': profileCode,
          'pid': idCard.text,
          'fname': firstName.text,
          'lname': lastName.text,
          'laserID': laserID.text,
          'birthDay': DateFormat("yyyyMMdd").format(
            DateTime(
              _selectedYear,
              _selectedMonth,
              _selectedDay,
            ),
          ),
        });

        if (result['status'] == 'S') {
          storage.write(
            key: 'idcard',
            value: idCard.text,
          );
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CustomAlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    width: 325,
                    height: 300,
                    // width: MediaQuery.of(context).size.width / 1.3,
                    // height: MediaQuery.of(context).size.height / 2.5,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color(0xFFFFFF),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/check_circle.png',
                            height: 50,
                          ),
                          // Icon(
                          //   Icons.check_circle_outline_outlined,
                          //   color: Color(0xFF5AAC68),
                          //   size: 60,
                          // ),
                          SizedBox(height: 10),
                          Text(
                            'เชื่อมต่อบัตรประชาชนสำเร็จ',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'กรุณายืนยันตัวผ่านตัวเลือกดังต่อไปนี้',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              color: Color(0xFF4D4D4D),
                            ),
                          ),
                          SizedBox(height: 28),
                          Container(height: 0.5, color: Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterWithDriverLicense(),
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                'ยืนยันตัวตนผ่านใบขับขี่',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF4D4D4D),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterWithLicensePlate(),
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                'ยืนยันตัวตนผ่านทะเบียนรถที่ครอบครอง',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF4D4D4D),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePageV2(),
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                'ยังไม่ยืนยันตัวตน กลับหน้าหลัก',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF9C0000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // child: //Contents here
                  ),
                ),
              );
            },
          );
        } else {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CustomAlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    width: 325,
                    height: 300,
                    // width: MediaQuery.of(context).size.width / 1.3,
                    // height: MediaQuery.of(context).size.height / 2.5,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color(0xFFFFFF),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/cross_ quadrangle.png',
                            height: 50,
                          ),
                          // Icon(
                          //   Icons.check_circle_outline_outlined,
                          //   color: Color(0xFF5AAC68),
                          //   size: 60,
                          // ),
                          SizedBox(height: 10),
                          Text(
                            'เชื่อมต่อบัตรประชาชนไม่สำเร็จ',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'กรุณายืนยันตัวผ่านตัวเลือกดังต่อไปนี้',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              color: Color(0xFF4D4D4D),
                            ),
                          ),
                          SizedBox(height: 28),
                          Container(height: 0.5, color: Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                'ลองใหม่อีกครั้ง',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF4D4D4D),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                'ยกเลิก',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF9C0000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // child: //Contents here
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }

  dialogOpenPickerDate() {
    dt_picker.DatePicker.showDatePicker(context,
        theme: dt_picker.DatePickerTheme(
          containerHeight: 210.0,
          itemStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
          doneStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
          cancelStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
        ),
        showTitleActions: true,
        minTime: DateTime(1800, 1, 1),
        maxTime: DateTime(year, month, day), onConfirm: (date) {
      setState(
        () {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          birthDay.value = TextEditingValue(
            text: DateFormat("dd-MM-yyyy").format(date),
          );
        },
      );
    },
        currentTime: DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
        locale: dt_picker.LocaleType.th);
  }

  fieldDate({
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
                controller: controller,
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
                // controller: controller,
                // enabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
