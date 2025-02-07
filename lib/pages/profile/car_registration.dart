import 'package:security_2025_mobile_v3/pages/notification/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'car_registration_des.dart';
import 'vehicle_inspectio.dart';

class CarRegistration extends StatefulWidget {
  CarRegistration({Key? key, required this.type}) : super(key: key);

  final String type;
  @override
  _CarRegistrationPageState createState() => _CarRegistrationPageState();
}

class _CarRegistrationPageState extends State<CarRegistration> {
  late Future<dynamic> _futureModel;
  final storage = new FlutterSecureStorage();
  dynamic tempData;
  dynamic categoryList = [
    {'title': '1', 'value': 0},
    {'title': '2', 'value': 1},
    {'title': '3', 'value': 2},
    {'title': '4', 'value': 3},
  ];
  String imageTemp =
      'https://instagram.fbkk5-6.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.180.1440.1440a/s640x640/133851894_231577355006812_2104786467046058604_n.jpg?_nc_ht=instagram.fbkk5-6.fna.fbcdn.net&_nc_cat=1&_nc_ohc=t-y0eYG-FkYAX8VbpYj&tp=1&oh=d5fed0e8846f1056c70836b6fce223eb&oe=601E2B77';
  int selectedCategory = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  GlobalKey globalKey = new GlobalKey();

