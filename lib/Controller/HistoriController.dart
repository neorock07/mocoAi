import 'dart:developer';
import 'package:get/get.dart';
import 'package:iread/Database/DatabaseHelper.dart';
import 'package:iread/Model/ChatModel.dart';
import 'package:sqflite/sqflite.dart';

class HistoriController extends GetxController {
  DatabaseHelper dbHelper = DatabaseHelper();
  var histori_chat = <Map<String, dynamic>>[].obs;
  var all_chat = <Map<String, dynamic>>[].obs;
  var model = <ChatModel>[].obs;
  var mbuh = <String>[].obs;
  ChatModel? msg = ChatModel();
  

  Future<void> getAllChat() async {
    Database db = await dbHelper.database;
    all_chat.value = await dbHelper.getMessage();
  }


  Future<List<ChatModel>> getHistoriChat(int? id_chat) async {
    Database db = await dbHelper.database;
    histori_chat.value = await dbHelper.getMessageById(id_chat!);
    var pesan, tipe;
    log(histori_chat.value.toString());
    
    for (var data in histori_chat.value) {
      pesan = data['message'];
      tipe = data['type']; 
      log(pesan);
      log(tipe);
      msg = ChatModel(
          content: pesan,
          type: tipe);
      model.value.add(msg!);    
    }
    for(int i=0; i< model.length; i++){
      log("model : ${model.value[i].type} | ${model.value[i].content} ");
    }
    return model.value;
  }
}
