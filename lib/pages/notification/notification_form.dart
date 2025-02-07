import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/button_close_back.dart';
import 'package:security_2025_mobile_v3/component/comment.dart';
import 'package:security_2025_mobile_v3/component/content.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

// ignore: must_be_immutable
class NotificationForm extends StatefulWidget {
  NotificationForm({
    Key? key,
    required this.url,
    required this.code,
    this.model,
    required this.urlComment,
    required this.urlGallery,
  }) : super(key: key);

  final String url;
  final String code;
  final dynamic model;
  final String urlComment;
  final String urlGallery;

  @override
  _NotificationForm createState() => _NotificationForm();
}

class _NotificationForm extends State<NotificationForm> {
  late Comment comment;
  late int _limit;

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code,
      url: widget.urlComment,
      model: post('${newsCommentApi}read',
          {'skip': 0, 'limit': _limit, 'code': widget.code}),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            // Expanded(
            //   child:
            Stack(
              // fit: StackFit.expand,
              // alignment: AlignmentDirectional.bottomCenter,
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: [
                Content(
                  code: widget.code,
                  url: widget.url,
                  model: widget.model,
                  urlGallery: widget.urlGallery,
                  pathShare: '',
                ),
                Positioned(
                  right: 0,
                  top: (height * 0.5 / 100),
                  child: Container(
                    child: buttonCloseBack(context),
                  ),
                ),
              ],
              // overflow: Overflow.clip,
            ),
            SizedBox(
              height: 50,
            )
            // ),
            // widget.urlComment != '' ? comment : Container(),
          ],
        ),
      ),
    );
  }
}
