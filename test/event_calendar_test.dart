import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_2025_mobile_v3/component/comment.dart';
import 'package:security_2025_mobile_v3/component/content.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/calendar.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_form.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_list_vertical.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_main.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class _ImageHttpClient extends Fake implements HttpClient {
  @override
  set autoUncompress(bool value) {}
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    expect(
        eventCalendarMock
            .map((event) => Uri.parse(event['imageUrl'] as String)),
        contains(url));
    return _ImageRequest();
  }
}

class _ImageRequest extends Fake implements HttpClientRequest {
  @override
  HttpHeaders get headers => _Headers();
  @override
  Future<HttpClientResponse> close() async => _ImageResponse();
}

class _Headers extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _ImageResponse extends Stream<List<int>> implements HttpClientResponse {
  static final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLttAAAAABJRU5ErkJggg==');
  @override
  int get statusCode => 200;
  @override
  int get contentLength => bytes.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      Stream.value(bytes).listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ImageOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _ImageHttpClient();
}

void main() {
  test(
      'Five verified events retain real dates, image sources and chronological order',
      () {
    final events = getEventMockData();
    expect(events.length, 5);
    expect(events.map((e) => e['code']).toSet().length, 5);
    expect(events.map((e) => e['dateStart']),
        ['20261005', '20261019', '20261030', '20261118', '20261118']);
    expect(events.map((e) => e['dateEnd']),
        ['20261006', '20261020', '20261030', '20261120', '20261120']);
    for (final event in events) {
      expect(
          parseEventDate(event['dateStart'])
              .isBefore(DateTime.utc(2026, 10, 5)),
          false);
      expect(event['description'], contains('สถานที่:'));
      expect(event['description'], contains('เวลา:'));
      expect(Uri.parse(event['imageUrl']).scheme, 'https');
      expect(Uri.parse(event['linkUrl']).scheme, 'https');
      expect(event['imageUrl'], isNot(contains('pexels')));
    }
    expect(events[3]['timeStart'], '10:00');
    expect(events[3]['timeEnd'], '18:00');
    expect(events[0]['timeStart'], isEmpty);
    expect(events[0]['description'], contains('สอบถามผู้จัด'));
    final index = eventsByDay(events);
    expect(index.values.expand((e) => e).map((e) => e['code']).toSet(),
        events.map((e) => e['code']).toSet());
    for (final day in daysInRange(
        DateTime.utc(2026, 11, 18), DateTime.utc(2026, 11, 20))) {
      expect(index[day]!.length, 2);
    }
  });

  test(
      'Day lookup ignores clock and UTC/local representation; empty and duplicates handled',
      () {
    final events = getEventMockData();
    final index = eventsByDay([...events, events.first]);
    expect(index[DateTime(2026, 11, 18, 20)]!.length, 2);
    expect(index[DateTime.utc(2026, 11, 18, 8)]!.length, 2);
    expect(index[DateTime.utc(2026, 10, 7)], isNull);
    expect(eventsByDay([]), isEmpty);
    expect(parseEventDate('20261005'), parseEventDate('2026-10-05'));
    expect(() => parseEventDate('20260230'), throwsFormatException);
    expect(() => parseEventDate(''), throwsFormatException);
  });

  setUp(() => HttpOverrides.global = _ImageOverrides());
  tearDown(() => HttpOverrides.global = null);

  testWidgets(
      'Existing toggle opens calendar; selected day and month update events',
      (tester) async {
    await tester.pumpWidget(
        MaterialApp(home: EventCalendarMain(title: 'ปฏิทินกิจกรรม')));
    await tester.pumpAndSettle();
    expect(find.byType(EventCalendarListVertical), findsOneWidget);
    final action = tester.widget<AppBar>(find.byType(AppBar)).actions!.single;
    await tester.tap(find.descendant(
        of: find.byWidget(action), matching: find.byType(InkWell)));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarPage), findsOneWidget);
    TableCalendar calendar() =>
        tester.widget<TableCalendar>(find.byType(TableCalendar<dynamic>));
    expect(calendar().eventLoader!(DateTime.utc(2026, 11, 18)).length, 2);
    final target = DateTime.utc(2026, 10, 19);
    calendar().onDaySelected!(target, target);
    await tester.pumpAndSettle();
    expect(find.text('อบรมคณะกรรมการความปลอดภัยฯ (คปอ.)'), findsOneWidget);
    expect(find.text('Secutech Thailand 2026'), findsNothing);
    final nextMonth = DateTime.utc(2026, 11, 18);
    calendar().onPageChanged!(nextMonth);
    calendar().onDaySelected!(nextMonth, nextMonth);
    await tester.pumpAndSettle();
    expect(find.text('Secutech Thailand 2026'), findsOneWidget);
    final emptyDay = DateTime.utc(2026, 10, 7);
    calendar().onDaySelected!(emptyDay, emptyDay);
    await tester.pumpAndSettle();
    expect(calendar().eventLoader!(emptyDay), isEmpty);
    expect(find.text('Secutech Thailand 2026'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'List is complete, updates filters, and opens selected mock details without API',
      (tester) async {
    Widget list({String query = '', String category = ''}) => MaterialApp(
            home: Scaffold(
          body: SingleChildScrollView(
              child: EventCalendarListVertical(
            site: 'DDPM',
            title: '',
            url: 'unused-api',
            urlComment: 'unused-api',
            urlGallery: 'unused-api',
            keySearch: query,
            category: category,
          )),
        ));
    await tester.pumpWidget(list());
    await tester.pumpAndSettle();
    final grid = tester.widget<GridView>(find.byType(GridView));
    expect(grid.childrenDelegate.estimatedChildCount, eventCalendarMock.length);
    await tester.pumpWidget(list(query: 'ไม่มีกิจกรรมนี้'));
    await tester.pumpAndSettle();
    expect(find.text('ไม่พบข้อมูล'), findsOneWidget);
    await tester.pumpWidget(list(category: 'อบรม'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<GridView>(find.byType(GridView))
            .childrenDelegate
            .estimatedChildCount,
        eventCalendarMock.where((e) => e['category'] == 'อบรม').length);
    await tester.pumpWidget(list(query: 'การทำงานเกี่ยวกับไฟฟ้า'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('อบรมความปลอดภัยในการทำงานเกี่ยวกับไฟฟ้า'));
    await tester.pumpAndSettle();
    final form =
        tester.widget<EventCalendarForm>(find.byType(EventCalendarForm));
    expect(form.code, 'MOCK-E003');
    expect(form.model,
        same(eventCalendarMock.singleWhere((e) => e['code'] == form.code)));
    expect(tester.widget<Content>(find.byType(Content)).useMockData, true);
    for (var i = 0; i < 5 && find.byType(Comment).evaluate().isEmpty; i++) {
      await tester.drag(find.byType(Content), const Offset(0, -400));
      await tester.pumpAndSettle();
    }
    expect(tester.widget<Comment>(find.byType(Comment)).useMockData, true);
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'ทดสอบความคิดเห็นแบบ Mock');
    await tester.ensureVisible(find.text('ส่ง'));
    await tester.tap(find.text('ส่ง'));
    await tester.pumpAndSettle();
    final comments = await tester.widget<Comment>(find.byType(Comment)).model;
    expect(comments.single['description'], 'ทดสอบความคิดเห็นแบบ Mock');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
