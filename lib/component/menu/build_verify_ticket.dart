import 'package:security_2025_mobile_v3/pages/traffic_ticket.dart';
import 'package:security_2025_mobile_v3/pages/traffic_ticket_tmp.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerifyTicket extends StatefulWidget {
  VerifyTicket({Key? key, required this.model}) : super(key: key);

  final Future<dynamic> model;
  final storage = new FlutterSecureStorage();

  @override
  _VerifyTicket createState() => _VerifyTicket();
}

class _VerifyTicket extends State<VerifyTicket> {
  final storage = new FlutterSecureStorage();
  late Future<dynamic> futureModel;
  int notVerifyLenght = 0;
  @override
  void initState() {
    _read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _buildCard();

          // if (snapshot.data['lv0'] != '')
          //   return _buildCard(model: snapshot.data);
          // else
          //   return _buildCardNotRegister();
          // } else if (snapshot.hasError) {
          //   return BlankLoading();
        } else {
          return _buildCard();
        }
      },
    );
  }

  _buildCard() {
    return Container(
      height: 118,
      color: Colors.white,
      child: Row(
        children: [
          leftItem(),
          rightItem(notVerifyLenght),
        ],
      ),
    );
  }

  _buildCardNotRegister() {
    return Expanded(
      child: Container(
        height: 118,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFC200),
              Color(0xFFFF8E00),
            ],
            begin: Alignment.centerRight,
            // end: new Alignment(1, 0.0),
            end: Alignment.centerLeft,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF8E00),
                          Color(0xFFFFC200),
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
                          'ตรวจสอบใบสั่งย้อนหลัง',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ท่านไม่สามารถใช้เมนูนี้ได้',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontFamily: 'Sarabun',
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'กรุณายืนยันตัวตร เพื่อเชื่อมต่อข้อมูล',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontFamily: 'Sarabun',
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              // padding: EdgeInsets.all(5),
              height: 30,
              width: 32,
              decoration: BoxDecoration(
                // color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Image.asset(
                'assets/icons/traffic_ticket_icon.png',
                // color: Color(0xFFFFC200),
              ),
            )
          ],
        ),
      ),
    );
  }

  itemNotIdcard() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFC200).withOpacity(0.5),
              Color(0xFFFF8E00).withOpacity(0.3),
            ],
            begin: Alignment.centerRight,
            // end: new Alignment(1, 0.0),
            end: Alignment.centerLeft,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    // margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF7B06).withOpacity(0.6),
                          Color(0xFFFFC200),
                        ],
                        begin: Alignment.centerRight,
                        // end: new Alignment(1, 0.0),
                        end: Alignment.centerLeft,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'ตรวจสอบใบสั่งย้อนหลัง',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ท่านไม่สามารถใช้งานเมนูนี้',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontFamily: 'Sarabun',
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'กรุณาเพิ่มข้อมูลบัตรประชาชน เพื่อเชื่อมต่อข้อมูล',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontFamily: 'Sarabun',
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  leftItem() {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrafficTicket(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD3913F).withOpacity(0.5),
                Color(0xFFD3913F).withOpacity(0.3),
              ],
              begin: Alignment.centerRight,
              // end: new Alignment(1, 0.0),
              end: Alignment.centerLeft,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   colors: [
                        //     Color(0xFFD3913F).withOpacity(0.6),
                        //     Color(0xFFD3913F),
                        //   ],
                        //   begin: Alignment.centerRight,
                        //   // end: new Alignment(1, 0.0),
                        //   end: Alignment.centerLeft,
                        // ),
                        color: Color(0xFFD3913F),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'ตรวจสอบใบสั่ง',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'Sarabun',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '(Traffic Tickets)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.0,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'สำนักงานตำรวจแห่งชาติอำนวยความสะดวกให้ท่าน',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontFamily: 'Sarabun',
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'สามารถตรวจสอบใบสั่งย้อนหลังได้สูงสุด 1 ปี',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontFamily: 'Sarabun',
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            // color: Colors.white,
                            child: Text(
                              '(PTM)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                                fontFamily: 'Sarabun',
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                // padding: EdgeInsets.all(5),
                height: 30,
                width: 32,
                decoration: BoxDecoration(
                  // color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Image.asset(
                  'assets/icons/traffic_ticket_icon.png',
                  // color: Color(0xFFFFC200),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  rightItem(int param) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrafficTicketTMP(),
          ),
        );
      },
      child: Container(
        width: 118,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xFF9C040C),
            Color(0xFF64282A),
          ],
          begin: Alignment.centerRight,
          // end: new Alignment(1, 0.0),
          end: Alignment.centerLeft,
        )),
        child: Column(
          children: [
            SizedBox(height: 15),
            Text(
              'จำนวนใบสั่ง',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontFamily: 'Sarabun',
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            Text(
              'คงค้างดำเนินการ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontFamily: 'Sarabun',
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      param.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    child: Text(
                      '(ใบ)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontFamily: 'Sarabun',
                      ),
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _read() async {
    // getNotpaidTicketListApi
    // futureModel = postDio(getNotpaidTicketListApi,
    //     {"createBy": "createBy", "updateBy": "updateBy"});
    futureModel = postDio(getNotpaidTicketListApi, {
      "createBy": "createBy",
      "updateBy": "updateBy",
      "card_id": "",
      "plate1": "3กท",
      "plate2": "9771",
      "plate3": "00100",
      "ticket_id": ""
    });
    var _notVerifyTicket = await futureModel;

    setState(() {
      notVerifyLenght = _notVerifyTicket.length;
    });
  }
}
