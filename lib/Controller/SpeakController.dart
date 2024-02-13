import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iread/Controller/ContohController.dart';
import 'package:iread/Database/DatabaseHelper.dart';
import 'package:iread/Model/ChatModel.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sqflite/sqflite.dart';

class SpeakController extends GetxController {
  RxBool _isListening = false.obs;
  var _speech = SpeechToText().obs;
  // SpeechToText _speech = SpeechToText();
  var text = 'tekan tahan untuk berbicara'.obs;
  // List<ChatModel> model = [];
  ChatModel? msgModel = ChatModel();
  RxInt count = 0.obs;
  var controller = Get.put(CobaController());
  var model = <ChatModel>[].obs;
  // var isLoad = false.obs;
  DatabaseHelper dbHelper = DatabaseHelper();
  SpeechToText? tx = SpeechToText();

  @override
  void onInit() {
    tx = _speech.value;
    super.onInit();
  }

  void startListening() async {
    if (!_isListening.value) {
      tx = _speech.value;
      bool available = await tx!.initialize(
        onStatus: (status) {
          log('Speech-to-Text Status: $status');
        },
        onError: (error) {
          log('Speech-to-Text Error: $error');
        },
      );

      if (available) {
        // isLoad.value = true;
        tx!.listen(
          onResult: (result) {
            text.value = result.recognizedWords;
          },
        );

        _isListening.value = true;
      } else {
        print('Speech-to-Text not available');
      }
    }
  }

  Future<List<ChatModel>> stopListening(String? data, {FlutterTts? tts, int? id_chat}) async {
    if (_isListening.value) {
      tx = _speech.value;
      tx!.stop();
      // if (text.value != "tekan tahan untuk berbicara") {
      //   msgModel = ChatModel(content: text.value, type: "aku");
      //   // model.value!.add(msgModel!);
      //   model.value.add(msgModel!);
      //   _isListening.value = false;
      //   log("panjang model : ${model.value.length}");
      //   // count.value++;
      //   String question = "${text.value} ?\n${data}";
      //   Database db = await dbHelper.database;

      //   await dbHelper.insertMessage(
      //       id_chat: id_chat,
      //       msg: text.value,
      //       type: "aku",
      //       tanggal:
      //           DateFormat("dd-MMM-yyyy").format(DateTime.now()).toString());
      //   await controller.getChatGPTResponse("$question").then((value) async {
      //     msgModel = ChatModel(content: value, type: "bot");
      //     model.value.add(msgModel!);
      //     tts!.speak(value);

      //     await dbHelper.insertMessage(
      //         id_chat: id_chat,
      //         msg: value,
      //         type: "bot",
      //         tanggal:
      //             DateFormat("dd-MMM-yyyy").format(DateTime.now()).toString());
      //     // isLoad.value = false;
      //   });
      //   /* simpan ke chat */

      //   print("sukses");
      // }else{
      //   tts!.speak("Tekan dan Tahan tombol untuk mulai bicara lalu lepas jika sudah");
      // }
      msgModel = ChatModel(content: text.value, type: "aku");
        // model.value!.add(msgModel!);
        model.value.add(msgModel!);
        _isListening.value = false;
        log("panjang model : ${model.value.length}");
        // count.value++;
        String question = "${text.value} ?\n${data}";
        Database db = await dbHelper.database;

        await dbHelper.insertMessage(
            id_chat: id_chat,
            msg: text.value,
            type: "aku",
            tanggal:
                DateFormat("dd-MMM-yyyy").format(DateTime.now()).toString());
        await controller.getChatGPTResponse("$question").then((value) async {
          msgModel = ChatModel(content: value, type: "bot");
          model.value.add(msgModel!);
          tts!.speak(value);

          await dbHelper.insertMessage(
              id_chat: id_chat,
              msg: value,
              type: "bot",
              tanggal:
                  DateFormat("dd-MMM-yyyy").format(DateTime.now()).toString());
          // isLoad.value = false;
        });
        /* simpan ke chat */
        log("panjang model : ${model.length}");
        print("sukses");
    }
    return model.value;
  }
}
