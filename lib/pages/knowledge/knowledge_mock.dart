// ข้อมูล mock สำหรับคลังความรู้ (ใช้แทน API ชั่วคราว)

const String _pdfUrl =
    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

// รูป รปภ. จาก Unsplash (Unsplash License: ใช้ฟรี ไม่ต้องใส่เครดิต)
const String _imgParams = '?w=400&h=600&fit=crop&auto=format&q=70';

const List<String> _covers = [
  // K001 รปภ. เดินตรวจตราบนถนน
  'https://images.unsplash.com/photo-1652739758426-56a564265f9e$_imgParams',
  // K002 เจ้าหน้าที่ยืนเฝ้าทางเข้าอาคาร
  'https://images.unsplash.com/photo-1772375970027-514257024dcc$_imgParams',
  // K003 รปภ. ในเครื่องแบบ
  'https://images.unsplash.com/photo-1552622594-f27a9f6103a3$_imgParams',
  // K004 รปภ. ใส่หูฟังสื่อสาร
  'https://images.unsplash.com/photo-1529747598642-d0b4e3667314$_imgParams',
  // K005 เจ้าหน้าที่เดินตรวจกลางแจ้ง
  'https://images.unsplash.com/photo-1581568736305-49a04e012c13$_imgParams',
  // K006 เจ้าหน้าที่ในเครื่องแบบ
  'https://images.unsplash.com/photo-1566245024852-04fbf7842ce9$_imgParams',
  // K007 รปภ. ดูแลงานชุมนุม
  'https://images.unsplash.com/photo-1760228604788-db8a36d5c1a3$_imgParams',
  // K008 เจ้าหน้าที่ประจำสถานี
  'https://images.unsplash.com/photo-1589476993526-4b4317f5e188$_imgParams',
];

String _cover(int n) => _covers[(n - 1) % _covers.length];

final List<Map<String, dynamic>> knowledgeMock = [
  {
    'code': 'K001',
    'title': 'คู่มือการปฏิบัติงานสำหรับพนักงานรักษาความปลอดภัย',
    'imageUrl': _cover(1),
    'fileUrl': _pdfUrl,
    'createDate': '2025-02-28T11:36:44',
    'author': 'ฝ่ายฝึกอบรม',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'คู่มือ'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 48,
    'size': '2.4 MB',
    'description':
        '<p>คู่มือแนวทางการปฏิบัติงานสำหรับพนักงานรักษาความปลอดภัย ครอบคลุมขั้นตอนการตรวจตรา การรายงานเหตุ และการประสานงาน</p>',
  },
  {
    'code': 'K002',
    'title': 'การรับมือเหตุฉุกเฉินและการอพยพ',
    'imageUrl': _cover(2),
    'fileUrl': _pdfUrl,
    'createDate': '2025-03-05T09:00:00',
    'author': 'ฝ่ายความปลอดภัย',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'ความปลอดภัย'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 32,
    'size': '1.8 MB',
    'description':
        '<p>แนวทางรับมือเหตุเพลิงไหม้ แผ่นดินไหว และเหตุฉุกเฉินอื่น ๆ พร้อมแผนผังเส้นทางอพยพ</p>',
  },
  {
    'code': 'K003',
    'title': 'ระเบียบและข้อบังคับการเข้า-ออกพื้นที่',
    'imageUrl': _cover(3),
    'fileUrl': _pdfUrl,
    'createDate': '2025-03-12T10:30:00',
    'author': 'ฝ่ายอาคารสถานที่',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'ระเบียบ'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 20,
    'size': '900 KB',
    'description':
        '<p>สรุประเบียบการแลกบัตร การตรวจสอบบุคคลและยานพาหนะ ก่อนเข้า-ออกพื้นที่</p>',
  },
  {
    'code': 'K004',
    'title': 'การใช้งานกล้องวงจรปิดและระบบควบคุมการเข้าถึง',
    'imageUrl': _cover(4),
    'fileUrl': _pdfUrl,
    'createDate': '2025-03-20T14:15:00',
    'author': 'ฝ่ายเทคโนโลยี',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'เทคโนโลยี'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 56,
    'size': '3.1 MB',
    'description':
        '<p>วิธีใช้งานระบบกล้องวงจรปิด การเรียกดูภาพย้อนหลัง และการบันทึกหลักฐาน</p>',
  },
  {
    'code': 'K005',
    'title': 'การปฐมพยาบาลเบื้องต้น',
    'imageUrl': _cover(5),
    'fileUrl': _pdfUrl,
    'createDate': '2025-04-01T08:45:00',
    'author': 'ฝ่ายสุขภาพ',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'สุขภาพ'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 24,
    'size': '1.2 MB',
    'description':
        '<p>ความรู้ปฐมพยาบาลเบื้องต้นสำหรับเจ้าหน้าที่ เช่น การห้ามเลือด และการช่วยฟื้นคืนชีพ (CPR)</p>',
  },
  {
    'code': 'K006',
    'title': 'จรรยาบรรณและมารยาทในการให้บริการ',
    'imageUrl': _cover(6),
    'fileUrl': _pdfUrl,
    'createDate': '2025-04-10T13:00:00',
    'author': 'ฝ่ายบุคคล',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'จรรยาบรรณ'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 16,
    'size': '700 KB',
    'description':
        '<p>แนวทางการแต่งกาย การสื่อสาร และการให้บริการผู้มาติดต่ออย่างสุภาพ</p>',
  },
  {
    'code': 'K007',
    'title': 'การเขียนรายงานเหตุการณ์ประจำวัน',
    'imageUrl': _cover(7),
    'fileUrl': _pdfUrl,
    'createDate': '2025-04-18T16:20:00',
    'author': 'ฝ่ายปฏิบัติการ',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'คู่มือ'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 12,
    'size': '500 KB',
    'description':
        '<p>รูปแบบและตัวอย่างการเขียนรายงานเหตุการณ์ให้ครบถ้วน ชัดเจน</p>',
  },
  {
    'code': 'K008',
    'title': 'กฎหมายที่เกี่ยวข้องกับงานรักษาความปลอดภัย',
    'imageUrl': _cover(8),
    'fileUrl': _pdfUrl,
    'createDate': '2025-04-25T11:00:00',
    'author': 'ฝ่ายกฎหมาย',
    'publisher': 'สำนักงานรักษาความปลอดภัย',
    'categoryList': [
      {'title': 'กฎหมาย'}
    ],
    'bookType': 'PDF',
    'numberOfPages': 64,
    'size': '4.0 MB',
    'description':
        '<p>สรุปกฎหมายและข้อบังคับที่เจ้าหน้าที่รักษาความปลอดภัยควรทราบ</p>',
  },
];
