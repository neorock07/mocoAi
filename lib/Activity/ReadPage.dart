import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  CameraController? cameraController;
  var _imagePath;
  var teks;
  var result = "".obs;
  var isTap = false.obs;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  FlutterTts tts = FlutterTts();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.5);
    tts.setVolume(1.0);
  }

  Future<void> initCamera() async {
    var cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    await cameraController!.initialize();
  }

  Future<String> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String dir = "${root.path}/MOCOAI/READTHIS";
    await Directory(dir).create(recursive: true);
    String filePath = "${dir}/${DateTime.now()}.jpg";
    try {
      XFile? pic = await cameraController!.takePicture();
      pic!.saveTo(filePath);
    } catch (e) {
      log("error : ${e.toString()}");
      throw Exception("kesalahan berfikir");
    }
    return filePath;
  }

  Future<void> vibrateDevice() async {
    // if (await Vibration.hasVibrator()) {
    // Periksa apakah perangkat mendukung getaran
    Vibration.vibrate(duration: 500); // Durasi getaran dalam milidetik
    // }
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  void _detectText(String image) async {
    final inputImage = InputImage.fromFile(File(image));
    teks = await textRecognizer.processImage(inputImage);
    result.value = teks.text.toString();
    await tts.speak("${result.value.replaceAll('\n', ' ')}");
    // log(teks!.text.toString().replaceAll("\n", " "));
    log("nilai : ${result.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(111, 27, 72, 1),
        title: const Text(
          "Bantu Membaca",
          style: TextStyle(color: Colors.white, fontFamily: "Raleway"),
        ),
      ),
      body: FutureBuilder(
          future: initCamera(),
          builder: (_, snap) {
            return (snap.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ))
                : Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: CameraPreview(cameraController!),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.grey,
                              onTap: () async {
                                vibrateDevice();
                                if (!cameraController!.value.isTakingPicture) {
                                  _imagePath = await takePicture();
                                  setState(() {});
                                  _detectText(_imagePath);
                                  log("path : $_imagePath");
                                }
                              },
                              hoverColor: Colors.grey,
                              child: AnimatedContainer(
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width * 0.96,
                                height: 80.h,
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(111, 27, 72, 1),
                                    borderRadius: BorderRadius.circular(10.dm)),
                                child: Padding(
                                  padding: EdgeInsets.all(10.dm),
                                  child: Center(
                                    child: Icon(
                                      Icons.translate,
                                      size: 25.dm,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
          }),
    );
  }
}