  dynamic model = [
    {
      'code': '1',
      'plate1': '3กท',
      'plate2': '9771',
      'plate3': 'กรุงเทพมหานคร',
      'ticket_id': '',
      'card_id': '',
      'car_registration': '3กท-9771 กรุงเทพมหานคร',
      'car_type': 'รถยนต์นั่งส่วนบุคคลไม่เกิน 7 คน',
      'car_style': 'เก๋งสองตอน',
      'current_exp_date': '28/07/2565',
      'next_exp_date': '-',
      'tax': '845.10 บาท',
      'extra_money': '0.00 บาท',
      'together': '845.10 บาท',
      'due_date': '01/08/2565',
      'vehicle_status': '-',
      'remark':
          'ยื่นชำระภาษีล่วงหน้าก่อน 90 วัน แต่ไม่น้อยกว่า 45 วัน นับจากวันยื่นชำระภาษี',
      'vehicle_inspectiio': [
        {
          'examination_day': '28/03/2557',
          'vehicle': [
            {
              'title': 'การตรวจวัดเสียง ต้องไม่เกิน 100 เดซิเบล',
              'isActive': true,
            },
            {
              'title':
                  'รถยนต์เครื่องยนต์ดีเซล ต้องตรวจควันดำ โดยระบบกระดาษกรองต้องไม่เกินร้อยละ 50 และระบบวัดความทึบแสงต้องไม่เกิน 45%',
              'isActive': false,
            },
            {
              'title':
                  'ตรวจสอบวัดโคมไฟหน้า ทิศทางเบี่ยงเบนของลำแสง และตรวจวัดค่าความเข้มของแสง',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบความถูกต้องข้อมูลของรถ เช่น แผ่นป้ายทะเบียนรถ ลักษณะรถ หมายเลขตัวรถ เลขเครื่องยนต์ เป็นต้น',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสภาพตัวถัง สี อุปกรณ์เกี่ยวกับความปลอดภัย อุปกรณ์ไฟฟ้า พวงมาลัย ที่ปัดน้ำฝน ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบระบบบังคับเลี้ยว ระบบรองรับน้ำหนัก ระบบเบรก ระบบเชื้อเพลิง ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': true,
            },
            {
              'title':
                  'ทดสอบประสิทธิภาพการเบรก โดยตรวจสอบอุปกรณ์ทุกชิ้นว่าอยู่ในสภาพพร้อมใช้งานหรือไม่',
              'isActive': false,
            },
            {
              'title':
                  'ตรวจวัดก๊าซคาร์บอนมอนอกไซด์ (CO) และก๊าซไฮโดรคาร์บอน (HC) ของรถยนต์นั่งส่วนบุคคลไม่เกิน 7 ที่นั่ง',
              'isActive': false,
            },
          ],
          'gallery': [
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/1.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/2.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/3.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/4.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/5.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/6.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/7.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/8.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/9.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/10.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/11.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/12.jpeg'
            },
          ],
        },
        {
          'examination_day': '24/03/2556',
          'vehicle': [
            {
              'title': 'การตรวจวัดเสียง ต้องไม่เกิน 100 เดซิเบล',
              'isActive': false,
            },
            {
              'title':
                  'รถยนต์เครื่องยนต์ดีเซล ต้องตรวจควันดำ โดยระบบกระดาษกรองต้องไม่เกินร้อยละ 50 และระบบวัดความทึบแสงต้องไม่เกิน 45%',
              'isActive': false,
            },
            {
              'title':
                  'ตรวจสอบวัดโคมไฟหน้า ทิศทางเบี่ยงเบนของลำแสง และตรวจวัดค่าความเข้มของแสง',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบความถูกต้องข้อมูลของรถ เช่น แผ่นป้ายทะเบียนรถ ลักษณะรถ หมายเลขตัวรถ เลขเครื่องยนต์ เป็นต้น',
              'isActive': false,
            },
            {
              'title':
                  'ตรวจสภาพตัวถัง สี อุปกรณ์เกี่ยวกับความปลอดภัย อุปกรณ์ไฟฟ้า พวงมาลัย ที่ปัดน้ำฝน ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': false,
            },
            {
              'title':
                  'ตรวจสอบระบบบังคับเลี้ยว ระบบรองรับน้ำหนัก ระบบเบรก ระบบเชื้อเพลิง ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': false,
            },
            {
              'title':
                  'ทดสอบประสิทธิภาพการเบรก โดยตรวจสอบอุปกรณ์ทุกชิ้นว่าอยู่ในสภาพพร้อมใช้งานหรือไม่',
              'isActive': false,
            },
            {
              'title':
                  'ตรวจวัดก๊าซคาร์บอนมอนอกไซด์ (CO) และก๊าซไฮโดรคาร์บอน (HC) ของรถยนต์นั่งส่วนบุคคลไม่เกิน 7 ที่นั่ง',
              'isActive': false,
            },
          ],
          'gallery': [
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/1.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/2.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/3.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/4.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/5.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/6.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/7.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/8.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/9.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/10.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/11.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/12.jpeg'
            },
          ],
        },
      ],
    },
    {
      'code': '2',
      'plate1': 'กง',
      'plate2': '1107',
      'plate3': 'ตราด',
      'ticket_id': '',
      'card_id': '',
      'car_registration': 'กง-1107 ตราด',
      'car_type': 'รถยนต์นั่งส่วนบุคคลไม่เกิน 7 คน',
      'car_style': 'เก๋งสองตอน',
      'current_exp_date': '14/09/2565',
      'next_exp_date': '-',
      'tax': '892.50 บาท',
      'extra_money': '0.00 บาท',
      'together': '892.50 บาท',
      'due_date': '14/09/2565',
      'vehicle_status':
          'ต้องนำรถไปตรวจสภาพ ณ สถานตรวจสถาพรถเอกชน (ตรอ.) ก่อนยื่นชำระภาษี',
      'remark':
          'ยื่นชำระภาษีล่วงหน้าก่อน 90 วัน แต่ไม่น้อยกว่า 45 วัน นับจากวันยื่นชำระภาษี',
      'vehicle_inspectiio': [
        {
          'examination_day': '14/09/2557',
          'vehicle': [
            {
              'title': 'การตรวจวัดเสียง ต้องไม่เกิน 100 เดซิเบล',
              'isActive': true,
            },
            {
              'title':
                  'รถยนต์เครื่องยนต์ดีเซล ต้องตรวจควันดำ โดยระบบกระดาษกรองต้องไม่เกินร้อยละ 50 และระบบวัดความทึบแสงต้องไม่เกิน 45%',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบวัดโคมไฟหน้า ทิศทางเบี่ยงเบนของลำแสง และตรวจวัดค่าความเข้มของแสง',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบความถูกต้องข้อมูลของรถ เช่น แผ่นป้ายทะเบียนรถ ลักษณะรถ หมายเลขตัวรถ เลขเครื่องยนต์ เป็นต้น',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสภาพตัวถัง สี อุปกรณ์เกี่ยวกับความปลอดภัย อุปกรณ์ไฟฟ้า พวงมาลัย ที่ปัดน้ำฝน ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบระบบบังคับเลี้ยว ระบบรองรับน้ำหนัก ระบบเบรก ระบบเชื้อเพลิง ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': true,
            },
            {
              'title':
                  'ทดสอบประสิทธิภาพการเบรก โดยตรวจสอบอุปกรณ์ทุกชิ้นว่าอยู่ในสภาพพร้อมใช้งานหรือไม่',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจวัดก๊าซคาร์บอนมอนอกไซด์ (CO) และก๊าซไฮโดรคาร์บอน (HC) ของรถยนต์นั่งส่วนบุคคลไม่เกิน 7 ที่นั่ง',
              'isActive': true,
            },
          ],
          'gallery': [
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/1.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/2.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/3.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/4.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/5.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/6.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/7.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/8.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/9.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/10.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/11.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/12.jpeg'
            },
          ],
        },
        {
          'examination_day': '12/09/2556',
          'vehicle': [
            {
              'title': 'การตรวจวัดเสียง ต้องไม่เกิน 100 เดซิเบล',
              'isActive': true,
            },
            {
              'title':
                  'รถยนต์เครื่องยนต์ดีเซล ต้องตรวจควันดำ โดยระบบกระดาษกรองต้องไม่เกินร้อยละ 50 และระบบวัดความทึบแสงต้องไม่เกิน 45%',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบวัดโคมไฟหน้า ทิศทางเบี่ยงเบนของลำแสง และตรวจวัดค่าความเข้มของแสง',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบความถูกต้องข้อมูลของรถ เช่น แผ่นป้ายทะเบียนรถ ลักษณะรถ หมายเลขตัวรถ เลขเครื่องยนต์ เป็นต้น',
              'isActive': false,
            },
            {
              'title':
                  'ตรวจสภาพตัวถัง สี อุปกรณ์เกี่ยวกับความปลอดภัย อุปกรณ์ไฟฟ้า พวงมาลัย ที่ปัดน้ำฝน ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจสอบระบบบังคับเลี้ยว ระบบรองรับน้ำหนัก ระบบเบรก ระบบเชื้อเพลิง ว่ายังใช้งานได้ปกติหรือไม่',
              'isActive': false,
            },
            {
              'title':
                  'ทดสอบประสิทธิภาพการเบรก โดยตรวจสอบอุปกรณ์ทุกชิ้นว่าอยู่ในสภาพพร้อมใช้งานหรือไม่',
              'isActive': true,
            },
            {
              'title':
                  'ตรวจวัดก๊าซคาร์บอนมอนอกไซด์ (CO) และก๊าซไฮโดรคาร์บอน (HC) ของรถยนต์นั่งส่วนบุคคลไม่เกิน 7 ที่นั่ง',
              'isActive': true,
            },
          ],
          'gallery': [
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/1.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/2.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/3.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/4.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/5.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/6.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/7.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/8.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/9.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/10.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/11.jpeg'
            },
            {
              'imageUrl':
                  'http://122.155.223.63/td-doc/images/khub-dee/1/12.jpeg'
            },
          ],
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _callRead();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  _callRead() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        () {
          Navigator.pop(context, false);
        },
        title: 'ทะเบียนรถ',
        isButtonRight: true,
        imageRightButton: 'assets/icons/bell.png',
        rightButton: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationList(
                title: 'แจ้งเตือน',
              ),
            ),
          );
        },
      ),
      backgroundColor: Color(0xFFF5F8FB),
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // child: _screen(tempData),
        child: _buildListView(),

        // FutureBuilder<dynamic>(
        //   future: _futureModel, // function where you call your api
        //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //     if (snapshot.hasData) {
        //       return _screen2(snapshot.data);
        //     } else if (snapshot.hasError) {
        //       return Container();
        //     } else {
        //       return Container();
        //     }
        //   },
        // ),
      ),
    );
  }

  _buildListView() {
    return Column(
      children: [
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(bottom: 1),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  new Text(
                    'ทะเบียนทั้งหมด',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Sarabun',
                      fontSize: 14.0,
                      color: Color(0xFF545454),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // SizedBox(height: 10),
        this.model.length > 0
            ? Expanded(
                child: ListView(
                  children: [
                    _buildCard(this.model[0]),
                    SizedBox(height: 20),
                    _buildCard(this.model[1]),
                  ],
                ),

                // SmartRefresher(
                //   enablePullDown: false,
                //   enablePullUp: true,
                //   footer: ClassicFooter(
                //     loadingText: ' ',
                //     canLoadingText: ' ',
                //     idleText: ' ',
                //     idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
                //   ),
                //   controller: _refreshController,
                //   onLoading: _onLoading,
                //   onRefresh: _onRefresh,
                //   child: ListView.builder(
                //     physics: ScrollPhysics(),
                //     shrinkWrap: true,
                //     scrollDirection: Axis.vertical,
                //     itemCount: model.length,
                //     itemBuilder: (context, index) {
                //       return _item(model[index]);
                //     },
                //   ),
                // ),
              )
            : Container(),
      ],
    );
  }

  _buildCard(dynamic model) {
    return InkWell(
      onTap: () {
        if (widget.type.toUpperCase() == 'C')
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarRegistrationDes(
                model: model,
              ),
            ),
          );
        else if (widget.type.toUpperCase() == 'V')
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleInspectio(
                model: model,
              ),
            ),
          );
      },
      child: Container(
        height: 130,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          margin: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      '${model['plate1']}',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    child: Text(
                      '${model['plate2']}',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: Text(
                    '${model['plate3']}',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 55,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _screen(dynamic model) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return _buildCard(model[index]);
        },
      ),
    );
  }

  _update() async {}

  _onLoading() async {
    // setState(() {
    //   _limit = _limit + 2;
    // });
    _callRead();

    await Future.delayed(Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    // getCurrentUserData();
    // _getLocation();
    _callRead();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    // _refreshController.loadComplete();
  }
}
