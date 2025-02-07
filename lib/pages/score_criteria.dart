import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';

class ScoreCriteria extends StatefulWidget {
  @override
  _ScoreCriteriaPageState createState() => _ScoreCriteriaPageState();
}

class _ScoreCriteriaPageState extends State<ScoreCriteria> {
  late Future<dynamic> futureModel;
  dynamic model1;
  dynamic model2;
  dynamic model3;
  dynamic model4;

  @override
  void initState() {
    super.initState();

    read();
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
        Navigator.pop(context);
      }, title: 'หลักเกณฑ์คะแนนความประพฤติ', rightButton: null),
      backgroundColor: Color(0xFFF5F8FB),
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _screen(),
        // child: _futureBuilder(),
      ),
    );
  }

  _futureBuilder() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _screen();
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _screen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'หลักเกณฑ์ วิธีการตัดคะแนนความประพฤติการขับรถ',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 15,
              ),
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'ระดับคะแนนที่ถูกตัด แบ่งเป็น 4 ระดับ',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 15,
              ),
            ),
          ),
          _listRules(
            '1. ระดับกลุ่ม 1 คะแนน',
            model1,
            backgroundColor: Colors.white,
          ),
          _listRules(
            '2. ระดับกลุ่ม 2 คะแนน',
            model2,
            backgroundColor: null,
          ),
          _listRules(
            '3. ระดับกลุ่ม 3 คะแนน',
            model3,
            backgroundColor: Colors.white,
          ),
          _listRules(
            '4. ระดับกลุ่ม 4 คะแนน',
            model4,
            backgroundColor: null,
          ),
        ],
      ),
    );
  }

  _listRules(String title, dynamic model1, {required Color? backgroundColor}) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: model1.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        model1[index]['title'],
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 13,
                        ),
                        maxLines: 3,
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  read() {
    setState(
      () {
        model1 = [
          {'title': 'ใช้โทรศัพท์'},
          {'title': 'ไม่คาดเข็มขัดนิรภัย'},
          {'title': 'ขับรถบนทางเท้า'},
          {'title': 'ขับรถเร็วเกินกว่ากฎหมายกำหนด'},
          {'title': 'ขับรถไม่หลบรถฉุกเฉิน'},
          {'title': 'ไม่หยุดให้คนเดินข้ามทางข้าม'}
        ];
        model2 = [
          {'title': 'ฝ่าฝืนสัญญาณจราจรไฟสีแดง'},
          {'title': 'ฝ่าฝืนทิศทางเดินรถ'},
          {'title': 'ย้อนศร'},
          {'title': 'ขับรถโดยประมาทหรือน่าหวาดเสียว'},
          {
            'title': 'ขับรถในระหว่างถูกยึดใบอนุญาต ถูกสั่งพักใช้ หรือถูกเพิกถอน'
          },
          {'title': ' ขับรถในขณะเมาสุรา'}
        ];
        model3 = [
          {
            'title': 'จัดสนับสนุนหรือส่งเสริม การแข่งรถในทาง โดยไม่ได้รับอนุญาต'
          },
          {'title': 'ขับรถชนแล้วหลบหนี'},
          {'title': 'ในรถในขณะเสพยาเสพติด'},
          {
            'title':
                'ขับรถในขณะเมาสุรา มีปริมาณแอลกอฮอล์ในเลือดเกิน 150 มิลลิกรัมเปอร์เซ็นต์'
          }
        ];
        model4 = [
          {
            'title':
                'ขับรถในขณะเมาสุรา มีปริมาณแอลกอฮอล์ในเลือดเกิน 200 มิลลิกรัมเปอร์เซ็นต์'
          },
          {
            'title':
                'ขับรถขณะมึนเมาเป็นเหตุให้ผู้อื่นได้รับอันตรายสาหัส หรือเสียชีวิต'
          },
          {'title': 'ขับรถไม่คานึงถึงความปลอดภัยหรือความเดือนร้อนของผู้อื่น'}
        ];
      },
    );
  }
}
