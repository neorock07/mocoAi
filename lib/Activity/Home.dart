// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:iread/Activity/Chat.dart';
import 'package:iread/Activity/ChatHistori.dart';
import 'package:iread/Activity/Credit.dart';
import 'package:iread/Activity/ImageCaption.dart';
import 'package:iread/Activity/ReadPage.dart';
import 'package:iread/Controller/ContohController.dart';
import 'package:iread/Controller/HistoriController.dart';
import 'package:iread/Controller/ScanController.dart';
import 'package:iread/Database/DatabaseHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = Get.put(CobaController());
  var scan = Get.put(ScanController());
  // List<Map<String, dynamic>>? dbController.all_chat;
  DatabaseHelper dbHelper = DatabaseHelper();
  var bento = Get.put(CobaController());
  FlutterTts tts = FlutterTts();
  var dbController = Get.put(HistoriController());

  String? _imagePath;
  var teks;
  bool? kondisi;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> getHistoriChat() async {
    await dbController.getAllChat();
  }

  @override
  void initState() {
    super.initState();
    getHistoriChat();
    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.5);
    tts.setVolume(1.0);
  }

  Future<void> vibrateDevice() async {
    // if (await Vibration.hasVibrator()) {
    // Periksa apakah perangkat mendukung getaran
    Vibration.vibrate(duration: 500); // Durasi getaran dalam milidetik
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        floatingActionButton: FloatingActionButton.large(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.dm)),
          onPressed: () async {
            vibrateDevice();
            await tts.speak("Saya dapat membantu membacakan").then((value) {
              Get.to(() => ReadPage());
            });
          },
          backgroundColor: const Color.fromRGBO(111, 27, 72, 1),
          child: const Icon(
            Icons.voice_chat,
            size: 30,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: IconButton.filled(
                  onPressed: () {
                    Get.to(() => Credit());
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
            )
          ],
          backgroundColor: Color.fromRGBO(111, 27, 72, 1),
          title: const Text(
            "Moco.Ai",
            style: TextStyle(color: Colors.white, fontFamily: "Raleway"),
          ),
        ),
        body: (kondisi == false)
            ? Padding(
                padding: EdgeInsets.only(top: 120.h),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
              )
            : Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.dm)),
                        child: Padding(
                          padding: EdgeInsets.all(8.dm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () async {
                                    // getImageFromCamera();
                                    // kondisi = false;
                                    await tts
                                        .speak("sken dokumen")
                                        .then((value) {
                                      scan.getImageFromCamera(context, tts);
                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            217, 217, 217, 0.247),
                                        border: Border.all(
                                            color:
                                                Color.fromRGBO(111, 27, 72, 1)),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_enhance,
                                            size: 40,
                                            color:
                                                Color.fromRGBO(111, 27, 72, 1),
                                          ),
                                          Text("Chat with Document",
                                              style: TextStyle(
                                                  fontFamily: "Raleway",
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      111, 27, 72, 1)))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  hoverColor: Colors.grey,
                                  // onTap: getImageFromGallery,
                                  onTap: () async {
                                    vibrateDevice();
                                    await tts
                                        .speak("lihat sekitar Anda")
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const ImageCaption()));
                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            217, 217, 217, 0.247),
                                        border: Border.all(
                                            color:
                                                Color.fromRGBO(111, 27, 72, 1)),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_search,
                                            size: 40,
                                            color:
                                                Color.fromRGBO(111, 27, 72, 1),
                                          ),
                                          Text(
                                            "See the world",
                                            style: TextStyle(
                                                fontFamily: "Raleway",
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    111, 27, 72, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      initialChildSize: 0.65,
                      builder: ((_, scroll) {
                        return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.dm),
                                    topRight: Radius.circular(25.dm))),
                            child:
                                // Text("${dbController.all_chat!.length}")
                                Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(15.dm),
                                  child: Text(
                                    "Histori Chat",
                                    style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 40.h),
                                  child:Obx(() => ListView.builder(
                                      controller: scroll,
                                      itemCount: (dbController.all_chat != null)
                                          ? dbController.all_chat!.length
                                          : 0,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: 3.dm,
                                              left: 7.dm,
                                              right: 7.dm),
                                          child: Container(
                                            // height: 20.h,

                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                splashColor: Colors.grey,
                                                hoverColor: Colors.grey,
                                                onTap: () {
                                                  // Get.snackbar("apa", "${dbController.all_chat![index]['id']}");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ChatHistori(
                                                              id_chat: dbController
                                                                      .all_chat![
                                                                  index]['id'],
                                                              image: dbController
                                                                          .all_chat![
                                                                      index]
                                                                  ['image'])));
                                                },
                                                child: Card(
                                                  // color: Colors.white,
                                                  elevation: 3.dm,
                                                  shadowColor:
                                                      Colors.deepPurple,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.dm),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.dm),
                                                      child: Row(children: [
                                                        const Icon(
                                                          Icons.chat,
                                                          size: 20,
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Text(
                                                          "${dbController.all_chat![index]['title']}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Raleway",
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );

                                        // Text("--${dbController.all_chat![index]}");
                                      }))),
                                ),
                              ],
                            ));
                      })),
                ],
              ));
  }
}
