import 'package:flutter/material.dart';

class MenuGridItem extends StatefulWidget {
  MenuGridItem(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.isPrimaryColor,
      required this.nav,
      required this.isCenter,
      required this.subTitle})
      : super(key: key);

  final Function nav;
  final bool isPrimaryColor;
  final String imageUrl;
  final String title;
  final String subTitle;
  final bool isCenter;

  @override
  _MenuGridItem createState() => _MenuGridItem();
}

class _MenuGridItem extends State<MenuGridItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Expanded(
      flex: 3,
      child: InkWell(
        onTap: () {
          widget.nav();
        },
        child: Container(
          color: Colors.transparent,
          height: (width / 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: (height * 1) / 100),
                padding: EdgeInsets.all((width * 4) / 100),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary
                    ],
                    begin: Alignment.topLeft,
                    end: new Alignment(1, 0.0),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                height: 80,
                width: 80,
                child: Container(
                  child: Image.network(
                    widget.imageUrl,
                    // height: 50.0,
                    // color: Colors.red,
                    // height: (width * 15) / 100,
                    // width: (width * 15) / 100,
                  ),
                ),
              ),
              // SizedBox(height: (height * 1.5) / 100,),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 13.00,
                        fontFamily: 'Sarabun',
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  widget.subTitle != null
                      ? Container(
                          child: Text(
                            widget.subTitle != null ? widget.subTitle : '',
                            style: TextStyle(
                                fontSize: (height * 1.6) / 100,
                                fontFamily: 'Sarabun',
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : SizedBox(
                          height: 0.0,
                        ),
                ],
              )
              // Container(
              //   child: Text(
              //     widget.subTitle != null ? widget.subTitle : '',
              //     style: TextStyle(
              //         fontSize: (height * 1.1) / 100,
              //         fontFamily: 'Sarabun',
              //         color: Colors.white
              //     ),
              //     maxLines: 1,
              //     textAlign: TextAlign.center,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
