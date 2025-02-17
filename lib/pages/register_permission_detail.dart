import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class registerPermissionDetail extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  // final String address;
  final String houseNo;
  final String village;
  final String road;
  final String subDistrict;
  final String district;
  final String province;
  final String postalCode;

  final String type;
  final List<Map<String, dynamic>> uploadedFiles;

  const registerPermissionDetail({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthDate,
    // required this.address,
    required this.houseNo,
    required this.village,
    required this.road,
    required this.subDistrict,
    required this.district,
    required this.province,
    required this.postalCode,
    required this.type,
    required this.uploadedFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Center(
            child: Text('สรุปรายการ', style: TextStyle(color: Colors.white))),
        backgroundColor: const Color(0XFFB03432),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'ข้อมูลคำขอ',
                [
                  _buildInfoRow('ประเภทคำขอ:', type),
                  _buildInfoRow('ค่าธรรมเนียม:', '1000 บาท'),
                ],
              ),
              SizedBox(height: 16),
              _buildSection(
                'ข้อมูลผู้ขอ',
                [
                  _buildInfoRow('ชื่อ-นามสกุล:', '$firstName $lastName'),
                  _buildInfoRow('เบอร์โทรศัพท์:', phone),
                  _buildInfoRow('วันเกิด:', birthDate),
                  _buildInfoRow('ที่อยู่:', getFormattedAddress()),
                ],
              ),
              SizedBox(height: 16),
              _buildUploadedFilesSection(uploadedFiles),
              SizedBox(height: 24),
              _buildPaymentBox(),
              SizedBox(height: 24),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedAddress() {
    List<String> addressParts = [];

    if (houseNo.isNotEmpty) addressParts.add('บ้านเลขที่ $houseNo');
    if (village.isNotEmpty) addressParts.add('หมู่ $village');
    if (road.isNotEmpty) addressParts.add('ถนน$road');
    if (subDistrict.isNotEmpty) addressParts.add('ตำบล$subDistrict');
    if (district.isNotEmpty) addressParts.add('อำเภอ$district');
    if (province.isNotEmpty) addressParts.add('จังหวัด$province');
    if (postalCode.isNotEmpty) addressParts.add(postalCode);

    return addressParts.join(' ');
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0XFFB03432),
              ),
            ),
            Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedFilesSection(List<Map<String, dynamic>> files) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เอกสารที่แนบ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0XFFB03432),
              ),
            ),
            Divider(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final fileCategory = files[index];
                return _buildFileCategory(fileCategory);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCategory(Map<String, dynamic> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category['categoryName'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (category['files'].isNotEmpty)
          ...category['files'].map<Widget>((PlatformFile file) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      file.name,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            );
          }).toList()
        else
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Text(
              'ไม่มีไฟล์แนบ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPaymentBox() {
    return Card(
      // color: Color(0XFFB03432).withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0XFFB03432), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ยอดชำระทั้งหมด',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '1000.00 บาท',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFB03432),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'กรุณาตรวจสอบข้อมูลให้ถูกต้องก่อนดำเนินการชำระเงิน',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Color(0XFFB03432), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'แก้ไขข้อมูล',
              style: TextStyle(
                color: Color(0XFFB03432),
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showPaymentDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFFB03432),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'ชำระเงิน',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(24.0),
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0XFFB03432).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.qr_code_2,
                        color: Color(0XFFB03432),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'ชำระเงิน',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Content
                Container(
                  padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'โปรดสแกน QR Code เพื่อชำระเงิน',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.qr_code_2_outlined,
                          size: 120,
                          color: Color(0XFFB03432),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Notice Text
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0XFFB03432).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0XFFB03432).withOpacity(0.1),
                    ),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text:
                              'หลังจากชำระเงินแล้ว นายทะเบียนต้องแจ้งคำสั่งอนุญาตหรือไม่อนุญาต ให้ผู้ยื่นคำขอ',
                        ),
                        TextSpan(
                          text: 'ทราบภายในหกสิบวันนับแต่วันที่ได้รับคำขอ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFB03432),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showPaymentSuccessDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFB03432),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'ยืนยันการชำระเงิน',
                        style: TextStyle(
                          fontSize: 16,
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

  void showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการกดพื้นหลังเพื่อปิด
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(24.0),
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_outlined,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
                SizedBox(height: 24),

                // Success Title
                Text(
                  'ชำระเงินสำเร็จ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 16),

                // Success Message
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ระบบได้รับการชำระเงินของท่านเรียบร้อยแล้ว',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'เจ้าหน้าที่จะดำเนินการตรวจสอบและแจ้งผลภายใน 60 วัน',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Transaction Details
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTransactionDetail(
                        'เลขที่รายการ:',
                        'TXN1234567890',
                      ),
                      _buildTransactionDetail(
                        'วันที่ชำระ:',
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      ),
                      _buildTransactionDetail(
                        'เวลา:',
                        '${DateTime.now().hour}:${DateTime.now().minute} น.',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'ตกลง',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
