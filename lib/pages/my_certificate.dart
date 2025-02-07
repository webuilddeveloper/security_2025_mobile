import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyCertificate extends StatefulWidget {
  MyCertificate({Key? key, this.model, required this.changePage})
      : super(key: key);

  dynamic model;
  Function changePage;

  @override
  _MyCertificate createState() => _MyCertificate();
}

class _MyCertificate extends State<MyCertificate> {
  bool showCalendar = false;
  final storage = new FlutterSecureStorage();
  late Future<dynamic> _futureProfile;
  String profileCode = '';
  int selectedIndex = 0;
  dynamic dataMook = [
    {"code": 0, "title": 'ประกาศนียบัตรฝ่ายนายท้ายเรือ'},
    {"code": 0, "title": 'ประกาศนียบัตรฝ่ายช่างกลเรือ'},
  ];

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
                  widget.changePage(0);
                  // Navigator.pop(context);
                },
                child: Container(
                  // alignment: Alignment.center,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Color(0XFF0C387D),
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
                  'ใบอนุญาตของฉัน',
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
            Positioned(
              top: 0,
              child: Container(
                color: Color(0XFFF3F5F5),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    _category(),
                    SizedBox(height: 20),
                    _certificate(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: _certificateInFo(),
            ),
          ],
        ),
      ),
    );
  }

  _category() {
    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataMook.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: index == selectedIndex
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                border: Border.all(
                  color: index == selectedIndex
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                dataMook[index]['title'],
                style: TextStyle(
                  color: index == selectedIndex
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Noto Sans Thai',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _certificate() {
    return Image.network(
        'https://khubdeedlt.we-builds.com/khubdeedlt-document/images/splash/splash_241045816.png');
  }

  _certificateInFo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'ประกาศนียบัตร',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF0C387D),
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'นายท้ายเรือกลเดินทะเลชั้นสอง',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF0C387D),
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'สถานะใบอนุญาตใช้เรือ',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0XFF000000),
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
                    color: Color(0XFF0C7D30),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'ปกติ',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0XFFFFFFFF),
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'วันออกใบอนุญาต',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0XFF000000),
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
                    color: Color(0XFF000000),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'วันหมดอายุ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0XFF000000),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '01/11/2568',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0XFF000000),
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
  }
}
