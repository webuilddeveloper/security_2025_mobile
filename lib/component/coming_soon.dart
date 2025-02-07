import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';
import 'package:security_2025_mobile_v3/component/button_close_back.dart';
import 'package:security_2025_mobile_v3/component/content_with_out_share.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:flutter/material.dart';

class ComingSoon extends StatefulWidget {
  ComingSoon({Key? key, required this.code, required this.title})
      : super(key: key);

  final String code;
  final String title;
  @override
  _ComingSoon createState() => _ComingSoon();
}

class _ComingSoon extends State<ComingSoon> {
  late Future<dynamic> _futureModel;
  @override
  void initState() {
    _futureModel = postDio(comingSoonApi, {'codeShort': widget.code});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: FutureBuilder<dynamic>(
            future: _futureModel,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data.length > 0) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Stack(
                        children: [
                          ContentWithOutShare(
                            code: snapshot.data[0]['code'],
                            model: snapshot.data[0],
                            urlGallery: comingSoonGalleryApi,
                            url: '',
                            urlRotation: '',
                          ),
                          Positioned(
                            right: 0,
                            top: 5,
                            child: Container(
                              child: buttonCloseBack(context),
                            ),
                          ),
                        ],
                      ),
                      // comment,
                    ],
                  );
                } else {
                  return _buildComing();
                }
              } else if (snapshot.hasError) {
                return _buildComing();
              } else {
                return BlankLoading(
                  width: null,
                  height: null,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _buildComing() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        'Coming Soon',
        style: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
}
