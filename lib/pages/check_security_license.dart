import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/material/check_avatar.dart';

class SecurityLicense extends StatefulWidget {
  const SecurityLicense({super.key});

  @override
  State<SecurityLicense> createState() => _SecurityLicenseState();
}

class _SecurityLicenseState extends State<SecurityLicense>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController txtSearch = TextEditingController();

  // ข้อมูลที่ถูกกรองจากการค้นหา
  List<Map<String, String>> filteredData = [];
  int itemsToShow = 10; // เริ่มต้นแสดง 10 รายการ

  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    filteredData = List.from(allData);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void searchData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = List.from(allData);
      } else {
        filteredData = allData.where((item) {
          return item["name"]!.contains(query) ||
              item["company"]!.contains(query) ||
              item["license_number"]!.contains(query);
        }).toList();
      }
      itemsToShow = 10; // รีเซ็ตจำนวนที่แสดงเมื่อค้นหา
    });
  }

  void loadMore() {
    setState(() {
      if (itemsToShow + 10 <= filteredData.length) {
        itemsToShow += 10;
      } else {
        itemsToShow = filteredData.length;
      }
    });
  }

  List<Map<String, String>> allData = [
    {
      "name": "สมชาย ใจดี",
      "image": 'https://cdn-icons-png.flaticon.com/512/3361/3361201.png',
      "company": "บริษัท เอ บี ซี จำกัด",
      "license_number": "1234567890",
      "blood_type": "O",
      "issue_date": "2023-01-15",
      "expiry_date": "2028-01-15",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "สุภาพร วัฒนกิจ",
      "image": "",
      "company": "บริษัท ดี อี เอฟ จำกัด",
      "license_number": "9876543210",
      "blood_type": "A",
      "issue_date": "2022-06-10",
      "expiry_date": "2027-06-10",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "กิตติศักดิ์ มานะชัย",
      "image": "",
      "company": "บริษัท จี เอช ไอ จำกัด",
      "license_number": "4561237890",
      "blood_type": "B",
      "issue_date": "2021-12-01",
      "expiry_date": "2026-12-01",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "วราภรณ์ นาคทอง",
      "image": "",
      "company": "บริษัท เค แอล เอ็ม จำกัด",
      "license_number": "7894561230",
      "blood_type": "AB",
      "issue_date": "2020-03-20",
      "expiry_date": "2025-03-20",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "สมชาย ใจดี",
      "image": 'https://cdn-icons-png.flaticon.com/512/3361/3361201.png',
      "company": "บริษัท เอ บี ซี จำกัด",
      "license_number": "1234567890",
      "blood_type": "O",
      "issue_date": "2023-01-15",
      "expiry_date": "2028-01-15",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "สุภาพร วัฒนกิจ",
      "image": "",
      "company": "บริษัท ดี อี เอฟ จำกัด",
      "license_number": "9876543210",
      "blood_type": "A",
      "issue_date": "2022-06-10",
      "expiry_date": "2027-06-10",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "กิตติศักดิ์ มานะชัย",
      "image": "",
      "company": "บริษัท จี เอช ไอ จำกัด",
      "license_number": "4561237890",
      "blood_type": "B",
      "issue_date": "2021-12-01",
      "expiry_date": "2026-12-01",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "วราภรณ์ นาคทอง",
      "image": "",
      "company": "บริษัท เค แอล เอ็ม จำกัด",
      "license_number": "7894561230",
      "blood_type": "AB",
      "issue_date": "2020-03-20",
      "expiry_date": "2025-03-20",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "สมชาย ใจดี",
      "image": 'https://cdn-icons-png.flaticon.com/512/3361/3361201.png',
      "company": "บริษัท เอ บี ซี จำกัด",
      "license_number": "1234567890",
      "blood_type": "O",
      "issue_date": "2023-01-15",
      "expiry_date": "2028-01-15",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "สุภาพร วัฒนกิจ",
      "image": "",
      "company": "บริษัท ดี อี เอฟ จำกัด",
      "license_number": "9876543210",
      "blood_type": "A",
      "issue_date": "2022-06-10",
      "expiry_date": "2027-06-10",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "กิตติศักดิ์ มานะชัย",
      "image": "",
      "company": "บริษัท จี เอช ไอ จำกัด",
      "license_number": "4561237890",
      "blood_type": "B",
      "issue_date": "2021-12-01",
      "expiry_date": "2026-12-01",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "วราภรณ์ นาคทอง",
      "image": "",
      "company": "บริษัท เค แอล เอ็ม จำกัด",
      "license_number": "7894561230",
      "blood_type": "AB",
      "issue_date": "2020-03-20",
      "expiry_date": "2025-03-20",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "สมชาย ใจดี",
      "image": 'https://cdn-icons-png.flaticon.com/512/3361/3361201.png',
      "company": "บริษัท เอ บี ซี จำกัด",
      "license_number": "1234567890",
      "blood_type": "O",
      "issue_date": "2023-01-15",
      "expiry_date": "2028-01-15",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "สุภาพร วัฒนกิจ",
      "image": "",
      "company": "บริษัท ดี อี เอฟ จำกัด",
      "license_number": "9876543210",
      "blood_type": "A",
      "issue_date": "2022-06-10",
      "expiry_date": "2027-06-10",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "กิตติศักดิ์ มานะชัย",
      "image": "",
      "company": "บริษัท จี เอช ไอ จำกัด",
      "license_number": "4561237890",
      "blood_type": "B",
      "issue_date": "2021-12-01",
      "expiry_date": "2026-12-01",
      "position": "พนักงานรักษาความปลอดภัย"
    },
    {
      "name": "วราภรณ์ นาคทอง",
      "image": "",
      "company": "บริษัท เค แอล เอ็ม จำกัด",
      "license_number": "7894561230",
      "blood_type": "AB",
      "issue_date": "2020-03-20",
      "expiry_date": "2025-03-20",
      "position": "พนักงานรักษาความปลอดภัย"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'ตรวจสอบใบอนุญาต',
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
        backgroundColor: Color(0XFFB03432),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 45.0,
                width: MediaQuery.of(context).size.width - 10,
                child: TextField(
                  autofocus: false,
                  cursorColor: Color(0XFFB03432),
                  controller: txtSearch,
                  onChanged: searchData,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Sarabun',
                  ),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'ค้นหาจากชื่อ, บริษัท หรือเลขใบอนุญาต',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0), // จัดให้ข้อความอยู่กลาง
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0XFFB03432),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0XFFB03432),
                      ),
                    ),
                    prefixIcon: Padding(
                      // ใช้ prefixIcon แทน
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/search.png',
                        color: Color(0XFFB03432),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                // itemCount: filteredData.length,
                itemCount: itemsToShow,
                itemBuilder: (context, index) {
                  if (index >= filteredData.length) return null;
                  var item = filteredData[index];

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/bg_header.png"),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 85,
                                  width: 85,
                                  padding: EdgeInsets.only(right: 10),
                                  child: item["image"] != ''
                                      ? CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              NetworkImage(item["image"]!),
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            'assets/images/user_not_found.png',
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["name"]!,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            // color: Color(0XFF0C387D),
                                            color: Colors.white,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          item["position"]!,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    // widget.changePage(4);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => MyQrCode(),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/qr_code.png',
                                          height: 33,
                                          color: Color(0XFFB03432),
                                        ),
                                        Text(
                                          'สแกน',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Color(0XFFB03432),
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'ใบอนุญาตเลขที่ : ',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  // color: Color(0XFF0C387D),
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    // text: 'ชบ23110623',
                                    text: item["license_number"]!,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      // color: Color(0XFF0C387D),
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'หมู่เลือด : ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  // color: Color(0XFF0C387D),
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    // text: 'A',
                                    text: item["blood_type"]!,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      // color: Color(0XFF0C387D),
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'วันออกบัตร : ',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      // color: Color(0XFF0C387D),
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        // text: '02/01/2567',
                                        text: item["issue_date"]!,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          // color: Color(0XFF0C387D),
                                          color: Colors.white,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'วันหมดอายุ : ',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      // color: Color(0XFF0C387D),
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        // text: '02/01/2570',
                                        text: item["expiry_date"]!,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          // color: Color(0XFF0C387D),
                                          color: Colors.white,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  loadMore();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 10,
                  decoration: BoxDecoration(
                    color: Color(0XFFB03432),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'ดูเพิ่มเดิม',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
