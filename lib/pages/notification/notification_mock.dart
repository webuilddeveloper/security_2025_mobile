import 'package:intl/intl.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_utils.dart';
import 'package:security_2025_mobile_v3/pages/knowledge/knowledge_mock.dart';

// Local notifications for testing, not messages actually sent by the organizers.
// A = read, N = unread. Keep state across navigation until the app restarts.
final List<Map<String, dynamic>> notificationMock = getNotificationMockData();

List<Map<String, dynamic>> getNotificationMockData({DateTime? now}) {
  final capturedAt = (now ?? DateTime.now()).toUtc();
  final records = <Map<String, dynamic>>[];
  for (final code in ['MOCK-E001', 'MOCK-E002', 'MOCK-E004']) {
    final event = eventCalendarMock.singleWhere((e) => e['code'] == code);
    records.add({
      'category': 'eventPage',
      'reference': event['code'],
      'title': 'กิจกรรมที่น่าสนใจ: ${event['title']}',
      // Reuse the published dates/place; don't invent a new event schedule.
      'description': 'แจ้งเตือนตัวอย่างสำหรับทดสอบแอป\n\n'
          '${event['description'].toString().replaceAll('</p>', '\n\n').replaceAll(RegExp(r'<[^>]*>'), '').trim()}\n\n'
          'ดูข้อมูลกิจกรรมนี้ได้ในเมนูปฏิทินกิจกรรม\nแหล่งประกาศ: ${event['linkUrl']}',
    });
  }
  for (final code in ['K001', 'K005']) {
    final book = knowledgeMock.singleWhere((e) => e['code'] == code);
    records.add({
      'category': 'knowledgePage',
      'reference': book['code'],
      'title': 'แนะนำคู่มือ: ${book['title']}',
      'description': 'แจ้งเตือนตัวอย่างสำหรับทดสอบแอป\n\n'
          '${book['description'].toString().replaceAll('</p>', '\n\n').replaceAll(RegExp(r'<[^>]*>'), '').trim()}\n\n'
          'ผู้จัดทำ: ${book['author']}\nสำนักพิมพ์: ${book['publisher']}\n'
          'ประเภทไฟล์: ${book['bookType']}\nจำนวนหน้า: ${book['numberOfPages']} หน้า\n\n'
          'ดูคู่มือนี้ได้ในเมนูคลังความรู้',
    });
  }
  return [
    for (var i = 0; i < records.length; i++)
      {
        ...records[i],
        'code': 'N${(i + 1).toString().padLeft(3, '0')}',
        'status': i < 3 ? 'N' : 'A',
        'createDate':
            capturedAt.subtract(Duration(hours: i * 6 + 1)).toIso8601String(),
      },
  ];
}

// Return a Bangkok wall-clock value represented in UTC so sorting and rendering
// don't depend on the device timezone. Legacy compact dates are already local.
DateTime? parseNotificationDate(dynamic value) {
  final text = value?.toString().trim() ?? '';
  try {
    if (RegExp(r'^\d{8}(\d{6})?$').hasMatch(text)) {
      final date =
          '${text.substring(0, 4)}-${text.substring(4, 6)}-${text.substring(6, 8)}';
      if (text.length == 8)
        return DateFormat('yyyy-MM-dd').parseStrict(date, true);
      final time =
          '${text.substring(8, 10)}:${text.substring(10, 12)}:${text.substring(12, 14)}';
      return DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict('$date $time', true);
    }
    if (text.isEmpty) return null;
    final parsed = DateTime.tryParse(text);
    if (parsed == null) return null;
    final datePart = text.split('T').first.split(' ').first;
    DateFormat('yyyy-MM-dd').parseStrict(datePart);
    if (RegExp(r'(Z|[+-]\d{2}:?\d{2})$').hasMatch(text)) {
      return parsed.toUtc().add(const Duration(hours: 7));
    }
    return DateTime.utc(parsed.year, parsed.month, parsed.day, parsed.hour,
        parsed.minute, parsed.second, parsed.millisecond);
  } on FormatException {
    return null;
  }
}

String formatNotificationDate(dynamic value) {
  final date = parseNotificationDate(value);
  if (date == null) return 'ไม่ระบุวันที่';
  final day = DateFormat('dd/MM').format(date);
  final hasTime = value.toString().length > 10;
  return '$day/${date.year + 543}'
      '${hasTime ? ' ${DateFormat('HH:mm').format(date)} น.' : ''}';
}

List<Map<String, dynamic>> sortedNotifications(
    Iterable<Map<String, dynamic>> items) {
  final result = items.toList();
  result.sort((a, b) {
    final aDate = parseNotificationDate(a['createDate']);
    final bDate = parseNotificationDate(b['createDate']);
    if (aDate == null && bDate != null) return 1;
    if (bDate == null && aDate != null) return -1;
    final order = aDate == null ? 0 : bDate!.compareTo(aDate);
    return order != 0 ? order : '${a['code']}'.compareTo('${b['code']}');
  });
  return result;
}
