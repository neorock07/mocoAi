import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:iread/Controller/ContohController.dart';
import 'package:iread/Controller/HistoriController.dart';
import 'package:iread/Controller/SpeakController.dart';
import 'package:iread/Model/ChatModel.dart';
import 'package:iread/Partials/ContainerDate.dart';
import 'package:iread/Partials/ContainerMsg.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vibration/vibration.dart';

class Chat extends StatefulWidget {
  Chat({super.key, this.imgPath, this.scanResult, this.id_chat});
  String? imgPath;
  String? scanResult;
  int? id_chat;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  SpeechToText _speech = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  var animController;
  var controller = Get.put(CobaController());
  var speakController = Get.put(SpeakController());
  FlutterTts tts = FlutterTts();
  ScrollController scrollController = ScrollController();
  var dbController = Get.put(HistoriController());
  var model = <ChatModel>[];

  Future<void> getHistoriChat() async {
    await dbController.getAllChat();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tts.setLanguage("id-ID");
    tts.setSpeechRate(0.5);
    tts.setVolume(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        speakController.model.value.clear();
        speakController.text.value = "tekan tahan untuk berbicara";
        widget.imgPath = "";
        getHistoriChat();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            // actions: [
            //   ElevatedButton(
            //       onPressed: () async {
            //         // await controller
            //         //     .getChatGPTResponse("berikan riddle yang menarik")
            //         //     .then((value) {
            //         //   msgModel = ChatModel(content: value, type: "bot");
            //         //   model.add(msgModel!);
            //         //   setState(() {});
            //         // });
            //         // await controller.getChatGPTResponse(
            //         //     '$_text ${widget.scanResult.toString().replaceAll("\n", " ")}');
            //         // await tts.speak("hallo ini saya");
            //         log("dowo ne chat : ${speakController.model.value.length}");
            //         log("${speakController.model.value.toString()}");
            //       },
            //       child: Text("Tekan"))
            // ],
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
                    height: MediaQuery.of(context).size.height * 0.62,
                    color: Color.fromRGBO(255, 207, 233, 1),
                    child:
                    ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        // itemCount: speakController.model.value.length + 1,
                        itemCount: model.length + 1,
                        itemBuilder: ((context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                ContainerDate(),
                                SizedBox(
                                  height: 10.dm,
                                ),
                                Container(
                                  height: 180.dm,
                                  width: 180.dm,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.dm),
                                      color: Color.fromRGBO(170, 86, 131, 1)),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.dm),
                                    child: (widget.imgPath != null)
                                        ? Image.file(File(widget.imgPath!))
                                        : Image.asset("assets/image/404.jpg"),
                                  ),
                                ),
                                // Obx(() => Text("${controller.msg.value}"))
                              ],
                            );
                          }
                          return ContainerMessages(
                                chat: model,
                                // chat: speakController.model.value,
                                index: index - 1,
                                tts: tts,
                              ); 
                          // Obx(() => );
                          // Obx(() => );
                          // Obx(() =>
                          //     );
                        })) 
                    // Obx(
                    //   () => 
                    //   )
                    // Obx(() =>
                    //     )
                    ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Color.fromRGBO(111, 27, 72, 1),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 50.h,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(170, 86, 131, 1),
                                borderRadius: BorderRadius.circular(10.dm)),
                            child: Center(
                              child: Obx(
                                  () => Text("${speakController.text.value}")),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onLongPress: () {
                              // _startListening();
                              speakController.startListening();
                              vibrateDevice();
                              setState(() {
                                
                              });
                            },
                            onLongPressUp: () async{
                             await speakController.stopListening(widget.scanResult,
                                  tts: tts, id_chat: widget.id_chat).then((value){
                                     model = value; 
                                  });
                              setState(() {
                                
                              });
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
                            child: Container(
                              height: 100.dm,
                              width: 100.dm,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(170, 86, 131, 1),
                                  borderRadius: BorderRadius.circular(60.dm)),
                              child: Padding(
                                padding: EdgeInsets.all(10.dm),
                                child: Container(
                                  height: 80.dm,
                                  width: 80.dm,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(196, 113, 158, 1),
                                      borderRadius: BorderRadius.circular(60.dm)),
                                  child: Lottie.network(
                                      "https://lottie.host/28288e26-7ba9-4d7e-9de6-094e84c36381/GagMBnf1VZ.json"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
