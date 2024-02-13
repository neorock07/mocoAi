import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:iread/Controller/ContohController.dart';
import 'package:iread/Controller/HistoriController.dart';
import 'package:iread/Controller/SpeakController.dart';
import 'package:iread/Database/DatabaseHelper.dart';
import 'package:iread/Model/ChatModel.dart';
import 'package:iread/Partials/ContainerDate.dart';
import 'package:iread/Partials/ContainerMsg.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vibration/vibration.dart';

class ChatHistori extends StatefulWidget {
  ChatHistori({super.key, this.id_chat, this.image});
  int? id_chat;
  String? image;
  @override
  _ChatHistoriState createState() => _ChatHistoriState();
}

class _ChatHistoriState extends State<ChatHistori> {
  SpeechToText _speech = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  var animController;
  var controller = Get.put(CobaController());
  var speakController = Get.put(SpeakController());
  FlutterTts tts = FlutterTts();
  ScrollController scrollController = ScrollController();
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>>? histori_chat;
  List<ChatModel>? model = [];
  var bongkar = Get.put(HistoriController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.5);
    tts.setVolume(1.0);
    bongkar.getHistoriChat(widget.id_chat).then((value) {
      setState(() {
        model = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // speakController.model.clear();
        // bongkar.histori_chat.value = [];
        model!.clear();
        log("panjang model setelah clear : ${model!.length}");
        // log("panjang histori setelah clear : ${bongkar.histori_chat.length}");
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(111, 27, 72, 1),
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: SafeArea(
                child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 50.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.dm,
                      width: 40.dm,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.dm)),
                      child: const Center(
                        child: Text(
                          "M",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Asisten Bot",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Raleway",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Online",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Raleway",
                                fontSize: 15.sp),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    color: Color.fromRGBO(255, 207, 233, 1),
                    child: (model!.length <= 0)? 
                    const CircularProgressIndicator(color: Colors.purple,)
                    : 
                     Obx(() => ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: bongkar.model.length + 1,
                        itemBuilder: ((context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Obx(() => ContainerDate(
                                      tanggal: (bongkar.histori_chat.length > 0)? bongkar.histori_chat.value[0]
                                          ['tanggal'] :DateTime.now().toString(),
                                      // tanggal: (model!.length > 0)
                                      //     ? bongkar.histori_chat.value[0]
                                      //         ['tanggal']
                                      //     : DateTime.now().toString(),
                                    )),
                                SizedBox(
                                  height: 10.dm,
                                ),
                                Container(
                                  height: 180.dm,
                                  width: 180.dm,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.dm),
                                      color: Color.fromRGBO(170, 86, 131, 1)),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.dm),
                                    child: (bongkar.histori_chat.value != null)
                                        ? Image.file(File(widget.image!))
                                        : Image.asset("assets/image/404.jpg"),
                                  ),
                                ),
                                // Obx(() => Text("${controller.msg.value}"))
                              ],
                            );
                          }
                          return ContainerMessages(
                            chat: model,
                            index: index - 1,
                            tts: tts,
                          );
                          // Obx(() => );
                          // Obx(() =>
                          //     );
                        })))
                    //  Obx(() => Text("${bongkar.model[0].content.toString()}"))

                    // Obx(() => )
                    // Obx(() =>
                    //     )
                    ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Color.fromRGBO(111, 27, 72, 1),
                )
              ],
            ),
          )),
    );
  }

  Future<void> vibrateDevice() async {
    // if (await Vibration.hasVibrator()) {
    // Periksa apakah perangkat mendukung getaran
    Vibration.vibrate(duration: 500); // Durasi getaran dalam milidetik
    // }
  }
}
