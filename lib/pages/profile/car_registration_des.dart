import 'package:security_2025_mobile_v3/pages/notification/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CarRegistrationDes extends StatefulWidget {
  CarRegistrationDes({Key? key, this.model}) : super(key: key);

  final dynamic model;
  @override
  _CarRegistrationDesPageState createState() => _CarRegistrationDesPageState();
}

class _CarRegistrationDesPageState extends State<CarRegistrationDes> {
  final storage = new FlutterSecureStorage();
  double fontSizedetiel = 17;
  int maxLines = 10;
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
        title: 'ข้อมูลภาษี',
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
        child: myContent(widget.model), //_buildListView(),

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

  myContent(dynamic model) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(model),
            Container(
              padding:
                  EdgeInsets.all((MediaQuery.of(context).size.width / 100) * 2),
              alignment: Alignment.centerLeft,
              child: Text(
                "ข้อมูลภาษี",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            rowmsg('วันสิ้นอายุภาษีปัจจุบัน :', '${model['current_exp_date']}'),
            rowmsg('วันสิ้นอายุภาษีปีต่อไป :', '${model['next_exp_date']}'),
            rowmsg('ค่าภาษี :', '${model['tax']}'),
            rowmsg('เงินเพิ่ม :', '${model['extra_money']}'),
            rowmsg('รวม :', '${model['together']}'),
            rowmsg('วันที่ครบกำหนดชำระ :', '${model['due_date']}'),
            rowmsg('สถานะการตรวจสภาพรถ :', '${model['vehicle_status']}'),
            rowmsg('หมายเหตุ :', '${model['remark']}'),
          ],
        ),
        Positioned(
          bottom: 20,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xFFEBC22B),
                      child: MaterialButton(
                        // minWidth: MediaQuery.of(context).size.width,
                        onPressed: () {},
                        child: new Text(
                          'ชำระเงินภาษี',
                          style: new TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFF4E2B68),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(5.0),
                      color: Theme.of(context).primaryColor,
                      child: MaterialButton(
                        // minWidth: MediaQuery.of(context).size.width,
                        onPressed: () {},
                        child: new Text(
                          'ดู พ.ร.บ.',
                          style: new TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  rowmsg(title, des) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerMsg(title),
        detaillMsg(des),
      ],
    );
  }

  headerMsg(msg) {
    return Container(
      padding:
          EdgeInsets.only(left: (MediaQuery.of(context).size.width / 100) * 2),
      width: (MediaQuery.of(context).size.width / 100) * 45,
      child: new Text(
        msg,
        style: TextStyle(
          fontSize: fontSizedetiel,
          fontFamily: 'Kanit',
          fontWeight: FontWeight.w500,
          color: Color(0xFF707070),
        ),
      ),
    );
  }

  detaillMsg(msg) {
    return Expanded(
      child: Text(
        msg,
        style: TextStyle(
          fontSize: fontSizedetiel,
          fontFamily: 'Kanit',
          fontWeight: FontWeight.w500,
          color: Color(0xFF000000),
        ),
        maxLines: maxLines,
      ),
    );
  }

  _buildCard(dynamic model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarRegistrationDes(
              model: model,
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          margin: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 20),
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
}
