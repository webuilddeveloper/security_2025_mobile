import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/confirm_otp.dart';
import 'package:security_2025_mobile_v3/widget/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({super.key});

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  bool isLoading = false;
  bool showOtpField = false;
  bool otpRequested = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? refCode;
  String? token;

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
                    'กรอกเบอร์โทรศัพท์เพื่อรับรหัส OTP',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ระบบจะส่งรหัสผ่าน OTP ไปยังเบอร์โทรศัพท์ของคุณ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'Sarabun',
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  labelTextFormField('เบอร์โทรศัพท์'),
                  textFormPhoneField(
                    phoneController,
                    'เบอร์โทรศัพท์ (10 หลัก)',
                    'เบอร์โทรศัพท์ (10 หลัก)',
                    true,
                    false,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        requestOtp(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmOtp(),
                            ));
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
                              'ส่งรหัส OTP',
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

  Future<void> requestOtp(BuildContext context) async {
    final String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ กรุณากรอกหมายเลขโทรศัพท์'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Dio().post(
        "https://portal-otp.smsmkt.com/api/otp-send",
        data: {
          "project_key": "3107676ce5",
          "phone": phone,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "api_key": "50b65b319f67b4cf9b8e8b6891690f8f",
            "secret_key": "j4L5ectwQEsOqRLB",
          },
        ),
      );

      if (response.statusCode == 200) {
        final String refCode = response.data['result']['ref_code'];
        final String token = response.data['result']['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('phone', phone);
        await prefs.setString('ref_code', refCode);

        setState(() {
          showOtpField = true;
          otpRequested = true;
          otpController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ส่ง OTP สำเร็จ ( Ref: $refCode )'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception("❌ ไม่สามารถส่ง OTP ได้");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ส่ง OTP ล้มเหลว: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
