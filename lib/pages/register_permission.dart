import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/register_permission_detail.dart';
import 'package:security_2025_mobile_v3/widget/text_form_field.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:file_picker/file_picker.dart';

class RegisterPermission extends StatefulWidget {
  RegisterPermission({super.key, required this.type});
  String type;

  @override
  State<RegisterPermission> createState() => _RegisterPermissionState();
}

class _RegisterPermissionState extends State<RegisterPermission>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();

  final txtHouseNo = TextEditingController();
  final txtVillage = TextEditingController();
  final txtRoad = TextEditingController();
  final txtSubDistrict = TextEditingController();
  final txtDistrict = TextEditingController();
  final txtProvince = TextEditingController();
  final txtPostalCode = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  int _selectedDay = DateTime.now().day;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<Map<String, dynamic>> fileCategories = [
    {
      "categoryName": "สำเนาบัตรประชาชน",
      "maxFiles": 1,
      "files": <PlatformFile>[],
      "required": true,
    },
    {
      "categoryName": "สำเนาทะเบียนบ้าน",
      "maxFiles": 1,
      "files": <PlatformFile>[],
      "required": true,
    },
    {
      "categoryName": "รูปถ่ายครึ่งตัว",
      "maxFiles": 3,
      "files": <PlatformFile>[],
      "required": true,
      "description": "ขนาด 1 นิ้ว ถ่ายไม่เกิน 6 เดือน",
    },
    {
      "categoryName": "สำเนาวุฒิการศึกษา",
      "maxFiles": 1,
      "files": <PlatformFile>[],
      "required": true,
    },
    {
      "categoryName": "หนังสือรับรองการอบรม",
      "maxFiles": 1,
      "files": <PlatformFile>[],
      "required": true,
    },
    {
      "categoryName": "ใบรับรองแพทย์",
      "maxFiles": 1,
      "files": <PlatformFile>[],
      "required": true,
    },
  ];

  Future<void> uploadFile(int index) async {
    try {
      final category = fileCategories[index];
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: category['maxFiles'] > 1,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        if (result.files.length > category['maxFiles']) {
          showErrorDialog(
            'เลือกไฟล์เกินจำนวน',
            'คุณสามารถอัปโหลดได้สูงสุด ${category['maxFiles']} ไฟล์',
          );
          return;
        }

        setState(() {
          category['files'] = result.files;
        });
        showSuccessSnackBar('อัปโหลดไฟล์สำเร็จ');
      }
    } catch (e) {
      showErrorDialog(
          'เกิดข้อผิดพลาด', 'ไม่สามารถอัปโหลดไฟล์ได้ กรุณาลองใหม่อีกครั้ง');
    }
  }

  void removeFile(int categoryIndex, int fileIndex) {
    setState(() {
      fileCategories[categoryIndex]['files'].removeAt(fileIndex);
    });
    showSuccessSnackBar('ลบไฟล์สำเร็จ');
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  String getTitle() {
    switch (widget.type) {
      case 'apply':
        return 'ลงทะเบียนแบบขออนุญาต';
      case 'renew':
        return 'การขอต่ออายุใบอนุญาต';
      case 'lost':
        return 'กรณีใบอนุญาตสูญหายหรือชำรุด';
      default:
        return 'การขอแก้ไขใบอนุญาต';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) => dialogPermission(context));

    txtFirstName.text = "สมชาย";
    txtLastName.text = "ติดล้อ";
    txtPhone.text = "09xxxxxxxx";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          getTitle(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0XFFB03432),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ข้อมูลส่วนตัว',
                style: TextStyle(
                  fontSize: 18.00,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelTextFormField('* ชื่อ'),
                          textFormField(
                            txtFirstName,
                            null,
                            'ชื่อ',
                            'ชื่อ',
                            false,
                            false,
                            false,
                          ),
                        ],
                      )),
                  SizedBox(width: 8.0),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          labelTextFormField('* นามสกุล'),
                          textFormField(
                            txtLastName,
                            null,
                            'นามสกุล',
                            'นามสกุล',
                            false,
                            false,
                            false,
                          ),
                        ],
                      ))
                ],
              ),
              labelTextFormField('วันเดือนปีเกิด'),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  dialogOpenPickerDate();
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: txtDate,
                    style: const TextStyle(
                      color: Color(0XFFB03432),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Sarabun',
                      fontSize: 15.0,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFC5DAFC),
                      contentPadding:
                          const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      hintText: "วันเดือนปีเกิด",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      errorStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Sarabun',
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
              ),
              labelTextFormField('* เบอร์โทรศัพท์ (10 หลัก)'),
              textFormPhoneField(
                txtPhone,
                'เบอร์โทรศัพท์ (10 หลัก)',
                'เบอร์โทรศัพท์ (10 หลัก)',
                false,
                true,
              ),
              SizedBox(height: 16),
              Text(
                'ข้อมูลที่อยู่',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelTextFormField('* บ้านเลขที่'),
                        textFormField(txtHouseNo, null, 'บ้านเลขที่',
                            'กรุณากรอกบ้านเลขที่', true, false, false),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelTextFormField('หมู่'),
                        textFormField(txtVillage, null, 'หมู่', 'กรุณากรอกหมู่',
                            true, false, false),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelTextFormField('ถนน'),
                        textFormField(txtRoad, null, 'ถนน', 'กรุณากรอกถนน',
                            true, false, false),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelTextFormField('* ตำบล'),
                        textFormField(txtSubDistrict, null, 'ตำบล',
                            'กรุณากรอกตำบล', true, false, false),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelTextFormField('* อำเภอ'),
                        textFormField(txtDistrict, null, 'อำเภอ',
                            'กรุณากรอกอำเภอ', true, false, false),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelTextFormField('* จังหวัด'),
                        textFormField(txtProvince, null, 'จังหวัด',
                            'กรุณากรอกจังหวัด', true, false, false),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelTextFormField('* รหัสไปรษณีย์'),
                        textFormField(txtPostalCode, null, 'รหัสไปรษณีย์',
                            'กรุณากรอกรหัสไปรษณีย์', true, false, true),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              buildFileUploadUI(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // showPaymentDialog(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => registerPermissionDetail(
                              firstName: txtFirstName.text,
                              lastName: txtLastName.text,
                              phone: txtPhone.text,
                              birthDate: txtDate.text,
                              houseNo: txtHouseNo.text,
                              village: txtVillage.text,
                              road: txtRoad.text,
                              subDistrict: txtSubDistrict.text,
                              district: txtDistrict.text,
                              province: txtProvince.text,
                              postalCode: txtPostalCode.text,
                              type: getTitle(),
                              uploadedFiles: fileCategories,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Color(0XFFB03432),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'ยื่นคำขอ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFileUploadList() {
    return ListView.builder(
      itemCount: fileCategories.length,
      itemBuilder: (context, index) {
        final category = fileCategories[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(category['categoryName']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...category['filePaths']
                    .map((path) => Text(path.split('/').last))
                    .toList(),
                if (category['filePaths'].isEmpty)
                  Text("ยังไม่มีไฟล์อัปโหลด",
                      style: TextStyle(color: Colors.grey)),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: () => uploadFile(category as int),
            ),
          ),
        );
      },
    );
  }

  Widget buildFileUploadUI() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: fileCategories.length,
      itemBuilder: (context, index) {
        final category = fileCategories[index];
        return Card(
          margin: EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(
                      category['categoryName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (category['required'])
                      Text(
                        ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                subtitle: category['description'] != null
                    ? Text(
                        category['description'],
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    : null,
                trailing: ElevatedButton.icon(
                  onPressed: () => uploadFile(index),
                  icon: Icon(Icons.upload_file, size: 18),
                  label: Text('อัปโหลด'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFB03432),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              if (category['files'].isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ไฟล์ที่อัปโหลด:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...List.generate(
                        category['files'].length,
                        (fileIndex) {
                          final file = category['files'][fileIndex];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    file.name,
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close,
                                      color: Colors.red, size: 18),
                                  onPressed: () => removeFile(index, fileIndex),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'ยังไม่มีไฟล์ที่อัปโหลด (สูงสุด ${category['maxFiles']} ไฟล์)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void SuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Icon(Icons.check_circle, color: Colors.green, size: 50),
          content: Text("ดำเนินการสำเร็จ! ", textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
              },
              child: Text("ตกลง"),
            ),
          ],
        );
      },
    );
  }

  dialogOpenPickerDate() {
    dt_picker.DatePicker.showDatePicker(
      context,
      theme: dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: const TextStyle(
          fontSize: 16.0,
          color: Color(0XFFB03432),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
        doneStyle: const TextStyle(
          fontSize: 16.0,
          color: Color(0XFFB03432),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
        cancelStyle: const TextStyle(
          fontSize: 16.0,
          color: Color(0XFFB03432),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime.now(),
      onConfirm: (date) {
        setState(
          () {
            _selectedYear = date.year;
            _selectedMonth = date.month;
            _selectedDay = date.day;
            txtDate.value = TextEditingValue(
              text:
                  "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}",
            );
          },
        );
      },
      currentTime: DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
      locale: dt_picker.LocaleType.th,
    );
  }

  Future<void> dialogPermission(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 600),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: Color(0XFFB03432),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'เอกสารประกอบ${getTitle()}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFFB03432),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0XFFB03432).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Color(0XFFB03432).withOpacity(0.3)),
                  ),
                  child: Text(
                    'ก่อนที่จะลงทะเบียนเป็นพนักงานรักษาความปลอดภัยรับอนุญาต คุณต้องเตรียมเอกสารดังนี้',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDocumentItem(
                          '1',
                          'สำเนาบัตรประชาชน',
                          Icons.credit_card,
                        ),
                        _buildDocumentItem(
                          '2',
                          'สำเนาทะเบียนบ้าน',
                          Icons.home,
                        ),
                        _buildDocumentItem(
                          '3',
                          'รูปถ่ายครึ่งตัว หน้าตรงไม่สวมหมวกและแว่นตาดำ\nขนาด 1 นิ้ว (2.5 x 3 ซม.) ถ่ายไม่เกิน 6 เดือน จำนวน 3 รูป',
                          Icons.photo_camera,
                        ),
                        _buildDocumentItem(
                          '4',
                          'สำเนาวุฒิการศึกษาที่แสดงว่าสำเร็จการศึกษาตามหลักสูตรการศึกษาภาคบังคับ',
                          Icons.school,
                        ),
                        _buildDocumentItem(
                          '5',
                          'หนังสือรับรองผ่านการอบรม หลักสูตรการรักษาความปลอดภัย',
                          Icons.verified_user,
                        ),
                        _buildDocumentItem(
                          '6',
                          'ใบรับรองแพทย์ รับรองว่าไม่เป็นโรคต้องห้ามตามที่คณะกรรมการกำหนด',
                          Icons.local_hospital,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFB03432),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'ยืนยัน',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentItem(String number, String text, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0XFFB03432).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Color(0XFFB03432),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
