import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/toast_fail.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/widget/text_form_field.dart';

class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final txtheading = TextEditingController();
  final txthour = TextEditingController();
  final txtminute = TextEditingController();

  late XFile _image;
  bool showLoadingImage = false;
  List<String> _itemImage = [];

  String? selectedItem;

  final List<Map<String, String>> mockItems = [
    {'id': '1', 'name': 'พฤติกรรมและมารยาท'},
    {'id': '2', 'name': 'การปฏิบัติหน้าที่'},
    {'id': '3', 'name': 'ความปลอดภัย'},
    {'id': '4', 'name': 'การใช้ตำแหน่งโดยมิชอบ'},
    {'id': '5', 'name': ' อุปกรณ์และเครื่องแบบ'},
    {'id': '6', 'name': ' อื่นๆ'},
  ];
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

  Future<String> uploadImage(XFile file) async {
    Dio dio = new Dio();

    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "ImageCaption": "flutter",
      "Image": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    var response = await dio.post(serverUpload, data: formData);

    return response.data['imageUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'ร้องเรียน',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: const Color(0XFFB03432),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelTextFormField('* หัวข้อเรื่องร้องเรียน'),
              textFormField(
                txtheading,
                null,
                'หัวข้อเรื่องร้องเรียน',
                'หัวข้อเรื่องร้องเรียน',
                true,
                false,
                false,
              ),
              labelTextFormField('* ผู้ถูกร้องเรียน'),
              textFormField(
                txtheading,
                null,
                'ผู้ถูกร้องเรียน',
                'ผู้ถูกร้องเรียน',
                true,
                false,
                false,
              ),
              labelTextFormField('* ช่วงเวลาที่เกิดเหตุ'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: true ? Color(0xFF000070) : Color(0xFFFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 15.00,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              true ? Color(0xFFC5DAFC) : Color(0xFF707070),
                          contentPadding:
                              EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          hintText: 'ชั่วโมง',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Sarabun',
                            fontSize: 10.0,
                          ),
                        ),
                        controller: txthour,
                        enabled: true,
                      ),
                    ),
                    Text(' : '),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: true ? Color(0xFF000070) : Color(0xFFFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 15.00,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              true ? Color(0xFFC5DAFC) : Color(0xFF707070),
                          contentPadding:
                              EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          hintText: 'นาที',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Sarabun',
                            fontSize: 10.0,
                          ),
                        ),
                        controller: txtminute,
                        enabled: true,
                      ),
                    ),
                  ],
                ),
              ),
              labelTextFormField('* เลือกหัวข้อร้องเรียน'),
              dropdownSelect(selectedItem, (String? newValue) {
                setState(() {
                  selectedItem = newValue;
                });
              }, 'เลือกหัวข้อร้องเรียน', true, mockItems),
              SizedBox(height: 10),
              selectedItem == '6'
                  ? textFormField(
                      txtheading,
                      null,
                      'เรื่องร้องเรียน',
                      'เรื่องร้องเรียน',
                      true,
                      false,
                      false,
                    )
                  : SizedBox(),
              labelTextFormField('* รายละเอียดข้อมูลร้องเรียน'),
              textFormField(
                txtheading,
                null,
                'รายละเอียดข้อมูลร้องเรียน',
                'รายละเอียดข้อมูลร้องเรียน',
                true,
                false,
                false,
              ),
              labelTextFormField('* สิ่งที่ต้องการให้แก้ไข '),
              textFormField(
                txtheading,
                null,
                'สิ่งที่ต้องการให้แก้ไข',
                'สิ่งที่ต้องการให้แก้ไข',
                true,
                false,
                false,
              ),
              SizedBox(height: 10),
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
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Color(0XFFB03432),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              if (_itemImage.length < 3) {
                                _showPickerImage(context);
                              } else {
                                return toastFail(context,
                                    text:
                                        'สามารถอัพโหลดรูปภาพได้ไม่เกิน 3 รูป');
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
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
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        color: Color(0XFFB03432),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        'บันทึกข้อมูล',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sarabun',
                            fontSize: 16),
                      )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
}
