import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImgurService {
  static const String clientId = '06b18f1dce2d317';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgur.com/3/upload'),
      );

      request.headers['Authorization'] = 'Client-ID $clientId';
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData.body);
        return jsonResponse['data']['link']; // Retorna a URL da imagem
      } else {
        print('Erro ao enviar imagem: ${responseData.body}');
        return null;
      }
    } catch (e) {
      print('Erro: $e');
      return null;
    }
  }
}
