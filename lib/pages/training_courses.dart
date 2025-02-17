import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/TrainingCourses_detail.dart';

class TrainingCourses extends StatefulWidget {
  const TrainingCourses({super.key});

  @override
  State<TrainingCourses> createState() => _TrainingCoursesState();
}

class _TrainingCoursesState extends State<TrainingCourses> {
  TextEditingController txtSearch = TextEditingController();
  List<Map<String, String>> filteredData = [];
  void initState() {
    super.initState();

    filteredData = List.from(courses);
  }

  final List<Map<String, String>> courses = [
    {
      'title': 'การรักษาความปลอดภัยขั้นพื้นฐาน',
      'imgUrl':
          'https://d1baueb6wfhxkz.cloudfront.net/5fd054ee86427401543af1e9/large/1626665268821512.webp#1739504407265',
      'url':
          'https://www.silvguard.com/บทความ/การรักษาความปลอดภัยขั้นพื้นฐานที่-รปภควรมี',
      'description': 'ความรู้พื้นฐานสำหรับ รปภ. ทุกคน',
      'duration': '2 ชั่วโมง',
      'lessons': '8 บทเรียน',
    },
    {
      'title': 'การตรวจตราและการเฝ้าระวัง',
      'imgUrl':
          'https://d1baueb6wfhxkz.cloudfront.net/5fd054ee86427401543af1e9/large/164869848968053.webp#1739508172800',
      'url': 'https://example.com/course2',
      'description': 'เทคนิคการตรวจตราพื้นที่อย่างมีประสิทธิภาพ',
      'duration': '1.5 ชั่วโมง',
      'lessons': '6 บทเรียน',
    },
    {
      'title': 'การรับมือเหตุฉุกเฉิน',
      'imgUrl':
          'https://lh5.googleusercontent.com/proxy/p9uHjascxfQnDUCG4RCSB5WHjAaK3Ap71qLpKr9aHGRdY-Cl50tw_OV2m90tXxiFUx8TrtepUgZFF161',
      'url': 'https://example.com/course3',
      'description': 'การจัดการสถานการณ์ฉุกเฉินต่างๆ',
      'duration': '2.5 ชั่วโมง',
      'lessons': '10 บทเรียน',
    },
    {
      'title': 'กฎหมายที่เกี่ยวข้องกับ รปภ.',
      'imgUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsuVNcHV_I4Mp6CAUHIfr1yyVGh3p1PBM-8oIS1sGvQRvuUS6JQlEQgNx982g-w1kSZDE&usqp=CAU',
      'url': 'https://example.com/course4',
      'description': 'ความรู้ด้านกฎหมายที่จำเป็น',
      'duration': '3 ชั่วโมง',
      'lessons': '12 บทเรียน',
    },
  ];

  void searchData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = List.from(courses);
      } else {
        filteredData = courses.where((item) {
          return item["title"]!.contains(query);
        }).toList();
      }
      // itemsToShow = 10; // รีเซ็ตจำนวนที่แสดงเมื่อค้นหา
    });
  }

  void goBack() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:
          // header(context, goBack, title: 'หลักสูตรการอบรม', rightButton: null),
          AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'หลักสูตรการอบรม',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
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
                  hintText: 'ค้นหาหลักสูคร',
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  if (index >= filteredData.length) return null;
                  var item = filteredData[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainingCoursesDetail(
                            title: item['title'].toString(),
                            imgUrl: item['imgUrl'].toString(),
                            url: item['url'].toString(),
                            description: item['description'].toString(),
                            duration: item['duration'].toString(),
                            lessons: item['lessons'].toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: item['imgUrl'] != ' '
                                  ? Image.network(
                                      item['imgUrl']!,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 120,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.error),
                                        );
                                      },
                                    )
                                  : Icon(Icons.phone_callback_outlined)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Flexible(
                                    child: Text(
                                      item['description'] ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 4,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.access_time,
                                              size: 16,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['duration'] ?? '',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.library_books,
                                              size: 16,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['lessons'] ?? '',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
