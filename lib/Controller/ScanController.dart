import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:iread/Activity/Chat.dart';
import 'package:iread/Database/DatabaseHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class ScanController extends GetxController {
  var _imagePath;
  var teks;
  var result = "".obs;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  var title = "".obs;
  DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> getImageFromCamera(BuildContext context, FlutterTts? tts) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      // log("tidak ijin");
      return;
    }

    // Generate filepath for saving
    String imagePath =
        "${(await getApplicationSupportDirectory()).path}-${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg";

    bool success = false;

    try {
      //Make sure to await the call to detectEdge.
      success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      print("success: $success");
    } catch (e) {
      print(e);
    }

    // if (!mounted) return;

    if (success == true) {
      _imagePath = imagePath;
    }

    final inputImage = InputImage.fromFile(File(_imagePath!));
    teks = await textRecognizer.processImage(inputImage);
    // log(teks!.text.toString().replaceAll("\n", " "));
    result.value = teks.text.toString();
    // setState(() {

    // });
    if (teks.text.toString() != null || teks.text.toString() != "") {
      // kondisi = true;
      var random = 2020 + Random().nextInt(9999);

      Database db = await dbHelper.database;
      /* simpan ke chat */
      await dbHelper.insertChat(
          judul: "Dokumen-$random", konten: result.value, image: _imagePath);
      print("sukses");

      await dbHelper.getLastChat().then((value) {
        var id = value[0]['id'];
        tts!.speak("Gambar selesai diproses, silahkan untuk mulai bertanya dengan menekan tahan tombol di posisi bawah layar ponsel anda, lalu lepas jika selesai berbicara");  
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      id_chat: id,
                      imgPath: _imagePath,
                      scanResult: result.value,
                    )));
      });

      // await controller.getChatGPTResponse(teks.text.toString().replaceAll("\n", " "));
    }
  }
}
