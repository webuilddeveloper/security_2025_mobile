import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/models/user.dart';

class CardHorizontal extends StatefulWidget {
  CardHorizontal(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.userData,
      required this.nav,
      required this.model,
      required this.subTitle})
      : super(key: key);

  final String title;
  final String imageUrl;
  final User userData;
  final Function? nav;
  final String subTitle;
  final Future<dynamic> model;

  @override
  _CardHorizontal createState() => _CardHorizontal();
}

class _CardHorizontal extends State<CardHorizontal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.model,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                widget.nav!();
              },
              child: Container(
                alignment: Alignment.center,
                height: 120,
                child: InkWell(
                  onTap: widget.nav!(),
                  child: myCard(
                    title: widget.title,
                    imageUrl: widget.imageUrl,
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  myCard({String title = '', String subTitle = '', String imageUrl = ''}) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'Sarabun',
              // shadows: <Shadow>[
              //   Shadow(
              //     offset: Offset(0.0, 1.0),
              //     blurRadius: 5,
              //     color: Colors.grey,
              //   ),
              // ],
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: height * 1.5 / 100,
              color: Colors.white,
              fontFamily: 'Sarabun',
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 1.0),
                  blurRadius: 5,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
