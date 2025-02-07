import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class QRPayment extends StatefulWidget {
  QRPayment({Key? key, this.code = '', this.model, this.back = true})
      : super(key: key);

  final String code;
  final dynamic model;
  final bool back;

  @override
  State<StatefulWidget> createState() => QRPaymentState();
}

class QRPaymentState extends State<QRPayment> {
  GlobalKey globalKey = new GlobalKey();
  final serverUrl = "https://core148.we-builds.com/payment-api/payment";
  String qrCode = '';
  bool checkOrder = false;
  String code = '';

  late int currentWidget;

  @override
  void initState() {
    currentWidget = 1;
    code = widget.code;
    // qrCode = 'http://core148.we-builds.com/payment-api/WeMart/Update/' + code;
    qrCode = 'test';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        () {
          Navigator.pop(context);
        },
        title: 'ชำระค่าปรับ',
        rightButton: null,
      ),
      body: WillPopScope(
          child: _contentWidget(), onWillPop: () => Future.value(widget.back)),
    );
  }

  _contentWidget() {
    return AnimatedSwitcher(
      // key: currentWidget,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
      child: _buildWidget(),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
          ),
          child: child,
        );
      },
    );
  }

  void _updateWidget() {
    setState(() {
      currentWidget = currentWidget == 1 ? 2 : 1;
    });
  }

  _buildWidget() {
    return FutureBuilder(
      future: Future.value(currentWidget),
      builder: (context, snapshot) {
        return _buildQRCode();
      },
    );
  }

  Column _buildQRCode() {
    return Column(
      children: <Widget>[
        Expanded(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Color(0xFF2C2C2C),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'กรุณาวาง QR ค่าปรับ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ให้อยู่ในกรอบที่กำหนด',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/images/prompay.png',
                            height: 30,
                            width: double.infinity,
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: QrImageView(
                                backgroundColor: Colors.white,
                                data: qrCode,
                                size: 300),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
        Container(height: 1, color: Colors.grey),
      ],
    );
  }

  _buildSuccess() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Container(
            height: 130,
            width: 130,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Container(
              height: 110,
              width: 110,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 90,
                width: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: 70,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Text(
            'ชำระเงินสำเร็จ',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 20,
              color: Colors.greenAccent,
            ),
          ),
          Text(
            'เลข order : ' + widget.code,
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 13,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          // Text(
          //   'ราคา : ' + priceFormat.format(widget.model['netPrice']),
          //   style: TextStyle(
          //     fontFamily: 'Kanit',
          //     fontSize: 13,
          //     color: Colors.grey,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: 100),
          Expanded(child: Container()),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Future<void> _captureAndSharePng() async {
    _requestPermission();
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary!.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      Directory appDocumentsDirectory = await getTemporaryDirectory();
      // await getExternalStorageDirectory(); // only android.
      // await getApplicationDocumentsDirectory();
      String appExternalStoragePath = appDocumentsDirectory.path;
      var gen = new DateTime.now().millisecondsSinceEpoch.toString();
      final file =
          await new File(appExternalStoragePath + gen + '.png').create();
      await file.writeAsBytes(pngBytes);

      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    // toastFail(context, text: info);
  }
}
