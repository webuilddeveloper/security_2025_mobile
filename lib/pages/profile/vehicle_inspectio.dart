import 'package:flutter/cupertino.dart';
import 'package:security_2025_mobile_v3/component/gallery_view.dart';
import 'package:security_2025_mobile_v3/pages/notification/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VehicleInspectio extends StatefulWidget {
  VehicleInspectio({Key? key, this.model}) : super(key: key);

  final dynamic model;
  @override
  _VehicleInspectioPageState createState() => _VehicleInspectioPageState();
}

class _VehicleInspectioPageState extends State<VehicleInspectio> {
  final storage = new FlutterSecureStorage();
  double fontSizedetiel = 17;
  int maxLines = 10;

  List urlImage = [];
  // List<ImageProvider> urlImageProvider = [];
  List data = [];
  List<ImageProvider> dataPro = [];
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

  _callRead() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        () {
          Navigator.pop(context, false);
        },
        title: 'ตรวจสภาพรภ',
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
        child:
            myContent(widget.model['vehicle_inspectiio']), //_buildListView(),

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
    // return Stack(
    //   children: [
    return ListView(
      children: [
        _buildCard(widget.model),
        ListView.builder(
          shrinkWrap: true, // 1st add
          physics: ClampingScrollPhysics(), // 2nd
          // scrollDirection: Axis.horizontal,
          itemCount: model.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(
                      (MediaQuery.of(context).size.width / 100) * 2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ข้อมูลการตรวจสอบรภ ณ วันที่ ${model[index]['examination_day']}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                galleryView(model[index]),
                ListView.builder(
                  shrinkWrap: true, // 1st add
                  physics: ClampingScrollPhysics(), // 2nd
                  // scrollDirection: Axis.horizontal,
                  itemCount: model[index]['vehicle'].length,
                  itemBuilder: (context2, index2) {
                    return rowmsg(model[index]['vehicle'][index2]['isActive'],
                        model[index]['vehicle'][index2]['title']);
                  },
                ),
                // rowmsg(true, 'การตรวจวัดเสียง ต้องไม่เกิน 100 เดซิเบล'),
                // rowmsg(true,
                //     'รถยนต์เครื่องยนต์ดีเซล ต้องตรวจควันดำ โดยระบบกระดาษกรองต้องไม่เกินร้อยละ 50 และระบบวัดความทึบแสงต้องไม่เกิน 45%'),
                // rowmsg(true,
                //     'ตรวจสอบวัดโคมไฟหน้า ทิศทางเบี่ยงเบนของลำแสง และตรวจวัดค่าความเข้มของแสง'),
                // rowmsg(true,
                //     'ตรวจสอบความถูกต้องข้อมูลของรถ เช่น แผ่นป้ายทะเบียนรถ ลักษณะรถ หมายเลขตัวรถ เลขเครื่องยนต์ เป็นต้น'),
                // rowmsg(false,
                //     'ตรวจสภาพตัวถัง สี อุปกรณ์เกี่ยวกับความปลอดภัย อุปกรณ์ไฟฟ้า พวงมาลัย ที่ปัดน้ำฝน ว่ายังใช้งานได้ปกติหรือไม่'),
                // rowmsg(true,
                //     'ตรวจสอบระบบบังคับเลี้ยว ระบบรองรับน้ำหนัก ระบบเบรก ระบบเชื้อเพลิง ว่ายังใช้งานได้ปกติหรือไม่'),
                // rowmsg(true,
                //     'ทดสอบประสิทธิภาพการเบรก โดยตรวจสอบอุปกรณ์ทุกชิ้นว่าอยู่ในสภาพพร้อมใช้งานหรือไม่'),
                // rowmsg(false,
                //     'ตรวจวัดก๊าซคาร์บอนมอนอกไซด์ (CO) และก๊าซไฮโดรคาร์บอน (HC) ของรถยนต์นั่งส่วนบุคคลไม่เกิน 7 ที่นั่ง'),
                SizedBox(height: 20),
                Divider(
                  thickness: 2,
                ),
              ],
              // ),
              //   Positioned(
              //     bottom: 20,
              //     child: Container(
              //       width: MediaQuery.of(context).size.width,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Center(
              //             child: Container(
              //               margin: EdgeInsets.symmetric(vertical: 5.0),
              //               child: Material(
              //                 elevation: 2.0,
              //                 borderRadius: BorderRadius.circular(5.0),
              //                 color: Color(0xFFEBC22B),
              //                 child: MaterialButton(
              //                   // minWidth: MediaQuery.of(context).size.width,
              //                   onPressed: () {},
              //                   child: new Text(
              //                     'ชำระเงินภาษี',
              //                     style: new TextStyle(
              //                       fontSize: 13.0,
              //                       color: Color(0xFF4E2B68),
              //                       fontWeight: FontWeight.normal,
              //                       fontFamily: 'Sarabun',
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(width: 50),
              //           Center(
              //             child: Container(
              //               margin: EdgeInsets.symmetric(vertical: 5.0),
              //               child: Material(
              //                 elevation: 2.0,
              //                 borderRadius: BorderRadius.circular(5.0),
              //                 color: Theme.of(context).primaryColor,
              //                 child: MaterialButton(
              //                   // minWidth: MediaQuery.of(context).size.width,
              //                   onPressed: () {},
              //                   child: new Text(
              //                     'ดู พ.ร.บ.',
              //                     style: new TextStyle(
              //                       fontSize: 13.0,
              //                       color: Colors.white,
              //                       fontWeight: FontWeight.normal,
              //                       fontFamily: 'Sarabun',
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ],
            );
          },
        ),
      ],
    );
  }

  galleryView(model) {
    var rowdata = List<Widget>.empty(growable: true);
    // for (var item in model['gallery']) {
    for (var i = 0; i < model['gallery'].length; i++) {
      rowdata.add(
        Material(
          child: InkWell(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return dataImage(model['gallery'], i);
                },
              );
            },
            child: Container(
              child: ClipRRect(
                child: model['gallery'][i]['imageUrl'] != null
                    ? Image.network(
                        '${model['gallery'][i]['imageUrl']}',
                        width: MediaQuery.of(context).size.width / 3.035,
                        height: MediaQuery.of(context).size.width / 3.035,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
        ),
      );
      rowdata.add(SizedBox(width: 5));
    }

    return Container(
      height: (MediaQuery.of(context).size.height * 20) / 100,
      // width: (MediaQuery.of(context).size.width * 15) / 100,
      // color: Color(0xFFFFFFF),
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        // child: Row(children: rowdata),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: rowdata,
        ),
      ),
    );
  }

  dataImage(urlImageProvider, index) {
    for (var item in urlImageProvider) {
      dataPro.add(
        (item['imageUrl'] != null ? NetworkImage(item['imageUrl']) : null)
            as ImageProvider<Object>,
      );
    }
    return ImageViewer(
      initialIndex: index,
      imageProviders: dataPro ?? [],
    );
  }

  rowmsg(check, msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: check
              ? Icon(Icons.check, color: Colors.green)
              : Icon(Icons.clear, color: Colors.red),
        ),
        // Checkbox(
        //   value: check,
        //   onChanged: (bool value) {},
        //   checkColor: Colors.green,
        //   activeColor: Colors.transparent,
        //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // ),
        Expanded(
          child: Text(
            msg,
            maxLines: 20,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  _buildCard(dynamic model) {
    return InkWell(
      onTap: () {
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
