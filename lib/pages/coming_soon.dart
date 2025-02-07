import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ComingSoon extends StatefulWidget {
  ComingSoon({Key? key, this.model}) : super(key: key);

  dynamic model;

  @override
  _ComingSoon createState() => _ComingSoon();
}

class _ComingSoon extends State<ComingSoon> {
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
    // profileCode = await storage.read(key: 'profileCode3');
    // if (profileCode != '' && profileCode != null) {
    //   setState(() {
    //     _futureProfile = postDio(profileReadApi, {"code": profileCode});
    //   });
    // }
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
                  Navigator.pop(context);
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
                  '',
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
        child: Container(
          color: Color(0XFFF3F5F5),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.update_outlined,
                size: 200,
                // color: Colors(0XFF252120),
              ),
              Text(
                'เตรียมพบกันเร็วๆ นี้',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: 250,
                  decoration: BoxDecoration(
                    color: Color(0XFFB03432),
                    borderRadius: BorderRadius.circular(47),
                  ),
                  child: Text(
                    'กลับหน้าหลัก',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
