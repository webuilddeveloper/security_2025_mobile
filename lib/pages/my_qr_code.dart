import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/component/material/check_avatar.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class MyQrCode extends StatefulWidget {
  MyQrCode({Key? key, this.model, required this.changePage}) : super(key: key);

  dynamic model;
  Function changePage;

  @override
  _MyQrCode createState() => _MyQrCode();
}

class _MyQrCode extends State<MyQrCode> {
  bool showCalendar = false;
  final storage = new FlutterSecureStorage();
  late Future<dynamic> _futureProfile;
  String profileCode = '';

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode3'))!;
    if (profileCode != '') {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
    }
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.changePage(0);
                  // Navigator.pop(context);
                },
                child: Container(
                  // alignment: Alignment.center,
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
                  'คิวอาโค้ดของฉัน',
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
                child: Image.asset(
                  'assets/images/my_qr_code.png',
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.3,
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
                child: FutureBuilder<dynamic>(
                  future: _futureProfile,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (profileCode == snapshot.data['code']) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                child: checkAvatar(
                                    context, '${snapshot.data['imageUrl']}'),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${snapshot.data['firstName'] ?? ''} ${snapshot.data['lastName'] ?? ''}',
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      '01/11/2563',
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
                                      '01/11/2566',
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
                        );
                      } else {
                        return BlankLoading(
                          height: 80,
                          width: 80,
                        );
                      }
                    } else if (snapshot.hasError) {
                      return BlankLoading(
                        height: 80,
                        width: 80,
                      );
                    } else {
                      return BlankLoading(
                        height: 80,
                        width: 80,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
