import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:security_2025_mobile_v3/component/material/check_avatar.dart';
import 'package:security_2025_mobile_v3/pages/my_qr_code.dart';
import 'package:security_2025_mobile_v3/qr_screen.dart';

class SecurityLicense extends StatefulWidget {
  SecurityLicense({super.key});

  @override
  State<SecurityLicense> createState() => _SecurityLicenseState();
}

class _SecurityLicenseState extends State<SecurityLicense>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController txtSearch = TextEditingController();

  List<Map<String, String>> filteredData = [];
  int itemsToShow = 10;

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
      itemsToShow = 10;
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
      "id": "001",
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
      "id": "002",
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
      "id": "003",
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
      "id": "004",
      "name": "วราภรณ์ นาคทอง",
      "image": "",
      "company": "บริษัท เค แอล เอ็ม จำกัด",
      "license_number": "7894561230",
      "blood_type": "AB",
      "issue_date": "2020-03-20",
      "expiry_date": "2025-03-20",
      "position": "พนักงานรักษาความปลอดภัย"
    }
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
                        vertical: 10.0, horizontal: 10.0),
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
                itemCount: itemsToShow,
                itemBuilder: (context, index) {
                  if (index >= filteredData.length) return null;
                  var item = filteredData[index];
                  final Uri qrUri = Uri(
                      scheme: "http",
                      host: "gateway.we-builds.com",
                      path: "security_information.html",
                      queryParameters: filteredData[index]);

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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            QrScreen(item: filteredData[index]),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        QrImageView(
                                          data: qrUri.toString(),
                                          size: 50,
                                          backgroundColor: Colors.white,
                                          foregroundColor: Color(0XFFB03432),
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
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: item["license_number"]!,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // RichText(
                            //   text: TextSpan(
                            //     text: 'หมู่เลือด : ',
                            //     style: TextStyle(
                            //       fontSize: 13.0,
                            //       // color: Color(0XFF0C387D),
                            //       color: Colors.white,
                            //       fontFamily: 'Kanit',
                            //       fontWeight: FontWeight.w400,
                            //     ),
                            //     children: [
                            //       TextSpan(
                            //         // text: 'A',
                            //         text: item["blood_type"]!,
                            //         style: TextStyle(
                            //           fontSize: 13.0,
                            //           // color: Color(0XFF0C387D),
                            //           color: Colors.white,
                            //           fontFamily: 'Kanit',
                            //           fontWeight: FontWeight.w300,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     RichText(
                            //       text: TextSpan(
                            //         text: 'วันออกบัตร : ',
                            //         style: TextStyle(
                            //           fontSize: 13.0,
                            //           // color: Color(0XFF0C387D),
                            //           color: Colors.white,
                            //           fontFamily: 'Kanit',
                            //           fontWeight: FontWeight.w400,
                            //         ),
                            //         children: [
                            //           TextSpan(
                            //             // text: '02/01/2567',
                            //             text: item["issue_date"]!,
                            //             style: TextStyle(
                            //               fontSize: 13.0,
                            //               // color: Color(0XFF0C387D),
                            //               color: Colors.white,
                            //               fontFamily: 'Kanit',
                            //               fontWeight: FontWeight.w300,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     RichText(
                            //       text: TextSpan(
                            //         text: 'วันหมดอายุ : ',
                            //         style: TextStyle(
                            //           fontSize: 13.0,
                            //           // color: Color(0XFF0C387D),
                            //           color: Colors.white,
                            //           fontFamily: 'Kanit',
                            //           fontWeight: FontWeight.w400,
                            //         ),
                            //         children: [
                            //           TextSpan(
                            //             // text: '02/01/2570',
                            //             text: item["expiry_date"]!,
                            //             style: TextStyle(
                            //               fontSize: 13.0,
                            //               // color: Color(0XFF0C387D),
                            //               color: Colors.white,
                            //               fontFamily: 'Kanit',
                            //               fontWeight: FontWeight.w300,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
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
                  width: MediaQuery.of(context).size.width / 1.3,
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
