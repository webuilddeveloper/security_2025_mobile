// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;
  final String imageUrl;
  final String description;

  const Event(this.title, this.imageUrl, this.description);

  @override
  String toString() => title;
}

// Calendar navigation uses the current Bangkok day; fixture dates stay fixed.
DateTime get kToday {
  final now = DateTime.now().toUtc().add(const Duration(hours: 7));
  return DateTime.utc(now.year, now.month, now.day);
}

DateTime get kFirstDay =>
    DateTime.utc(kToday.year - 1, kToday.month, kToday.day);
DateTime get kLastDay =>
    DateTime.utc(kToday.year + 1, kToday.month, kToday.day);

String eventDateString(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}'
    '${date.month.toString().padLeft(2, '0')}'
    '${date.day.toString().padLeft(2, '0')}';

DateTime parseEventDate(String value) {
  final match = RegExp(r'^(\d{4})-?(\d{2})-?(\d{2})$').firstMatch(value);
  if (match == null) throw FormatException('Invalid event date', value);
  final year = int.parse(match[1]!);
  final month = int.parse(match[2]!);
  final day = int.parse(match[3]!);
  final date = DateTime.utc(year, month, day);
  if (date.year != year || date.month != month || date.day != day) {
    throw FormatException('Invalid event date', value);
  }
  return date;
}

