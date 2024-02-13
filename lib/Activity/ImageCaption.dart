import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:iread/Controller/CameraController.dart';
import 'package:iread/Controller/ContohController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';

class ImageCaption extends StatefulWidget {
  const ImageCaption({Key? key}) : super(key: key);

  @override
  _ImageCaptionState createState() => _ImageCaptionState();
}

class _ImageCaptionState extends State<ImageCaption> {
  // var camController = Get.put(CaptionController());

  CameraController? cameraController;
  String? result;
  var controller = Get.put(CobaController());
  var caption = "".obs;
  FlutterTts tts = FlutterTts();
  var isTap = false.obs;
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
    String dir = "${root.path}/MOCOAI/CAPTION";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: (isTap.value == true)
              ? FloatingActionButton.large(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.dm)),
                  onPressed: () async {
                    isTap.value = false;
                    result = null;
                    caption.value = "";
                    await tts.speak("mari kita lihat yang lain").then((value) {
                      setState(() {});
                    });
                  },
                  backgroundColor: const Color.fromRGBO(111, 27, 72, 1),
                  child: Icon(
                    Icons.restore,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              : FloatingActionButton.large(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.dm)),
                  onPressed: () async {
                    isTap.value = true;
                    await tts
                        .speak("Mohon tunggu saya sedang memproses gambar");
                    vibrateDevice();
                    if (!cameraController!.value.isTakingPicture) {
                      result = await takePicture();
                      log("path : $result");
                      setState(() {});

                      await controller
                          .getImageCaption(result!)!
                          .then((value) async {
                        caption.value = value['generated_text'];
                      });
                      await controller.translate(caption.value).then((value) {
                        caption.value = value;
                        log("terjemahan : ${controller.resultTranslate.value}");
                      });
                      await tts!.speak("${caption.value}");
                    }
                  },
                  backgroundColor: const Color.fromRGBO(111, 27, 72, 1),
                  child: Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(111, 27, 72, 1),
          // actions: [
          //   ElevatedButton(
          //     onPressed: ()async{
          //       await controller.translate("if you smell what the rock is cooking!").then((value) {
          //           caption.value = value;
          //           log("terjemahan : ${caption.value}");
          //         });
          //     },
          //     child: Text("Tekan"))
          // ],
          title: const Text(
            "Lihat Sekitar",
            style: TextStyle(color: Colors.white, fontFamily: "Raleway"),
          ),
        ),
        body: FutureBuilder(
            future: initCamera(),
            builder: (_, snap) {
              return (snap.connectionState == ConnectionState.done)
                  ? Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: (result != null)
                              ? Container(
                                  child: Padding(
                                  padding: EdgeInsets.all(20.dm),
                                  child: Image.file(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      File(result!)),
                                ))
                              : CameraPreview(cameraController!),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.grey,
                                onTap: () {},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.96,
                                  height: 200.h,
                                  // color: Colors.white,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.dm),
                                          topRight: Radius.circular(20.dm)),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.dm),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Obx(() => (caption.value != "")
                                          ? Text(
                                              "${caption.value}",
                                              style: TextStyle(
                                                  fontFamily: "Raleway"),
                                            )
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                  SpinKitPouringHourGlass(
                                                    color: Color.fromRGBO(
                                                        111, 27, 72, 1),
                                                  ),
                                                  Text(
                                                    "Memproses gambar...",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            111, 27, 72, 1),
                                                        fontFamily: "Raleway"),
                                                  )
                                                ])),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : SpinKitDoubleBounce(
                      color: Colors.deepPurple,
                    );
            }));
  }
}
