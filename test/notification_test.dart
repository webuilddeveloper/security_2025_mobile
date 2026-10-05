import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_utils.dart';
import 'package:security_2025_mobile_v3/pages/knowledge/knowledge_mock.dart';
import 'package:security_2025_mobile_v3/pages/notification/notification_detail.dart';
import 'package:security_2025_mobile_v3/pages/notification/notification_list.dart';
import 'package:security_2025_mobile_v3/pages/notification/notification_mock.dart';

void main() {
  setUp(() {
    notificationMock
      ..clear()
      ..addAll(getNotificationMockData(now: DateTime.utc(2026, 10, 5, 8)));
  });

  test('Five current notifications have complete, valid references', () {
    expect(notificationMock.length, 5);
    expect(notificationMock.map((e) => e['code']).toSet().length, 5);
    for (final item in notificationMock) {
      final source =
          item['category'] == 'eventPage' ? eventCalendarMock : knowledgeMock;
      expect(source.where((e) => e['code'] == item['reference']).length, 1);
      expect(item['title'], isNotEmpty);
      expect(item['description'], isNotEmpty);
      expect(item['description'], isNot(contains('<p>')));
      expect(parseNotificationDate(item['createDate']), isNotNull);
      expect(parseNotificationDate(item['createDate'])!.year, 2026);
    }
    expect(notificationMock.where((e) => e['status'] == 'N').length, 3);
  });

  test('ISO, UTC, compact and invalid dates format safely in Bangkok time', () {
    expect(formatNotificationDate('2026-10-05T09:30:00+07:00'),
        '05/10/2569 09:30 น.');
    expect(
        formatNotificationDate('2026-10-04T18:30:00Z'), '05/10/2569 01:30 น.');
    expect(formatNotificationDate('20261005093000'), '05/10/2569 09:30 น.');
    expect(formatNotificationDate('20261005'), '05/10/2569');
    expect(
        formatNotificationDate('2026-10-05T09:30:00'), '05/10/2569 09:30 น.');
    for (final date in [null, '', 'bad', '20260230', '2026-02-30']) {
      expect(formatNotificationDate(date), 'ไม่ระบุวันที่');
    }
    final sorted = sortedNotifications([
      {'code': 'old', 'createDate': '20261004'},
      {'code': 'missing', 'createDate': ''},
      {'code': 'new', 'createDate': '2026-10-05T09:30:00+07:00'},
    ]);
    expect(sorted.map((e) => e['code']), ['new', 'old', 'missing']);
  });

  testWidgets(
      'List shows all records; long titles/details fit and read state survives reentry',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Widget page() => MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: NotificationList(title: 'แจ้งเตือน'),
        );
    await tester.pumpWidget(page());
    await tester.pumpAndSettle();
    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.childrenDelegate.estimatedChildCount, 5);
    final title = notificationMock.first['title'] as String;
    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    await tester.tap(find.text(title));
    await tester.pumpAndSettle();
    expect(find.byType(NotificationDetail), findsOneWidget);
    expect(find.text(notificationMock.first['description']), findsOneWidget);
    expect(find.text('อ่านแล้ว'), findsOneWidget);
    expect(notificationMock.first['status'], 'A');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(page());
    await tester.pumpAndSettle();
    expect(notificationMock.first['status'], 'A');
    final lastTitle = notificationMock.last['title'] as String;
    await tester.scrollUntilVisible(find.text(lastTitle), 200,
        scrollable: find.byType(Scrollable));
    expect(find.text(lastTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Read all/delete all close action sheet and preserve empty state',
      (tester) async {
    Widget page() => MaterialApp(home: NotificationList(title: 'แจ้งเตือน'));
    Future<void> openActions() async {
      final bar = tester.widget<AppBar>(find.byType(AppBar));
      await tester.tap(find.descendant(
          of: find.byWidget(bar.actions!.single),
          matching: find.byType(InkWell)));
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(page());
    await tester.pumpAndSettle();
    await openActions();
    await tester.tap(find.text('อ่านทั้งหมด'));
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoActionSheet), findsNothing);
    expect(notificationMock.every((e) => e['status'] == 'A'), true);
    await openActions();
    await tester.tap(find.text('ลบทั้งหมด'));
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoActionSheet), findsNothing);
    expect(find.text('ไม่พบข้อมูล'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(page());
    await tester.pumpAndSettle();
    expect(find.text('ไม่พบข้อมูล'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
