import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iread/Activity/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), (){
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Home())
        );
    });
  }
  
   @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
     overlays: SystemUiOverlay.values);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(111, 27, 72, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 80.dm,
                width: 80.dm,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.dm),
                    child: Image.asset("assets/image/logo.png"),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.dm)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Moco.Ai",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Raleway",
              ),
            )
          ],
        ));
  }
}
