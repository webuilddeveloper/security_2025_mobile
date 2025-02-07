import 'package:security_2025_mobile_v3/component/material/check_avatar.dart';
import 'package:security_2025_mobile_v3/component/material/custom_alert_dialog.dart';
import 'package:security_2025_mobile_v3/pages/behavior_points.dart';
import 'package:security_2025_mobile_v3/pages/profile/drivers_info.dart';
import 'package:security_2025_mobile_v3/pages/profile/id_card_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';

import 'pages/profile/register_with_diver_license.dart';
import 'pages/profile/register_with_license_plate.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.model}) : super(key: key);

  final Future<dynamic> model;
  final storage = new FlutterSecureStorage();

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _buildCard(snapshot.data);
          // if (snapshot.data['idcard'] != '' && snapshot.data['idcard'] != null)
          //   return _buildCard(snapshot.data);
          // else
          //   return _buildCardNotRegister();
        } else if (snapshot.hasError) {
          return BlankLoading(
            width: null,
            height: null,
          );
        } else {
          return BlankLoading(
            width: null,
            height: null,
          );
        }
      },
    );
  }

  _buildCardNotRegister() {
    return Container(
      height: 118,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFBAA6A6),
            Color(0xFF856B6B),
          ],
          begin: Alignment.center,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'กรุณาลงทะเบียนด้วยบัตรประชาชน',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 13,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'เพื่อเชื่อมต่อใบอนุญาตและข้อมูลพาหนะในครอบครอง',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 13,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildDialogRegister();
                  },
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Text(
                  'ลงทะเบียนเพื่อตรวจสอบใบอนุญาต',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 13,
                    color: Color(0xFFFA8500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCard(dynamic model) {
    return Container(
      height: 118,
      color: Colors.white,
      child: Row(
        children: [
          _leftItem(model),
          _rightItem(model),
        ],
      ),
    );
  }

  _leftItem(dynamic model) {
    return Expanded(
      child: InkWell(
        onTap: () {
          model['isDF'] == false
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildDialogdriverLicence();
                  },
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriversInfo(),
                  ),
                );
        },
        child: Container(
          margin: EdgeInsets.only(top: 5, right: 5, bottom: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFAF86B5),
                Color(0xFF7948AD),
              ],
              begin: Alignment.centerLeft,
              // end: new Alignment(1, 0.0),
              end: Alignment.centerRight,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              '${model['imageUrl']}' != '' ? 0.0 : 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xFFFF7900),
                          ),
                          height: 60,
                          width: 60,
                          child: checkAvatar(
                            context,
                            '${model['imageUrl']}',
                          ),
                        ),
                        Expanded(
                          child: model['isDF'] == false
                              ? Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 5.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(48),
                                          color: Colors.white,
                                        ),
                                        width: 100,
                                        height: 20,
                                        child: Text(
                                          'รอยืนยันตัวตน',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFFFF7B06),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'ID Card : ',
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.white,
                                                fontFamily: 'Sarabun'),
                                          ),
                                          Expanded(
                                            child: Text(
                                              model['idcard'] ??
                                                  'กรุณาอัพเดทข้อมูล',
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  color: Colors.white,
                                                  fontFamily: 'Sarabun'),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 5.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'ID Card : ',
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.white,
                                                fontFamily: 'Sarabun'),
                                          ),
                                          Expanded(
                                            child: Text(
                                              model['idcard'] ??
                                                  'กรุณาอัพเดทข้อมูล',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.white,
                                                  fontFamily: 'Sarabun'),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${model['firstName']} ${model['lastName']}',
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.white,
                                            fontFamily: 'Sarabun',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),

                          // model['driverLicence'] == null
                          //     ? Container(
                          //         padding: EdgeInsets.only(
                          //           left: 10,
                          //           right: 10,
                          //           bottom: 5.0,
                          //         ),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //           mainAxisSize: MainAxisSize.max,
                          //           children: [
                          //             Container(
                          //               decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(48),
                          //                 color: Colors.white,
                          //               ),
                          //               width: 100,
                          //               height: 20,
                          //               child: Text(
                          //                 'ท่านไม่มีใบขับขี่',
                          //                 style: TextStyle(
                          //                   fontSize: 15,
                          //                   color: Color(0xFFFF7B06),
                          //                 ),
                          //                 textAlign: TextAlign.center,
                          //               ),
                          //             ),
                          //             SizedBox(height: 10),
                          //             Row(
                          //               children: [
                          //                 Text(
                          //                   'ID Card : ',
                          //                   style: TextStyle(
                          //                       fontSize: 11.0,
                          //                       color: Colors.white,
                          //                       fontFamily: 'Sarabun'),
                          //                 ),
                          //                 Expanded(
                          //                   child: Text(
                          //                     model['idcard'],
                          //                     style: TextStyle(
                          //                         fontSize: 11.0,
                          //                         color: Colors.white,
                          //                         fontFamily: 'Sarabun'),
                          //                     maxLines: 2,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     : Container(
                          //         padding: EdgeInsets.only(
                          //           left: 10,
                          //           right: 10,
                          //           bottom: 5.0,
                          //         ),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //           mainAxisSize: MainAxisSize.max,
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 Text(
                          //                   'ID Card : ',
                          //                   style: TextStyle(
                          //                       fontSize: 13.0,
                          //                       color: Colors.white,
                          //                       fontFamily: 'Sarabun'),
                          //                 ),
                          //                 Expanded(
                          //                   child: Text(
                          //                     model['driverLicence']
                          //                         ['docNo'],
                          //                     style: TextStyle(
                          //                         fontSize: 13.0,
                          //                         color: Colors.white,
                          //                         fontFamily: 'Sarabun'),
                          //                     maxLines: 2,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //             Text(
                          //               '${model['firstName']} ${model['lastName']}',
                          //               style: TextStyle(
                          //                   fontSize: 13.0,
                          //                   color: Colors.white,
                          //                   fontFamily: 'Sarabun',
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        'ดูใบอนุญาตทั้งหมด',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                          fontFamily: 'Sarabun',
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _rightItem(dynamic model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BehaviorPoints(),
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ComingSoon(code: 'N1'),
        //   ),
        // );
      },
      child: Container(
        width: 118,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFEBE2C),
              Color(0xFFFD8E25),
            ],
            begin: Alignment.centerRight,
            // end: new Alignment(1, 0.0),
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'สถานะการขับขี่',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '80',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'เต็ม 100 คะแนน',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontFamily: 'Sarabun',
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDialogRegister() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: CustomAlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Container(
          width: 325,
          height: 300,
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
                  'assets/check_register.png',
                  height: 50,
                ),
                // Icon(
                //   Icons.check_circle_outline_outlined,
                //   color: Color(0xFF5AAC68),
                //   size: 60,
                // ),
                SizedBox(height: 10),
                Text(
                  'ยืนยันตัวตน',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 15,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'กรุณาลงทะเบียนด้วยบัตรประชาชน',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 13,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  'เพื่อเชื่อมต่อใบอนุญาต และข้อมูลพาหนะในครอบครอง',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 13,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                SizedBox(height: 50),
                Container(height: 0.5, color: Color(0xFFcfcfcf)),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IDCardVerification(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      'ลงทะเบียนเพื่อตรวจสอบใบอนุญาต',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 13,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                  ),
                ),
                Container(height: 0.5, color: Color(0xFFcfcfcf)),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(0xFF9C0000),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 13,
                        color: Color(0xFF9C0000),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          // child: //Contents here
        ),
      ),
    );
  }

  _buildDialogdriverLicence() {
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
                  'assets/check_register.png',
                  height: 50,
                ),
                // Icon(
                //   Icons.check_circle_outline_outlined,
                //   color: Color(0xFF5AAC68),
                //   size: 60,
                // ),
                SizedBox(height: 10),
                Text(
                  'ยืนยันตัวตน',
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
                    // Navigator.pop(context,false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterWithDriverLicense(),
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
                    // Navigator.pop(context,false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterWithLicensePlate(),
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
  }
}
