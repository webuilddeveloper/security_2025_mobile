import 'package:http/http.dart' as http;

class ApiServiceProvider {
  // static final String BASE_URL = "https://www.ibm.com/downloads/cas/GJ5QVQ7X";

  static Future<String> loadPDF(String path) async {
    var response = await http.get(Uri.parse(path));

    // fixflutter2 var dir = await getApplicationDocumentsDirectory();
    // File file = new File("${dir.path}/data.pdf");
    // file.writeAsBytesSync(response.bodyBytes, flush: true);
    // return file.path;
    return '';
  }
}
