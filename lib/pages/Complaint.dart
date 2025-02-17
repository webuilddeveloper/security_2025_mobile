// import 'package:flutter/material.dart';

// class Complaint extends StatefulWidget {
//   const Complaint({super.key});

//   @override
//   State<Complaint> createState() => _ComplaintState();
// }

// class _ComplaintState extends State<Complaint> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'รับเรื่องร้องเรียน',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color(0XFFB03432),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0XFFB03432),
//                     const Color(0XFFB03432).withOpacity(0.9),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0XFFB03432).withOpacity(0.25),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Logo Container
//                   Container(
//                     height: 52,
//                     width: 52,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0XFFB03432).withOpacity(0.15),
//                           blurRadius: 8,
//                           spreadRadius: 1,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Image.asset(
//                           'assets/logo/logo.png',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         const Text(
//                           'เรื่องร้องเรียน',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.2),
//                               width: 1,
//                             ),
//                           ),
//                           child: const Text(
//                             '3', // หรือใช้ตัวแปรจำนวนเรื่องร้องเรียน
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Arrow with circle background
//                   Container(
//                     height: 32,
//                     width: 32,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.2),
//                         width: 1,
//                       ),
//                     ),
//                     child: const Center(
//                       child: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images.addAll(selectedImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แบบฟอร์มร้องเรียน'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'กรุณากรอกรายละเอียดการร้องเรียน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'หัวข้อร้องเรียน',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกหัวข้อร้องเรียน';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'รายละเอียด',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรายละเอียด';
                  }
                  return null;
                },
                onSaved: (value) => _description = value,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: Icon(Icons.photo_camera),
                label: Text('เพิ่มรูปภาพ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              if (_images.isNotEmpty) ...[
                Text(
                  'รูปภาพที่แนบ (${_images.length})',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            Image.network(
                              _images[index].path,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 24),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: ส่งข้อมูลไปยัง API
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ส่งข้อร้องเรียนเรียบร้อยแล้ว')),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'ส่งข้อร้องเรียน',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
