import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CobaController extends GetxController {
  var msg = "".obs;
  var resultTranslate = "".obs;

  Future<String> getChatGPTResponse(String message) async {
    final apiKey = dotenv.env["API_KEY"] ?? '';
    final endpointAi = dotenv.env["AI_CHAT"] ?? '';
    final endpoint = '$endpointAi';

    final response = await http.post(Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        // body: '{"model": "gpt-3.5-turbo","messages": [{"role": "system", "content": "You are a helpful assistant."}, {"role": "user", "content": "saya ada dokumen ini :\n  $message"}]}',
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "$message"}
          ]
        }));

    if (response.statusCode == 200) {
      msg.value =
          json.decode(response.body)['choices'][0]['message']['content'];
      return msg.value;
    } else {
      log(json.decode(response.body).toString());
      throw Exception('Failed to load response');
    }
  }

  Future<String> translate(String? text) async {
    final String tl_token = dotenv.env["TRANSLATE_KEY"] ?? '';
    final String endpoint = dotenv.env["TRANSLATE_ENDPOINT"] ?? '';
    final String authKey = dotenv.env["AUTHKEY"] ?? '';

    final response = await http.post(Uri.parse(endpoint),
        headers: {'Authorization': 'DeepL-Auth-Key $tl_token'},
        body: {'text': text, 'target_lang': 'ID'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // result = data['translation'][0]['text'];
      log("result : ${data['translations'][0]['text']}");
      resultTranslate.value = data['translations'][0]['text'];
      return resultTranslate.value!;
    } else {
      log("kode kesalahan : ${response.statusCode}");
      throw Exception("Kesalahan menerjemahkan");
    }
  }

  Future<Map<String, dynamic>> getImageCaption(String filePath) async {
    final String apiUrl = dotenv.env["AI_CAPTION2"] ?? '';
    final String token = dotenv.env["CAPTION_KEY2"] ?? '';
    final file = File(filePath);
    List<int> bytes = await file.readAsBytes();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/octet-stream",
      },
      body: bytes,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)[0];
      log('${data['generated_text']}');
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
