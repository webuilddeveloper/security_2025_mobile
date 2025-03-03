import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_data.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_form.dart';

class EventCalendarListVertical extends StatefulWidget {
  EventCalendarListVertical({
    Key? key,
    required this.site,
    required this.title,
    required this.url,
    required this.urlComment,
    required this.urlGallery,
  }) : super(key: key);

  final String site;
  final String title;
  final String url;
  final String urlComment;
  final String urlGallery;

  @override
  _EventCalendarListVertical createState() => _EventCalendarListVertical();
}

class _EventCalendarListVertical extends State<EventCalendarListVertical> {
  late Future<List<Map<String, dynamic>>> model;

  @override
  void initState() {
    super.initState();
    model = Future.value(_getMockData());
  }

  List<Map<String, dynamic>> _getMockData() {
    return [
      {
        'code': 'E001',
        'title':
            'สตง. เตรียมจัดกิจกรรมยิ่งใหญ่ ครบรอบ 150 ปีการตรวจเงินแผ่นดินไทย',
        'description':
            '''นายสุทธิพงษ์บุญนิธิรองผู้ว่าการตรวจเงินแผ่นดิน ในฐานะโฆษกสํานักงานการตรวจเงินแผ่นดิน เปิดเผยว่า สืบเนื่องจากในปี 2568 นี้ถือเป็นวาระสําคัญยิ่งที่การตรวจเงินแผ่นดินได้ถือกําเนิดขึ้นใน
ประเทศไทยครบ 150 ปี ดังนั้น เพื่อเป็นการย้อนรําลึกถึงเหตุการณ์สําคัญทางประวัติศาสตร์เมื่อครั้งที่พระบาทสมเด็จพระจุลจอมเกล้าเจ้าอยู่หัวได้ทรงวางรากฐานการตรวจเงินแผ่นดินไทยขึ้นเป็นครั้งแรก โดย
ทรงพระกรุณาโปรดเกล้าฯ ให้ตรา "พระราชบัญญัติสําหรับกรมพระคลังมหาสมบัติแลว่าด้วยกรมต่าง ๆซึ่งจะเบิกเงินส่งเงิน จุลศักราช 1237" ขึ้นเมื่อวันที่ 14 เมษายน พ.ศ. 2418และทรงพระกรุณาโปรดเกล้าฯ ให้ตั้ง
“ออฟฟิศหลวง” หรือ “ออดิตออฟฟิศ” ขึ้นเพื่อเป็นที่ประชุมตรวจบัญชีคลัง ให้มีฐานะเป็นอิสระ ไม่ขึ้นกับกรมพระคลังมหาสมบัติ จวบจนถึงปัจจุบันการตรวจเงินแผ่นดินไทยได้มีการเปลี่ยนแปลงและพัฒนามาเป็นลําดับ
และเพื่อเป็นการฉายภาพทิศทางการตรวจเงินแผ่นดินในการเสริมสร้างความโปร่งใสและความยั่งยืนให้กับสังคมไทย รวมถึงการเตรียมความพร้อมรับความท้าทายใหม่ ๆ ในอนาคต สํานักงานการตรวจเงินแผ่นดิน (สตง.)
จึงได้เตรียมจัดกิจกรรมยิ่งใหญ่อย่างต่อเนื่องตลอดทั้งปี 2568 ภายใต้กรอบแนวคิด “ 150 ปี การตรวจเงินแผ่นดินไทย ก้าวไปในยุคดิจิทัล” โดยจะประกอบด้วย 3 กิจกรรมหลัก ดังนี้
1. กิจกรรมด้านการรวบรวมข้อมูลทางประวัติศาสตร์ โดยลําดับเหตุการณ์สําคัญการตรวจเงินแผ่นดินไทยในแต่ละยุคสมัย การนําเสนอผลการตรวจสอบที่โดดเด่นจากอดีตถึงปัจจุบัน การนําเสนอเรื่องราวที่แสดงให้เห็นถึง
ความวิริยะอุตสาหะ และความสามารถของบรรพชนคนตรวจเงินแผ่นดินในการปกป้องรักษาเงินแผ่นดิน ฯลฯ
2. กิจกรรมจัดประชุมวิชาการทั้งในประเทศและระดับนานาชาติในหัวข้อที่เกี่ยวข้องกับการตรวจเงินแผ่นดินในมิติการพัฒนาที่ยั่งยืน (Sustainability) และการนําเทคโนโลยีดิจิทัลมาประยุกต์ใช้ในงานตรวจสอบ
(Digitalization)
3. กิจกรรมเพื่อสังคมและสาธารณประโยชน์ต่าง ๆ ซึ่งเป็นกิจกรรมที่ สตง. ได้ให้ความสําคัญและสนับสนุนส่งเสริมให้คณะผู้บริหารและเจ้าหน้าที่ทุกคนมีจิตสาธารณะในการบําเพ็ญประโยชน์เพื่อสังคมและ
ประเทศชาติอย่างต่อเนื่อง
ทั้งนี้ สําหรับรายละเอียดและช่วงเวลาของการจัดกิจกรรมจะได้แถลงต่อสื่อมวลชนอย่างเป็นทางการในช่วงเดือนธันวาคม 2567 ต่อไป''',
        'imageUrl':
            'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250228-110640-event 1.jpeg',
        'createBy': 'admin',
        'createDate': '20250228',
        'updateBy': 'admin',
        'updateDate': '20250228',
        'view': 9436
      },
      {
        'code': 'E002',
        'title':
            'การจ้างเจ้าหน้าที่รักษาความปลอดภัยขององค์กรปกครองส่วนท้องถิ่น',
        'description':
            'องค์กรปกครองส่วนท้องถิ่นสามารถพิจารณาจ้างเอกชนและเบิกจ่ายเงินค่าจ้างเหมาบริการในการปฏิบัติงานรักษาความปลอดภัย โดยต้องถือปฏิบัติตามหนังสือกระทรวงมหาดไทย ที่ มท 0808.2/ ว 4044 ลงวันที่ 10 กรกฎาคม 2563 เรื่อง หลักเกณฑ์การดำเนินการจ้างเอกชนและการเบิกจ่ายเงินค่าจ้างเหมาบริการขององค์กรปกครองส่วนท้องถิ่น และพระราชบัญญัติธุรกิจรักษาความปลอดภัย พ.ศ. 2558 สำหรับวิธีการในการจ้างเอกชนให้ถือปฏิบัติตามพระราชบัญญัติการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 ส่วนการจ้างบุคคลธรรมดาให้ทำหน้าที่รักษาความปลอดภัยนั้นไม่สามารถดำเนินการได้ เนื่องจากไม่มีข้อกำหนดไว้ในพระราชบัญญัติธุรกิจรักษาความปลอดภัย พ.ศ. 2558',
        'imageUrl':
            'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250228-111201-event 2.jpeg',
        'createBy': 'admin',
        'createDate': '20250228',
        'updateBy': 'admin',
        'updateDate': '20250228',
        'view': 8734
      },
      // {
      //   'code': 'E003',
      //   'title': 'Event 3',
      //   'imageUrl': 'https://via.placeholder.com/150',
      // },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: model,
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Container(
              height: 200,
              alignment: Alignment.center,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return myCard(index, snapshot.data![index], context);
                },
              ),
            );
          }
        } else {
          return blankGridData(context);
        }
      },
    );
  }

  Widget myCard(int index, Map<String, dynamic> model, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarForm(
              urlGallery: widget.urlGallery,
              urlComment: widget.urlComment,
              model: model,
              url: widget.url,
              code: model['code'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 157.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                  color: Colors.white.withAlpha(220),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(model['imageUrl']),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                color: Colors.black.withAlpha(10),
              ),
              child: Text(
                model['title'],
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Sarabun',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