// Verified on 2026-10-05 against the organizers' published schedules and images.
// Keep actual event dates fixed. Refresh this fixture from the sources when it expires;
// never roll dates forward, since that would misrepresent the real announcements.
List<Map<String, dynamic>> getEventMockData() {
  final records = <Map<String, dynamic>>[
    // Source: https://www.srdconsultant.com/
    {
      'code': 'MOCK-E001',
      'title': 'อบรม จป.หัวหน้างาน',
      'dateStart': '20261005',
      'dateEnd': '20261006',
      'description':
          '<p>หลักสูตรสำหรับหัวหน้างานและผู้ควบคุมงาน เพื่อพัฒนาความรู้ด้านการป้องกันอุบัติเหตุและดูแลความปลอดภัยในพื้นที่ทำงาน</p><p>วันที่: 5/10/2569 - 6/10/2569</p><p>เวลา: สอบถามผู้จัด (หน้าประกาศไม่ได้ระบุเวลาเริ่ม–จบ)</p><p>สถานที่: ศูนย์ฝึกอบรม เอสอาร์ดี คอนซัลแตนท์ เลขที่ 17 แขวงสีกัน เขตดอนเมือง กรุงเทพมหานคร (อาคารอุตสาหกรรมทอผ้าไทย)</p><p>อ้างอิงประกาศและภาพจากเว็บไซต์ผู้จัด ตรวจสอบเมื่อ 5 ตุลาคม 2569 ข้อมูลชุดนี้ใช้สำหรับทดสอบระบบ</p>',
      'timeStart': '',
      'timeEnd': '',
      'category': 'อบรม',
      'imageUrl':
          'https://image.makewebcdn.com/makeweb/m_750x0/aiFIT5c2K/DefaultData/%E0%B8%88%E0%B8%9B_%E0%B8%AB%E0%B8%B1%E0%B8%A7%E0%B8%AB%E0%B8%99%E0%B9%89%E0%B8%B2%E0%B8%87%E0%B8%B2%E0%B8%99_2569.jpg?v=202405291424',
      'createBy': 'SRD Consultant',
      'linkUrl': 'https://www.srdconsultant.com/',
    },
    // Source: https://www.srdconsultant.com/
    {
      'code': 'MOCK-E002',
      'title': 'อบรมคณะกรรมการความปลอดภัยฯ (คปอ.)',
      'dateStart': '20261019',
      'dateEnd': '20261020',
      'description':
          '<p>หลักสูตรสำหรับคณะกรรมการความปลอดภัย ครอบคลุมบทบาทหน้าที่ การประชุม การเสนอแนะมาตรการ และการติดตามผลด้านความปลอดภัยในสถานประกอบกิจการ</p><p>วันที่: 19/10/2569 - 20/10/2569</p><p>เวลา: สอบถามผู้จัด (หน้าประกาศไม่ได้ระบุเวลาเริ่ม–จบ)</p><p>สถานที่: ศูนย์ฝึกอบรม เอสอาร์ดี คอนซัลแตนท์ เลขที่ 17 แขวงสีกัน เขตดอนเมือง กรุงเทพมหานคร (อาคารอุตสาหกรรมทอผ้าไทย)</p><p>อ้างอิงประกาศและภาพจากเว็บไซต์ผู้จัด ตรวจสอบเมื่อ 5 ตุลาคม 2569 ข้อมูลชุดนี้ใช้สำหรับทดสอบระบบ</p>',
      'timeStart': '',
      'timeEnd': '',
      'category': 'อบรม',
      'imageUrl':
          'https://image.makewebcdn.com/makeweb/m_750x0/aiFIT5c2K/DefaultData/%E0%B8%AD%E0%B8%9A%E0%B8%A3%E0%B8%A1_%E0%B8%84%E0%B8%9B%E0%B8%AD2569.jpg?v=202405291424',
      'createBy': 'SRD Consultant',
      'linkUrl': 'https://www.srdconsultant.com/',
    },
    // Source: https://www.srdconsultant.com/
    {
      'code': 'MOCK-E003',
      'title': 'อบรมความปลอดภัยในการทำงานเกี่ยวกับไฟฟ้า',
      'dateStart': '20261030',
      'dateEnd': '20261030',
      'description':
          '<p>หลักสูตรสำหรับผู้ปฏิบัติงานเกี่ยวกับระบบไฟฟ้าหรือใกล้แหล่งจ่ายไฟ เรียนรู้อันตรายจากไฟฟ้าและแนวทางป้องกันอุบัติเหตุ</p><p>วันที่: 30/10/2569 - 30/10/2569</p><p>เวลา: สอบถามผู้จัด (หน้าประกาศไม่ได้ระบุเวลาเริ่ม–จบ)</p><p>สถานที่: ศูนย์ฝึกอบรม เอสอาร์ดี คอนซัลแตนท์ เลขที่ 17 แขวงสีกัน เขตดอนเมือง กรุงเทพมหานคร (อาคารอุตสาหกรรมทอผ้าไทย)</p><p>อ้างอิงประกาศและภาพจากเว็บไซต์ผู้จัด ตรวจสอบเมื่อ 5 ตุลาคม 2569 ข้อมูลชุดนี้ใช้สำหรับทดสอบระบบ</p>',
      'timeStart': '',
      'timeEnd': '',
      'category': 'อบรม',
      'imageUrl':
          'https://image.makewebcdn.com/makeweb/m_750x0/aiFIT5c2K/DefaultData/%E0%B9%84%E0%B8%9F%E0%B8%9F%E0%B9%89%E0%B8%B2_2569.jpg?v=202405291424',
      'createBy': 'SRD Consultant',
      'linkUrl': 'https://www.srdconsultant.com/',
    },
    // Source: https://secutechthailand.tw.messefrankfurt.com/bangkok/en/Thai-Version.html
    {
      'code': 'MOCK-E004',
      'title': 'Secutech Thailand 2026',
      'dateStart': '20261118',
      'dateEnd': '20261120',
      'description':
          '<p>งานแสดงเทคโนโลยีรักษาความปลอดภัยและการป้องกันอัคคีภัยสำหรับอาคารพาณิชย์และอุตสาหกรรม จัดร่วมพื้นที่กับ Thailand Smart City Expo</p><p>วันที่: 18/11/2569 - 20/11/2569</p><p>เวลา: 10:00 - 18:00 น.</p><p>สถานที่: ศูนย์การประชุมแห่งชาติสิริกิติ์ กรุงเทพมหานคร</p><p>อ้างอิงประกาศและภาพจากเว็บไซต์ผู้จัด ตรวจสอบเมื่อ 5 ตุลาคม 2569 ข้อมูลชุดนี้ใช้สำหรับทดสอบระบบ</p>',
      'timeStart': '10:00',
      'timeEnd': '18:00',
      'category': 'นิทรรศการ',
      'imageUrl':
          'https://secutechthailand.tw.messefrankfurt.com/content/dam/messefrankfurt-redaktion/secutech_thailand/stth26/kv/0610KV.png',
      'createBy': 'Secutech Thailand',
      'linkUrl':
          'https://secutechthailand.tw.messefrankfurt.com/bangkok/en/Thai-Version.html',
    },
    // Source: https://www.thailandsmartcityexpo.com/
    {
      'code': 'MOCK-E005',
      'title': 'Thailand Smart City Expo 2026',
      'dateStart': '20261118',
      'dateEnd': '20261120',
      'description':
          '<p>งานแสดงเทคโนโลยีเมืองอัจฉริยะ ครอบคลุมการอยู่อาศัย พลังงาน การเดินทาง สุขภาพ และสิ่งแวดล้อม เปิดสำหรับผู้เข้าชมธุรกิจ</p><p>วันที่: 18/11/2569 - 20/11/2569</p><p>เวลา: สอบถามผู้จัด (หน้าประกาศไม่ได้ระบุเวลาเริ่ม–จบ)</p><p>สถานที่: ศูนย์การประชุมแห่งชาติสิริกิติ์ กรุงเทพมหานคร</p><p>อ้างอิงประกาศและภาพจากเว็บไซต์ผู้จัด ตรวจสอบเมื่อ 5 ตุลาคม 2569 ข้อมูลชุดนี้ใช้สำหรับทดสอบระบบ</p>',
      'timeStart': '',
      'timeEnd': '',
      'category': 'นิทรรศการ',
      'imageUrl':
          'https://static.wixstatic.com/media/c387d2_4d8d3f2fc8a846acac370af7afb4aace~mv2.jpg',
      'createBy': 'N.C.C. Management & Development Co., Ltd.',
      'linkUrl': 'https://www.thailandsmartcityexpo.com/',
    },
  ];
  final result = records
      .map((record) => Map<String, dynamic>.unmodifiable({
            // Fixture capture date, not the organizer's original publication date.
            'createDate': '20261005',
            'updateDate': '20261005',
            'updateBy': record['createBy'],
            'view': 0,
            'fileUrl': '',
            'textButton': 'ดูประกาศจากผู้จัด',
            ...record,
          }))
      .toList();
  result.sort((a, b) {
    final dateOrder = parseEventDate(a['dateStart'])
        .compareTo(parseEventDate(b['dateStart']));
    if (dateOrder != 0) return dateOrder;
    // Unpublished times sort after known times on the same day.
    final aTime = a['timeStart'] == '' ? '99:99' : a['timeStart'] as String;
    final bTime = b['timeStart'] == '' ? '99:99' : b['timeStart'] as String;
    final timeOrder = aTime.compareTo(bTime);
    return timeOrder != 0
        ? timeOrder
        : (a['code'] as String).compareTo(b['code'] as String);
  });
  return List.unmodifiable(result);
}

final List<Map<String, dynamic>> eventCalendarMock = getEventMockData();

List<Map<String, dynamic>> get eventCalendarMockCategories => [
      {'code': '', 'title': 'ทั้งหมด'},
      for (final category
          in eventCalendarMock.map((event) => event['category']).toSet())
        {'code': category, 'title': category},
    ];

LinkedHashMap<DateTime, List<dynamic>> eventsByDay(
    Iterable<Map<String, dynamic>> events) {
  final result = LinkedHashMap<DateTime, List<dynamic>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  for (final event in events) {
    final start = parseEventDate(event['dateStart']);
    final end = parseEventDate(event['dateEnd']);
    for (final day in daysInRange(start, end)) {
      final items = result.putIfAbsent(day, () => []);
      if (!items.any((item) => item['code'] == event['code'])) items.add(event);
    }
  }
  return result;
}

LinkedHashMap<DateTime, List<dynamic>> get kEvents =>
    eventsByDay(eventCalendarMock);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}
