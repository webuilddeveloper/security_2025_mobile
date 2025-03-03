import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/knowledge/knowledge_form.dart';

class KnowledgeListVertical extends StatefulWidget {
  KnowledgeListVertical({Key? key, required this.site}) : super(key: key);

  final String site;

  @override
  _KnowledgeListVertical createState() => _KnowledgeListVertical();
}

class _KnowledgeListVertical extends State<KnowledgeListVertical> {
  final List<Map<String, String>> modelData = [
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250228-113644-5a061fbc17b0e7020c52843c42dc4179.webp',
      'title': 'คู่มือการปฏิบัติงานสำหรับพนักงานรักษาความปลอดภัย',
      'code': 'K001',
    },
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250228-113644-5a061fbc17b0e7020c52843c42dc4179.webp',
      'title': 'คู่มือการปฏิบัติงานสำหรับพนักงานรักษาความปลอดภัย',
      'code': 'K001',
    },
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250228-113644-5a061fbc17b0e7020c52843c42dc4179.webp',
      'title': 'คู่มือการปฏิบัติงานสำหรับพนักงานรักษาความปลอดภัย',
      'code': 'K001',
    },
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250228-113644-5a061fbc17b0e7020c52843c42dc4179.webp',
      'title': 'คู่มือการปฏิบัติงานสำหรับพนักงานรักษาความปลอดภัย',
      'code': 'K001',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (modelData.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'ไม่พบข้อมูล',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Sarabun',
            color: Color.fromRGBO(0, 0, 0, 0.6),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.1,
        ),
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: modelData.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                width: 150,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeForm(
                          code: modelData[index]['code']!,
                          urlComment: '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 0.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        modelData[index]['imageUrl']!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 20 / 100,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Image.asset('assets/images/bar.png'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
