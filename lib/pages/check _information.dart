import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/check_security_license.dart';

class VerifyStangPage extends StatefulWidget {
  const VerifyStangPage({Key? key}) : super(key: key);

  @override
  _VerifyStangPageState createState() => _VerifyStangPageState();
}

class _VerifyStangPageState extends State<VerifyStangPage> {
  final TextEditingController _idController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  bool _validateInput() {
    if (_idController.text.isEmpty) {
      setState(() => _errorMessage = "กรุณากรอกเลขเจ้าหน้าที่ สตง.");
      return false;
    }
    if (_idController.text.length != 6) {
      setState(() => _errorMessage = "เลขเจ้าหน้าที่ต้องมี 6 หลัก");
      return false;
    }
    setState(() => _errorMessage = null);
    return true;
  }

  Future<void> _verifyAccess() async {
    if (!_validateInput()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String enteredId = _idController.text.trim();

    if (enteredId == "123456") {
      // แสดงไอคอนและข้อความสำเร็จ
      setState(() {
        _successState = true;
        _isLoading = false;
      });

      // รอสักครู่ก่อนเปลี่ยนหน้า
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecurityLicense(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "รหัสไม่ถูกต้อง กรุณาลองอีกครั้ง";
        _isLoading = false;
      });
    }
  }

// เพิ่ม property ใหม่ใน State class
  bool _successState = false;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'ตรวจสอบสิทธิ์ สตง.',
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
        backgroundColor: Color(0XFFB03432),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'assets/logo/สตง.png',
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "กรุณากรอกเลขเจ้าหน้าที่ สตง.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                    "ระบบนี้สำหรับเจ้าหน้าที่สำนักงานการตรวจเงินแผ่นดิน (สตง.) เท่านั้น กรุณากรอกข้อมูลที่ได้รับอนุญาตเพื่อดำเนินการต่อ"),
                const SizedBox(height: 24),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  enabled:
                      !_isLoading && !_successState, // ปิดการแก้ไขเมื่อสำเร็จ
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    labelText: "เลขเจ้าหน้าที่",
                    labelStyle: TextStyle(
                      color: _successState ? Colors.green : Color(0XFFB03432),
                    ),
                    hintText: 'กรอกเลขเจ้าหน้าที่ 6 หลัก',
                    errorText: _errorMessage,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _successState ? Colors.green : Color(0XFFB03432),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _successState ? Colors.green : Color(0XFFB03432),
                      ),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10),
                      child: _successState
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.person, color: Color(0XFFB03432)),
                    ),
                    suffixIcon: _successState
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'ยืนยันสำเร็จ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyAccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFFB03432),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0XFFB03432),
                              ),
                            ),
                          )
                        : const Text(
                            "ตรวจสอบ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
