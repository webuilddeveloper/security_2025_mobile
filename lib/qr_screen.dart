import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:security_2025_mobile_v3/component/material/check_avatar.dart';

class QrScreen extends StatefulWidget {
  QrScreen({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  _QrScreen createState() => _QrScreen();
}

class _QrScreen extends State<QrScreen> {
  bool showCalendar = false;

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final Uri qrUri = Uri(
      scheme: "http",
      host: "gateway.we-builds.com",
      path: "security_information.html",
      queryParameters: item,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0XFFF3F5F5),
        elevation: 0.0,
        titleSpacing: 5,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 35,
                  decoration: BoxDecoration(
                    color: Color(0XFFB03432),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Qr code ของฉัน',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0XFFF3F5F5),
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: QrImageView(
                  data: qrUri.toString(),
                  size: 250,
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0XFFB03432),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                "assets/images/bg_buttom_qr_code.png",
                height: MediaQuery.of(context).size.height * 0.47,
                width: MediaQuery.of(context).size.width,
                color: Color(0XFFB03432),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //   height: 80,
                      //   width: 80,
                      //   child: checkAvatar(
                      //     context,
                      //     item['image'],
                      //   ),
                      // ),
                      Container(
                        height: 85,
                        width: 85,
                        padding: EdgeInsets.only(right: 10),
                        child: item["image"] != ''
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                    item["image"]!), // Use AssetImage
                              )
                            : Container(
                                padding: EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/images/user_not_found.png',
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0XFFF5F5F5),
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'สมรรถภาพทางกาย',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'ผ่านเกณฑ์',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'สถานะการอบรม',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                'เข้ารับและผ่านการอบรม',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0XFF000000),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'สถานะใบอนุญาต',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                'มีใบอนุญาตเป็นพนักงาน',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0XFF000000),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'วันออกใบอนุญาต',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              // '01/11/2563',
                              item['issue_date'],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'วันหมดอายุ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              // '01/11/2566',
                              item['expiry_date'],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
