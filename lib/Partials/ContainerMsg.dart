import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iread/Model/ChatModel.dart';

class ContainerMessages extends StatelessWidget {
  ContainerMessages({super.key, this.chat, this.index, this.tts});

  var chat;
  int? index;
  FlutterTts? tts;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey,
        onTap: () async {
          await tts!.speak("${chat![index!].content}");
        },
        child: Padding(
          padding: EdgeInsets.only(
              left: 10.dm, right: 15.dm, top: 10.dm, bottom: 10.dm),
          child: Align(
            alignment: (chat![index!]!.type == "aku")
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Container(
              // width: 20.w,
              decoration: BoxDecoration(
                  color: (chat![index!].type == "aku")
                      ? const Color.fromRGBO(196, 113, 158, 1)
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.dm),
                      topRight: Radius.circular(10.dm))),
              child: Padding(
                padding: EdgeInsets.all(10.dm),
                child: Text(
                  "${chat![index!].content}",
                  style: TextStyle(fontFamily: "Raleway", fontSize: 13.sp),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
