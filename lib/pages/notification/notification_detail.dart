import 'package:flutter/material.dart';
import 'notification_mock.dart';

class NotificationDetail extends StatelessWidget {
  NotificationDetail({Key? key, required this.model}) : super(key: key);

  final dynamic model;

  String _categoryLabel(String category) {
    switch (category) {
      case 'knowledgePage':
        return 'คลังความรู้';
      case 'newsPage':
        return 'ข่าวสาร';
      case 'eventPage':
        return 'กิจกรรม';
      case 'warningPage':
        return 'แจ้งเตือน';
      case 'welfarePage':
        return 'สวัสดิการ';
      case 'privilegePage':
        return 'สิทธิพิเศษ';
      case 'poiPage':
        return 'จุดตรวจ';
      case 'pollPage':
        return 'แบบสอบถาม';
      default:
        return 'ทั่วไป';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRead = model['status'] == 'A';
    final String description = '${model['description'] ?? ''}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'รายละเอียดแจ้งเตือน',
          style: TextStyle(color: Colors.white, fontFamily: 'Sarabun'),
        ),
        backgroundColor: const Color(0XFFB03432),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // หมวดหมู่ + สถานะ
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFEFE3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _categoryLabel('${model['category']}'),
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFF7514),
                      fontFamily: 'Sarabun',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(isRead ? Icons.check_circle : Icons.circle,
                    size: 16, color: isRead ? Colors.green : Colors.red),
                SizedBox(width: 4),
                Text(
                  isRead ? 'อ่านแล้ว' : 'ยังไม่อ่าน',
                  style: TextStyle(
                    fontSize: 13,
                    color: isRead ? Colors.green : Colors.red,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // หัวข้อ
            Text(
              '${model['title']}',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFF7514),
                fontFamily: 'Sarabun',
              ),
            ),
            SizedBox(height: 8),

            // วันที่
            Text(
              formatNotificationDate(model['createDate']),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Sarabun',
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),

            // รายละเอียด
            Text(
              description != '' ? description : 'ไม่มีรายละเอียดเพิ่มเติม',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
                fontFamily: 'Sarabun',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
