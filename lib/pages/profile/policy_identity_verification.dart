import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/dialog_fail.dart';
import 'package:security_2025_mobile_v3/pages/profile/user_information.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class PolicyIdentityVerificationPage extends StatefulWidget {
  PolicyIdentityVerificationPage({Key? key, required this.username})
      : super(key: key);
  final String username;

  @override
  _PolicyIdentityVerificationPageState createState() =>
      _PolicyIdentityVerificationPageState();
}

class _PolicyIdentityVerificationPageState
    extends State<PolicyIdentityVerificationPage> {
  final storage = new FlutterSecureStorage();

  List<dynamic> _dataPolicy = [];
  late Future<dynamic> futureModel;
  ScrollController scrollController = new ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      futureModel = readPolicy();
    });

    super.initState();
  }

  Future<dynamic> readPolicy() async {
    final result = await postObjectData("m/policy/read", {
      "category": "application",
      "username": widget.username,
    });

    if (result['status'] == 'S') {
      if (result['objectData'].length > 0) {
        for (int i = 0; i < result['objectData'].length; i++) {
          result['objectData'][i]['isActive'] = "";
          result['objectData'][i]['agree'] = false;
          result['objectData'][i]['noAgree'] = false;
        }
        setState(() {
          _dataPolicy = result['objectData'];
        });
      }
    }
  }

  Future<dynamic> updatePolicy() async {
    if (_dataPolicy.length > 0) {
      for (int i = 0; i < _dataPolicy.length; i++) {
        await postObjectData("m/policy/create", {
          "username": widget.username.toString(),
          "reference": _dataPolicy[i]['code'].toString(),
          "isActive": _dataPolicy[i]['isActive'] != ""
              ? _dataPolicy[i]['isActive']
              : false,
        });
      }
    }
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'บันทึกข้อมูลเรียบร้อย',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(''),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      color: Color(0xFF000070),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => UserInformationPage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> sendPolicy() async {
    var index = _dataPolicy
        .indexWhere((c) => c['isActive'] == "" && c['isRequired'] == true);

    if (index == -1) {
      updatePolicy();
    } else {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: CupertinoAlertDialog(
                title: new Text(
                  'กรุณาตรวจสอบและยอมรับนโยบายทั้งหมด',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Sarabun',
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                content: Text(''),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: new Text(
                      "ตกลง",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Sarabun',
                        color: Color(0xFF000070),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          });
    }
  }

  void checkIsActivePolicy(index, isActive) async {
    if (isActive) {
      _dataPolicy[index].agree = _dataPolicy[index].agree ? false : true;
      _dataPolicy[index].isActive = _dataPolicy[index].agree ? true : "";
      _dataPolicy[index].noAgree = false;
    } else {
      _dataPolicy[index].noAgree = _dataPolicy[index].noAgree ? false : true;
      _dataPolicy[index].isActive = _dataPolicy[index].noAgree ? false : "";
      _dataPolicy[index].agree = false;
    }
    this.setState(() {
      _dataPolicy = _dataPolicy;
    });
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(padding: EdgeInsets.all(10), child: formContentStep1()),
    );
  }

  formContentStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var item in _dataPolicy)
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      item['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  new Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Sarabun',
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  new Html(
                    data: item['description'].toString(),
                    onLinkTap:
                        (String? url, Map<String, String> attributes, element) {
                      launch(url!);
                      //open URL in webview, or launch URL in browser, or any other logic here
                    },
                  ),

                  // new HtmlView(
                  //   data: item['description'].toString(),
                  //   scrollable:
                  //       false, //false to use MarksownBody and true to use Marksown
                  // ),
                  if (item['isRequired'])
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: item['agree'] == true
                                  ? Colors.white
                                  : Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: item['agree'] == true
                                      ? Colors.red
                                      : Colors.white,
                                ),
                              ),
                              backgroundColor: item['agree'] == true
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                item['noAgree'] = false;
                                item['agree'] = true;
                                item['isActive'] = item['agree'] ? true : '';
                              });
                            },
                            child: Text(
                              'ยินยอม',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Sarabun',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: item['noAgree'] == true
                                  ? Colors.white
                                  : Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: item['noAgree'] == true
                                      ? Colors.red
                                      : Colors.white,
                                ),
                              ),
                              backgroundColor: item['noAgree'] == true
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                item['agree'] = false;
                                item['noAgree'] = true;
                                item['isActive'] = item['noAgree'] ? true : '';
                              });
                            },
                            child: Text(
                              'ไม่ยินยอม',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Sarabun',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(
                  color: Color(0xFF000070),
                ),
              ),
              backgroundColor: Color(0xFF000070),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              sendPolicy();
            },
            child: Text(
              'ตกลง',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => UserInformationPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(child: Text('Please wait its loading...'));
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
          return Center(
            child: Image.asset(
              "assets/background/login.png",
              fit: BoxFit.cover,
            ),
          );
        } else {
          if (snapshot.hasError)
            return Center(
              child: Container(
                color: Colors.white,
                child: dialogFail(context),
              ),
            );
          else
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background/login.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: Scaffold(
                  // appBar: header(context, goBack),
                  backgroundColor: Colors.transparent,
                  body: Container(
                    child: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      children: <Widget>[
                        new Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            card(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
