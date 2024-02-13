import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Credit extends StatefulWidget {
  const Credit({Key? key}) : super(key: key);

  @override
  _CreditState createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(111, 27, 72, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Credit",
          style: TextStyle(color: Colors.white, fontFamily: "Raleway"),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Special Thanks for :",
              style: TextStyle(fontFamily: "Raleway", fontSize: 14.sp),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.deepPurple,
                spreadRadius: 2,
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(10.dm)),
            child: Padding(
                padding: EdgeInsets.all(10.dm),
                child: const Text(
                  "OpenAI-chatGPT Turbo 3.5",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Raleway"),
                )),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.deepPurple,
                spreadRadius: 2,
              ),
            ], color: Colors.white, borderRadius: BorderRadius.circular(10.dm)),
            child: Padding(
                padding: EdgeInsets.all(10.dm),
                child: const Text(
                  "HuggingFace",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Raleway"),
                )),
          ),
        ],
      ),
    );
  }
}
