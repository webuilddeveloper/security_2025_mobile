import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/material/custom_alert_dialog.dart';
import 'package:security_2025_mobile_v3/component/material/input_with_label.dart';
import 'package:security_2025_mobile_v3/home_v2.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/toast_fail.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class Appeal extends StatefulWidget {
  Appeal(
      {Key? key, this.menuModel, required this.title, required this.ticket_ID})
      : super(key: key);

  final dynamic menuModel;
  final String title;
  final String ticket_ID;
  @override
  AppealState createState() => AppealState();
}

class AppealState extends State<Appeal> {
  late XFile _image;
  List<dynamic> items = [];
  List<String> _itemImage = [];
  String profileCode = '';
  String profileImageUrl = '';
  String profileFirstName = '';
  String profileLastName = '';
  bool showLoadingImage = false;
  final storage = new FlutterSecureStorage();
  final titleEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    getStorage();
    super.initState();
  }

  getStorage() async {
    if (widget.title != '') titleEditingController.text = widget.title;
    final storage = new FlutterSecureStorage();
    var code = await storage.read(key: 'profileCode3');
    var imageUrl = await storage.read(key: 'profileImageUrl');
    var firstName = await storage.read(key: 'profileFirstName');
    var lastName = await storage.read(key: 'profileLastName');
    setState(() {
      profileCode = code!;
      profileImageUrl = imageUrl!;
      profileFirstName = firstName!;
      profileLastName = lastName!;
    });
  }

  void validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(context, () => {Navigator.pop(context)},
            title: 'ยื่นอุธรณ์', rightButton: null),
        body: new InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: screen(),
              ),
              showLoadingImage
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  screen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'หมายเลขการยื่นอุธรณ์',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 13,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '4-368-910-134-601',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 13,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            inputWithLabel(
                context: context,
                title: 'การยื่นเรื่องยื่นอุทธรณ์',
                hintText: '',
                textEditingController: titleEditingController,
                checkText: titleEditingController.text == '' ? true : false,
                hasBorder: true,
                fillColor: Color(0xFF3F3F3F),
                enabledBorderColor: Color(0xFF3F3F3F),
                focusedBorderColor: Color(0xFF3F3F3F),
                textInputColor: Colors.white,
                maxLength: 100,
                callback: () {},
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกหัวข้อ.';
                  } else {
                    return null;
                  }
                },
                keyboardType: null),
            SizedBox(height: 20.0),
            inputWithLabel(
              context: context,
              title: 'รายละเอียดการโต้แย้ง',
              hintText: 'กรุณากรอกรายละเอียด',
              textEditingController: descriptionEditingController,
              checkText: descriptionEditingController.text == '' ? false : true,
              hasBorder: true,
              callback: () {},
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'กรุณากรอกรายละเอียด.';
                } else {
                  return null;
                }
              },
              textInputColor: null,
              maxLength: null,
            ),
            SizedBox(height: 40.0),
            imagePicker(),
            SizedBox(height: 60.0),
            Container(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  dialogVerification();
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return dialogVerificationold();
                  //   },
                  // );
                },
                child: Container(
                  height: 45,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFEBC22B),
                  ),
                  child: Text(
                    'ส่งเรื่องโต้แย้ง',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  imagePicker() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เพิ่มรูปภาพ',
                      style: TextStyle(
                        fontSize: 20.00,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'หลักฐานที่ต้องแนบได้แก่ ภาพถ่ายรถของท่านที่ปรากฏทะเบียนอย่างชัดเจน และหรือใบสั่ง',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '(สามารถแนบรูปภาพได้สูงสุด 3 ภาพ)',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF6F267B),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (_itemImage.length < 3) {
                          _showPickerImage(context);
                        } else {
                          return toastFail(context,
                              text: 'สามารถอัพโหลดรูปภาพได้ไม่เกิน 3 รูป');
                        }
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Image.asset(
                        'assets/logo/icons/picture.png',
                        // height: 14.0,
                        width: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_itemImage.length > 0)
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1,
              ),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _itemImage.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: 400,
                  child: MaterialButton(
                    onPressed: () {
                      dialogDeleteImage(_itemImage[index]);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        _itemImage[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text(
                    'อัลบั้มรูปภาพ',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  deleteImage(String code) async {
    setState(() {
      _itemImage.removeWhere((c) => c == code);
    });
  }

  void _upload() async {
    var id = new DateTime.now().millisecondsSinceEpoch;
    setState(() {
      showLoadingImage = true;
    });
    uploadImage(_image).then((res) {
      setState(() {
        showLoadingImage = false;
        _itemImage.add(res);
      });
      // setState(() {
      //   _imageUrl = res;
      // });
    }).catchError((err) {
      setState(() {
        showLoadingImage = false;
      });
      print(err);
    });
  }

  dialogDeleteImage(String code) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          'ต้องการลบรูปภาพ ใช่ไหม',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Sarabun',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: new Text(''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ยกเลิก",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Sarabun',
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ลบ",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Sarabun',
                color: Color(0xFFA9151D),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              deleteImage(code);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // .end
  Future<dynamic> dialogVerification() async {
    print('--------${widget.ticket_ID}=======');
    String? profileCode = await storage.read(key: 'profileCode3');
    if (profileCode != '' && profileCode != null) {
      final result = await postObjectDataMW(
          serverMW + 'tickerDispute/updateTicketDispute', {
        'code': profileCode,
        'createBy': profileCode,
        'updateBy': profileCode,
        'ticketNo': widget.ticket_ID
      });
      if (result['status'] == 'S') {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                contentPadding: EdgeInsets.all(0),
                content: Container(
                  width: 345,
                  height: 190,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xFFFFFF),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          'assets/check_circle.png',
                          height: 50,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'ส่งเรื่องโต้แย้งสำเร็จ',
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 15,
                            color: Color(0xFF5AAC68),
                          ),
                        ),
                        Text(
                          'ขอบคุณสำหรับการส่งเรื่อง เรากำลังพาท่านกลับสู่หน้าหลัก',
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 11,
                            color: Color(0xFF414141),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => HomePageV2(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFEBC22B),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                'ตกลง',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // child: //Contents here
                ),
              );
            });
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            // ignore: deprecated_member_use
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: CustomAlertDialog(
                contentPadding: EdgeInsets.all(0),
                content: Container(
                  width: 325,
                  height: 300,
                  // width: MediaQuery.of(context).size.width / 1.3,
                  // height: MediaQuery.of(context).size.height / 2.5,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xFFFFFF),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          'assets/cross_ quadrangle.png',
                          height: 50,
                        ),
                        // Icon(
                        //   Icons.check_circle_outline_outlined,
                        //   color: Color(0xFF5AAC68),
                        //   size: 60,
                        // ),
                        SizedBox(height: 10),
                        Text(
                          'เชื่อมต่อใบอนุญาตขับรถไม่สำเร็จ',
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 15,
                            // color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'กรุณายืนยันตัวผ่านตัวเลือกดังต่อไปนี้',
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 15,
                            color: Color(0xFF4D4D4D),
                          ),
                        ),
                        SizedBox(height: 28),
                        Container(height: 0.5, color: Color(0xFFcfcfcf)),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            child: Text(
                              'ลองใหม่อีกครั้ง',
                              style: TextStyle(
                                fontFamily: 'Sarabun',
                                fontSize: 15,
                                color: Color(0xFF4D4D4D),
                              ),
                            ),
                          ),
                        ),
                        Container(height: 0.5, color: Color(0xFFcfcfcf)),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, false);
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                fontFamily: 'Sarabun',
                                fontSize: 15,
                                color: Color(0xFF9C0000),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // child: //Contents here
                ),
              ),
            );
          },
        );
      }
    }
  }
  // dialogVerificationold() {
  //   return CustomAlertDialog(
  //     contentPadding: EdgeInsets.all(0),
  //     content: Container(
  //       width: 345,
  //       height: 190,
  //       decoration: new BoxDecoration(
  //         shape: BoxShape.rectangle,
  //         color: const Color(0xFFFFFF),
  //       ),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(15),
  //           color: Colors.white,
  //         ),
  //         child: Column(
  //           children: [
  //             SizedBox(height: 20),
  //             Image.asset(
  //               'assets/check_circle.png',
  //               height: 50,
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               'ส่งเรื่องโต้แย้งสำเร็จ',
  //               style: TextStyle(
  //                 fontFamily: 'Sarabun',
  //                 fontSize: 15,
  //                 color: Color(0xFF5AAC68),
  //               ),
  //             ),
  //             Text(
  //               'ขอบคุณสำหรับการส่งเรื่อง เรากำลังพาท่านกลับสู่หน้าหลัก',
  //               style: TextStyle(
  //                 fontFamily: 'Sarabun',
  //                 fontSize: 11,
  //                 color: Color(0xFF414141),
  //               ),
  //             ),
  //             SizedBox(height: 20),
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                   Navigator.of(context).pushAndRemoveUntil(
  //                     MaterialPageRoute(
  //                       builder: (context) => HomePage(),
  //                     ),
  //                     (Route<dynamic> route) => false,
  //                   );
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: Color(0xFF9C0000),
  //                     borderRadius: BorderRadius.only(
  //                       bottomLeft: Radius.circular(10),
  //                       bottomRight: Radius.circular(10),
  //                     ),
  //                   ),
  //                   height: 45,
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     'ตกลง',
  //                     style: TextStyle(
  //                       fontFamily: 'Sarabun',
  //                       fontSize: 15,
  //                       color: Color(0xFFFFFFFF),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       // child: //Contents here
  //     ),
  //   );
  // }
}
//
