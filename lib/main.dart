import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iread/Activity/SplashScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Activity/Home.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            title: 'Moco.Ai',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromRGBO(111, 27, 72, 1)),
              useMaterial3: true,
            ),
            home: child,
          );
        },
        child: const SplashScreen());
  }
}
