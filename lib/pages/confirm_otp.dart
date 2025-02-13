import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:pinput/pinput.dart';
import 'package:security_2025_mobile_v3/menu.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfirmOtp extends StatefulWidget {
  const ConfirmOtp({super.key});

  @override
  State<ConfirmOtp> createState() => _ConfirmOtpState();
}

class _ConfirmOtpState extends State<ConfirmOtp> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  bool isLoading = false;
  String pinCode = "";
  void goBack() => Navigator.pop(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, goBack,
          title: 'เข้าสู่ระบบด้วยหมายเลขโทรศัพท์', rightButton: null),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.phone_android,
                    size: 48,
                    color: Color(0XFFB03432),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'ป้อนรหัส OTP ของคุณเพื่อลงชื่อเข้าใช้',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'กรุณากรอกรหัส OTP',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'Sarabun',
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Pinput(
                      length: 6,
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 50,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: const Color(0XFFB03432),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(width: 2, color: Colors.grey.shade300),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 50,
                        height: 50,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: const Color(0XFFB03432),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0XFFB03432),
                            width: 2,
                          ),
                        ),
                      ),
                      // onCompleted: (pin) => print('PIN: $pin'),
                      onChanged: (value) {
                        setState(() {
                          print('--------value---------${value}');
                          pinCode = value; // อัปเดตค่า PIN
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ไม่ได้รับรหัส OTP ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Sarabun',
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'ส่งรหัส OTP อีกครั้ง',
                            style: TextStyle(
                                fontFamily: 'Sarabun',
                                color: Color(0XFFB03432)),
                          ))
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        print('--------pincode----------${pinCode}');
                        verifyOtp(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'ยืนยัน OTP',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Sarabun',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOtp(BuildContext context) async {
    final String otpCode = pinCode.trim();
    if (otpCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ กรุณากรอกรหัส OTP')),
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? refCode = prefs.getString('ref_code');

    if (token == null || refCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ ไม่พบ Token หรือ Ref Code')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> body = {
      "token": token,
      "otp_code": otpCode,
      "ref_code": refCode,
    };

    try {
      final Response response = await Dio().post(
        "https://portal-otp.smsmkt.com/api/otp-validate",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "api_key": "50b65b319f67b4cf9b8e8b6891690f8f",
            "secret_key": "j4L5ectwQEsOqRLB",
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data['result'] != null &&
          response.data['result']['status'] == true) {
        await prefs.setBool('otp_verified', true);

        String username = 'demo';
        String password = 'demo1234';
        String email = 's@gmail.com';
        String category = 'guest';

        String url = category == 'guest'
            ? 'm/Register/login'
            : 'm/Register/$category/login';

        final result = await postLoginRegister(url, {
          'username': username,
          'password': password,
          'category': category,
          'email': email,
        });

        if (result.status == 'S' || result.status == 's') {
          await storage.write(
              key: 'dataUserLoginDDPM', value: jsonEncode(result.objectData));
          storage.write(key: 'profileCode3', value: result.objectData?.code);
          storage.write(key: 'username', value: result.objectData?.username);
          storage.write(
              key: 'profileImageUrl', value: result.objectData?.imageUrl);
          storage.write(key: 'idcard', value: result.objectData?.idcard);
          storage.write(key: 'profileCategory', value: category);
          storage.write(
              key: 'profileFirstName', value: result.objectData?.firstName);
          storage.write(
              key: 'profileLastName', value: result.objectData?.lastName);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ ยืนยัน OTP สำเร็จ')),
          );

          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Menu(
                  pageIndex: 0,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          throw Exception(result.message ?? "❌ ไม่สามารถเข้าสู่ระบบได้");
        }
      } else {
        // throw Exception("❌ OTP ไม่ถูกต้อง");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return errorDialog();
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return errorDialog();
        },
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('❌ ตรวจสอบ OTP ล้มเหลว: $e')),
      // );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  errorDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Color(0XFFB03432),
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'รหัส OTP ไม่ถูกต้อง', // ใช้ค่าที่ส่งมาจาก parent widget
            style: TextStyle(
              color: Color(0XFFB03432),
              fontFamily: 'Sarabun',
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        'กรุณาตรวจสอบข้อมูลของท่านและลองใหม่อีกครั้ง',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFFB03432),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ตกลง',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
