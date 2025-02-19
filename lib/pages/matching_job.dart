import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/matching_job_detai.dart';

class MatchingJob extends StatefulWidget {
  const MatchingJob({super.key});

  @override
  State<MatchingJob> createState() => _MatchingJobState();
}

class _MatchingJobState extends State<MatchingJob> {
  TextEditingController txtSearch = TextEditingController();
  int itemsToShow = 10;
  List<Map<String, dynamic>> filteredData = [];

  final List<Map<String, dynamic>> jobList = [
    {
      "id": 1,
      "imgUrl":
          "https://www.jobbkk.com/upload/employer/00/280/031280/images/201344.webp",
      "url":
          "https://www.jobbkk.com/jobs/detail/201344/1096884?utm_campaign=google_jobs_apply&utm_source=google_jobs_apply&utm_medium=organic",
      "title": "บริษัท รักษาความปลอดภัย ท่าอากาศยานไทย จำกัด ",
      "company": "ABC Security Co., Ltd.",
      "location": "กรุงเทพฯ",
      "salary": "11,000 - 16,500 บาท/เดือน",
      "working_hours": "07.00 -15.00 น. / 15.00 - 23.00 น.",
      "isUrgent": true,
      "postedDate": "1 วันที่แล้ว",
      "qualifications": [
        "เพศชาย/หญิง อายุ 20-50 ปี",
        "วุฒิการศึกษา ม.3 ขึ้นไป",
        "สุขภาพแข็งแรง ไม่มีโรคประจำตัวร้ายแรง",
        "ไม่มีประวัติอาชญากรรมและไม่ยุ่งเกี่ยวกับยาเสพติด",
        "มีความรับผิดชอบ ตรงต่อเวลา และทำงานเป็นทีมได้",
        "หากมีใบอนุญาต รปภ. จะพิจารณาเป็นพิเศษ"
      ],
      "contact": {
        "email": "hr@abcsecurity.com",
        "phone": "090-123-4567",
        "address": "ถนนสุขุมวิท 50, กรุงเทพฯ"
      }
    },
    {
      "id": 2,
      "imgUrl":
          "https://static.vecteezy.com/system/resources/previews/008/214/517/non_2x/abstract-geometric-logo-or-infinity-line-logo-for-your-company-free-vector.jpg",
      "title": "พนักงานขาย (Sales Representative)",
      "company": "XYZ Trading Co., Ltd.",
      "location": "เชียงใหม่",
      "salary": "15,000 - 25,000 บาท/เดือน",
      "working_hours": "09.00 - 18.00 น.",
      "isUrgent": false,
      "postedDate": "3 วันที่แล้ว",
      "qualifications": [
        "เพศชาย/หญิง อายุ 22-35 ปี",
        "วุฒิการศึกษา ปวส. หรือ ปริญญาตรี สาขาการตลาด หรือที่เกี่ยวข้อง",
        "มีประสบการณ์ด้านการขายอย่างน้อย 1 ปี",
        "สามารถใช้คอมพิวเตอร์พื้นฐาน และโปรแกรม Microsoft Office ได้",
        "มีความสามารถในการสื่อสาร และเจรจาต่อรองได้ดี",
        "สามารถเดินทางไปพบลูกค้าในพื้นที่ต่าง ๆ ได้"
      ],
      "contact": {
        "email": "recruit@xyztrading.com",
        "phone": "081-234-5678",
        "address": "ถนนนิมมานเหมินท์, เชียงใหม่"
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(jobList);
  }

  void searchData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = List.from(jobList);
      } else {
        filteredData = jobList.where((item) {
          final title = item["title"]?.toString().toLowerCase() ?? "";
          final company = item["company"]?.toString().toLowerCase() ?? "";
          return title.contains(query.toLowerCase()) ||
              company.contains(query.toLowerCase());
        }).toList();
      }
      itemsToShow = 10;
    });
  }

  // void loadMore() {
  //   setState(() {
  //     if (itemsToShow + 10 <= filteredData.length) {
  //       itemsToShow += 10;
  //     } else {
  //       itemsToShow = filteredData.length;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'จับคู่ตำแหน่งงาน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFFB03432),
      ),
      body: Column(
        children: [
          // Search Section with Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0XFFB03432),
                  Color(0XFFB03432),
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
              controller: txtSearch,
              onChanged: searchData,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                hintText: 'ค้นหาจากชื่อบริษัท',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Job Listings
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: itemsToShow,
              itemBuilder: (context, index) {
                if (index >= filteredData.length) return null;

                final job = filteredData[index];

                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Job Header
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(job['imgUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            job['title'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (job['isUrgent'] == true)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'รับด่วน',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      job['company'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          job['location'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            job['working_hours'],
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFB03432).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      job['salary'],
                                      style: TextStyle(
                                        color: Color(0XFFB03432),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    job['postedDate'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MatchingJobDetail(job: job),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'ดูรายละเอียด',
                                      style: TextStyle(
                                        color: Color(0XFFB03432),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
