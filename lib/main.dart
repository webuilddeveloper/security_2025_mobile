import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:security_2025_mobile_v3/splash.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'shared/api_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  LineSDK.instance.setup('2006508203').then((_) {
    print('LineSDK Prepared');
  });

  // await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // set bacground color notificationbar.
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    // portrait only.
    _portraitModeOnly();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // scaffoldBackgroundColor: Color(0xffe9ebee),
        primaryColor: Color(0XFFB03432),
        primaryColorDark: Color(0xFF9C0000),
        // accentColor: Color(0xFFFF7B06),
        // highlightColor: Color(0xFFC5DAFC),
        // primaryColorLight: Color(0xFFdec6c6),
        // unselectedWidgetColor: Color(0xFFFF7514),
        fontFamily: 'Sarabun',
      ),
      title: appName,
      home: SplashPage(),
      builder: (context, child) {
        return MediaQuery(
          child: child ?? SizedBox.shrink(),
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
        );
      },
    );
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter login UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Login(),
//     );
//   }
// }

// FutureBuilder<dynamic>(
//     future: _futureMenu, // function where you call your api
//     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//       if (snapshot.hasData) {
//         return _pageSuccess();
//       } else if (snapshot.hasError) {
//         return Container();
//       } else {
//         return Container();
//       }
//     },
//   )
