import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_2025_mobile_v3/pages/profile/setting_notification.dart';

void main() {
  const storage = FlutterSecureStorage();
  setUp(() => FlutterSecureStorage.setMockInitialValues({
        'dataUserLoginDDPM': jsonEncode({'username': 'tester', 'code': ''}),
      }));

  testWidgets('Missing user is recoverable without API request',
      (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    await tester.pumpWidget(MaterialApp(
        home: SettingNotificationPage(
      request: (_, __) async => throw StateError('Must not call API'),
    )));
    await tester.pumpAndSettle();
    expect(find.text('ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบอีกครั้ง'),
        findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    expect(find.text('ลองใหม่'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Load waits, normalizes missing fields and updates all settings safely',
      (tester) async {
    final read = Completer<dynamic>();
    final update = Completer<dynamic>();
    Map<String, dynamic>? sent;
    await tester.pumpWidget(
        MaterialApp(home: SettingNotificationPage(request: (url, data) {
      if (url.endsWith('/read')) return read.future;
      sent = Map<String, dynamic>.from(data);
      return update.future;
    })));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    read.complete({
      'status': 'S',
      'objectData': {
        'code': 'settings-1',
        'mainPage': false,
        'eventPage': 'true',
        'contactPage': 1,
        'knowledgePage': null,
        'warningPage': true,
      }
    });
    await tester.pumpAndSettle();
    expect(tester.widgetList<Switch>(find.byType(Switch)).elementAt(2).value,
        true);
    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(sent!['mainPage'], true);
    expect(sent!['username'], 'tester');
    expect(sent!['code'], 'settings-1');
    expect(sent!['warningPage'], true);
    expect(
        tester
            .widgetList<Switch>(find.byType(Switch))
            .every((s) => s.onChanged != null),
        true);
    // Pending save must not fade other switches or accept another write.
    final newsBefore =
        tester.widgetList<Switch>(find.byType(Switch)).elementAt(1).value;
    await tester.tap(find.byType(Switch).at(1));
    await tester.pump();
    expect(tester.widgetList<Switch>(find.byType(Switch)).elementAt(1).value,
        newsBefore);
    expect(sent!['newsPage'], false);
    update.complete({
      'status': 'S',
      'objectData': {'eventPage': false, 'warningPage': false}
    });
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(find.byType(Switch).first).value, true);
    final saved =
        jsonDecode((await storage.read(key: 'dataNotificationDDPM'))!);
    expect(saved['mainPage'], true);
    expect(saved['eventPage'], false);
    expect(saved['warningPage'], false);
    expect(saved['knowledgePage'], false);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Read failure retries; failed save rolls back and reports failure',
      (tester) async {
    var reads = 0;
    await tester.pumpWidget(
        MaterialApp(home: SettingNotificationPage(request: (url, data) async {
      if (url.endsWith('/read')) {
        if (++reads == 1) return {'status': 'F'};
        return {
          'status': 'S',
          'objectData': {'mainPage': false}
        };
      }
      throw StateError('Network unavailable');
    })));
    await tester.pumpAndSettle();
    expect(find.text('โหลดการตั้งค่าการแจ้งเตือนไม่สำเร็จ กรุณาลองใหม่'),
        findsOneWidget);
    await tester.tap(find.text('ลองใหม่'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(find.byType(Switch).first).value, false);
    expect(find.text('บันทึกการตั้งค่าไม่สำเร็จ กรุณาลองใหม่'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Back preserves previous route; pending read is safe after disposal',
      (tester) async {
    final read = Completer<dynamic>();
    await tester.pumpWidget(MaterialApp(
        home: Builder(
            builder: (context) => Scaffold(
                  body: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingNotificationPage(
                                request: (_, __) => read.future),
                          )),
                      child: const Text('เปิดตั้งค่า')),
                ))));
    await tester.tap(find.text('เปิดตั้งค่า'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    await tester.tap(find.byWidget(appBar.leading!));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    read.complete({'status': 'S', 'objectData': {}});
    await tester.pumpAndSettle();
    expect(find.text('เปิดตั้งค่า'), findsOneWidget);
    expect(find.byType(SettingNotificationPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Settings rows fit a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        home: SettingNotificationPage(
      request: (_, __) async => {'status': 'S', 'objectData': {}},
    )));
    await tester.pumpAndSettle();
    expect(find.byType(Switch), findsNWidgets(10));
    expect(tester.takeException(), isNull);
  });
}
