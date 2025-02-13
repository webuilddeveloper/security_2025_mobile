import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/register_permission.dart';

class mainPermission extends StatefulWidget {
  const mainPermission({super.key});

  @override
  State<mainPermission> createState() => _mainPermissionState();
}

class _mainPermissionState extends State<mainPermission>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
        title: const Text(
          'ลงทะเบียนแบบขออนุญาต',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0XFFB03432),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecurityLicenseCard(
                title: "ขอรับใบอนุญาตพนักงานรักษาความปลอดภัย",
                description: "กรอกข้อมูลเพื่อขอรับใบอนุญาตทำงาน",
                icon: Icons.badge,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'apply',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SecurityLicenseCard(
                title: "การขอต่ออายุใบอนุญาต",
                description:
                    "พนักงานรักษาความปลอดภัยรับอนุญาต ยื่นคำขอภายใน 60 วัน ก่อนวันที่ใบอนุญาตสิ้นอายุ",
                icon: Icons.security_update_warning,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'renew',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SecurityLicenseCard(
                title: "กรณีใบอนุญาตฯ สูญหายถูกทำลาย หรือชำรุดในสาระสำคัญ",
                description:
                    "พนักงานรักษาความปลอดภัยรับอนุญาต ยื่นคำขอรับใบแทนใบอนุญาต ดังกล่าวต่อนายทะเบียนภายใน 30 วัน นับแต่วันที่ได้ทราบการสูญหาย ถูกทำลาย หรือชำรุด",
                icon: Icons.dangerous,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'lost',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SecurityLicenseCard(
                title: "การขอแก้ไขใบอนุญาต",
                description:
                    "ผู้รับใบอนุญาตเป็นพนักงานรักษาความปลอดภัยรับอนุญาตที่ประสงค์จะแก้ไขเพิ่มเติมชื่อตัว ชื่อสกุล หรือชื่อตัวและชื่อสกุล หรือรายการประวัติอื่นใดในใบอนุญาตเป็นพนักงานรักษาความปลอดภัยรับอนุญาต ",
                icon: Icons.edit_document,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'edit',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SecurityLicenseCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0XFFB03432).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, size: 60, color: const Color(0XFFB03432)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
