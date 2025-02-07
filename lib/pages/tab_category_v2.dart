import 'package:flutter/material.dart';

class CategorySelectorV2 extends StatefulWidget {
  CategorySelectorV2({Key? key, required this.site, required this.model, required this.onChange})
      : super(key: key);

//  final VoidCallback onTabCategory;
  final String site;
  final Function(String,String) onChange;
  final Future<dynamic> model;

  @override
  _CategorySelectorV2State createState() => _CategorySelectorV2State();
}

class _CategorySelectorV2State extends State<CategorySelectorV2> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return Container(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2,
              ),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onChange(snapshot.data[index]['code'],snapshot.data[index]['title']);
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? Colors.grey.shade200.withOpacity(0.5)
                            : Colors.transparent,
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data[index]['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
          );
        }
      },
    );
  }
  
}
